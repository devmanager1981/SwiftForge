import os
import json
from datetime import datetime
from agents.utils import setup_logger
from agents.llm_client import LLM_CALL_COUNT, LLM_TOKEN_ESTIMATE
import logging

logger = setup_logger("Exporter", level=logging.WARNING)

def export_feature_file(scenarios: list, filename: str = "output.feature", output_dir: str = "output", number_scenarios: bool = False):
    os.makedirs(output_dir, exist_ok=True)
    full_path = os.path.join(output_dir, filename)
    count = 0

    with open(full_path, "w", encoding="utf-8") as f:
        f.write("Feature: Generated Scenarios\n\n")
        for i, s in enumerate(scenarios, 1):
            # ✅ Support raw string scenarios
            if isinstance(s, str):
                f.write(s.strip() + "\n\n")
                count += 1
                continue

            # ✅ Support structured dict scenarios
            if isinstance(s, dict) and all(k in s for k in ["tag", "title", "given", "when", "then"]):
                title = f"{i}. {s['title']}" if number_scenarios else s["title"]
                f.write(f"{s['tag']}\n")
                f.write(f"Scenario: {title}\n")
                f.write(f"  Given {s['given']}\n")
                f.write(f"  When {s['when']}\n")
                f.write(f"  Then {s['then']}\n\n")
                count += 1

    # Save stats
    stats = {
        "timestamp": datetime.now().isoformat(),
        "scenarios_written": count,
        "llm_calls": LLM_CALL_COUNT,
        "estimated_tokens": LLM_TOKEN_ESTIMATE,
        "output_file": full_path
    }

    stats_path = os.path.join(output_dir, f"{filename.replace('.feature', '')}_stats.json")
    with open(stats_path, "w", encoding="utf-8") as log_file:
        json.dump(stats, log_file, indent=2)

    print(f"{count} scenarios written to {full_path}")
    print(f"Stats saved to: {stats_path}")
    return full_path
