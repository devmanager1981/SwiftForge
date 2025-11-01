import json
from agents.utils import setup_logger
from agents.llm_client import call_llm
import logging

logger = setup_logger("Scenario_Generator", level=logging.WARNING)

def build_prompt(fields: dict) -> str:
    return f"""
You are a test automation assistant. Based on the following ISO 20022 message fields, generate 3 Gherkin-style test scenarios in JSON format. Each scenario must include:

- tag (e.g. @pacs008 @positive, @edge @invalid_bic)
- title (short descriptive name)
- given (no duplicate 'Given' prefix)
- when (no duplicate 'When' prefix)
- then (no duplicate 'Then' prefix)

Fields:
{json.dumps(fields, indent=2)}

Output format:
[
  {{
    "tag": "...",
    "title": "...",
    "given": "...",
    "when": "...",
    "then": "..."
  }},
  ...
]
"""

def generate_scenarios(fields: dict) -> list:
    prompt = build_prompt(fields)
    response = call_llm(prompt)

    try:
        scenarios = json.loads(response)
        return [s for s in scenarios if isinstance(s, dict) and all(k in s for k in ["tag", "title", "given", "when", "then"])]
    except Exception:
        return []
