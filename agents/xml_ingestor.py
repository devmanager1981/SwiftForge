# agents/xml_ingestor.py
import logging
from lxml import etree
from agents.utils import setup_logger, safe_get

logger = setup_logger("XMLIngestor", level=logging.WARNING)

NS_MAP = {
    "pacs.008": {"ns": "urn:iso:std:iso:20022:tech:xsd:pacs.008.001.10"},
    "pacs.009": {"ns": "urn:iso:std:iso:20022:tech:xsd:pacs.009.001.08"},
    "camt.053": {"ns": "urn:iso:std:iso:20022:tech:xsd:camt.053.001.08"},
    "camt.054": {"ns": "urn:iso:std:iso:20022:tech:xsd:camt.054.001.08"},
}

def parse_xml(file_path: str):
    try:
        with open(file_path, "r", encoding="utf-8") as f:
            return etree.fromstring(f.read().encode())
    except Exception as e:
        logger.error(f"❌ Failed to parse XML: {file_path} — {e}")
        return None

def extract_fields(root, msg_type: str) -> dict:
    ns = NS_MAP.get(msg_type)
    if not ns or root is None:
        logger.warning(f"⚠️ Invalid message type or root: {msg_type}")
        return {}

    try:
        if msg_type == "pacs.008":
            amt_elem = root.find(".//ns:IntrBkSttlmAmt", ns)
            return {
                "MsgId": safe_get(root, ".//ns:GrpHdr/ns:MsgId", ns),
                "DebtorBIC": safe_get(root, ".//ns:DbtrAgt/ns:FinInstnId/ns:BICFI", ns),
                "CreditorBIC": safe_get(root, ".//ns:CdtrAgt/ns:FinInstnId/ns:BICFI", ns),
                "Amount": amt_elem.text if amt_elem is not None else None,
                "Currency": amt_elem.get("Ccy") if amt_elem is not None else None
            }

        elif msg_type == "pacs.009":
            amt_elem = root.find(".//ns:IntrBkSttlmAmt", ns)
            return {
                "MsgId": safe_get(root, ".//ns:GrpHdr/ns:MsgId", ns),
                "DebtorBIC": safe_get(root, ".//ns:DbtrAgt/ns:FinInstnId/ns:BICFI", ns),
                "CreditorBIC": safe_get(root, ".//ns:CdtrAgt/ns:FinInstnId/ns:BICFI", ns),
                "Amount": amt_elem.text if amt_elem is not None else None,
                "Currency": amt_elem.get("Ccy") if amt_elem is not None else None
            }

        elif msg_type == "camt.053":
            return {
                "StatementId": safe_get(root, ".//ns:Stmt/ns:Id", ns),
                "IBAN": safe_get(root, ".//ns:Acct/ns:Id/ns:IBAN", ns),
                "Balance": safe_get(root, ".//ns:Bal/ns:Amt", ns)
            }

        elif msg_type == "camt.054":
            return {
                "NotificationId": safe_get(root, ".//ns:Ntfctn/ns:Id", ns),
                "IBAN": safe_get(root, ".//ns:Acct/ns:Id/ns:IBAN", ns),
                "Amount": safe_get(root, ".//ns:Ntry/ns:Amt", ns),
                "CreditDebit": safe_get(root, ".//ns:Ntry/ns:CdtDbtInd", ns)
            }

        logger.warning(f"⚠️ No extraction logic defined for {msg_type}")
        return {}

    except Exception as e:
        logger.error(f"❌ Error extracting fields from {msg_type}: {e}")
        return {}

def parse_and_extract(xml_string: str, msg_type: str) -> dict:
    """
    LangChain-compatible wrapper: accepts raw XML string and message type.
    """
    try:
        root = etree.fromstring(xml_string.encode())
        fields = extract_fields(root, msg_type)
        logger.info(f"✅ Parsed and extracted fields for {msg_type}: {fields}")
        return fields
    except Exception as e:
        logger.error(f"❌ Failed to parse and extract: {e}")
        return {}
