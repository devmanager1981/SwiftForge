import os
import json
from datetime import datetime
from chains.autogen_orchestrator import run_orchestrator  # Make sure this points to the updated orchestrator
from agents.utils import setup_logger
from agents.llm_client import LLM_CALL_COUNT, LLM_TOKEN_ESTIMATE

logger = setup_logger("AutoGenRunner")

DATA_DIR = "data"
FILES = {
    "pacs.008": "pacs.008.xml",
    "pacs.009": "pacs.009.xml",
    "camt.053": "camt.053.xml",
    "camt.054": "camt.054.xml",
}

def main():
    logger.info("Starting AutoGen pipeline for all message types...\n")

    summary = {}
    run_stats = []

    for msg_type, filename in FILES.items():
        path = os.path.join(DATA_DIR, filename)
        if not os.path.exists(path):
            logger.warning(f"File not found: {path}")
            summary[msg_type] = "File missing"
            continue

        with open(path, "r", encoding="utf-8") as f:
            xml_string = f.read()

        logger.info(f"\nProcessing {msg_type.upper()}...")
        try:
            # Updated to return both file path and MLflow run ID
            result = run_orchestrator(xml_string, msg_type=msg_type)
            if isinstance(result, tuple):
                output_file, run_id = result
            else:
                output_file, run_id = result, None

            summary[msg_type] = "Processed"

            run_stats.append({
                "msg_type": msg_type,
                "timestamp": datetime.now().isoformat(),
                "llm_calls": LLM_CALL_COUNT,
                "estimated_tokens": LLM_TOKEN_ESTIMATE,
                "output_file": output_file,
                "mlflow_run_id": run_id
            })

        except Exception as e:
            logger.error(f"Error processing {msg_type}: {str(e)}")
            summary[msg_type] = f"Error: {str(e)}"

    # Summary Report
    logger.info("\nSummary Report:")
    for msg_type, status in summary.items():
        logger.info(f" - {msg_type.upper()}: {status}")

    # Save run stats to JSON
    stats_path = "output/run_summary.json"
    os.makedirs("output", exist_ok=True)
    with open(stats_path, "w", encoding="utf-8") as f:
        json.dump(run_stats, f, indent=2)

    logger.info(f"\nRun summary saved to {stats_path}")


if __name__ == "__main__":
    main()
