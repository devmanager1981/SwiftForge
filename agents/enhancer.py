import json
from agents.utils import setup_logger
from agents.llm_client import call_llm
import logging

logger = setup_logger("Enhancer", level=logging.WARNING)

def build_edge_case_prompt(scenario: dict) -> str:
    return f"""
You are a test automation assistant. Enhance the following Gherkin scenario by generating one edge case scenario (e.g. zero amount, invalid IBAN, missing BIC). Return only the new scenario in JSON format with keys: tag, title, given, when, then.

Original scenario:
{json.dumps(scenario, indent=2)}
"""

def enhance_scenarios(scenarios: list) -> list:
    enhanced = []

    for s in scenarios:
        if not isinstance(s, dict) or not all(k in s for k in ["tag", "title", "given", "when", "then"]):
            continue

        enhanced.append(s)

        prompt = build_edge_case_prompt(s)
        response = call_llm(prompt)

        try:
            edge = json.loads(response)
            if isinstance(edge, dict) and all(k in edge for k in ["tag", "title", "given", "when", "then"]):
                enhanced.append(edge)
        except Exception:
            continue

    return enhanced
