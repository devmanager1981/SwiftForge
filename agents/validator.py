# agents/validator.py

from agents.utils import setup_logger
import logging

logger = setup_logger("Validator", level=logging.WARNING)

def validate_fields(data: dict) -> list:
    """
    Validates extracted ISO 20022 fields.
    Returns a list of issues found.
    """
    issues = []

    try:
        # Message ID check
        if not any(data.get(k) for k in ["MsgId", "StatementId", "NotificationId"]):
            issues.append("Missing message identifier (MsgId / StatementId / NotificationId)")

        # Amount check
        amount = data.get("Amount") or data.get("Balance")
        if amount is None:
            issues.append("Missing amount or balance")
        else:
            try:
                amt_val = float(amount)
                if amt_val <= 0:
                    issues.append("Amount must be greater than zero")
            except ValueError:
                issues.append("Amount is not a valid number")

        # BIC check (for pacs.008 / pacs.009)
        if "DebtorBIC" in data or "CreditorBIC" in data:
            if not data.get("DebtorBIC"):
                issues.append("Missing Debtor BIC")
            if not data.get("CreditorBIC"):
                issues.append("Missing Creditor BIC")

        # IBAN check (for camt.053 / camt.054)
        if "IBAN" in data and not data["IBAN"]:
            issues.append("Missing IBAN")

        logger.info(f"✅ Validation complete: {issues if issues else 'No issues found'}")
        return issues

    except Exception as e:
        logger.error(f"❌ Validation failed: {e}")
        return ["Validation error"]
