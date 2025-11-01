from agents.utils import setup_logger
import logging

logger = setup_logger("Reviewer", level=logging.WARNING)

def tag_scenarios(scenarios: list) -> list:
    tagged = []

    for s in scenarios:
        if not isinstance(s, dict):
            continue

        tag = s.get("tag", "").lower()
        title = s.get("title", "").lower()
        given = s.get("given", "").lower()
        then = s.get("then", "").lower()

        if "zero" in given or "invalid" in title or "reject" in then:
            s["tag"] += " @reviewed @edge_case"
        elif "audit" in title or "trace" in given:
            s["tag"] += " @reviewed @audit"
        else:
            s["tag"] += " @reviewed @positive"

        tagged.append(s)

    return tagged
