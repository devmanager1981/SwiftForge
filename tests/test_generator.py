import pytest
from agents.autogen_agents import generate_agent

def test_generate_scenarios_basic():
    fields = {
        "DebtorAccount": "XYZ123",
        "Currency": "USD",
        "RequestedExecutionDate": "2025-11-01"
    }
    output = generate_agent.generate(fields, msg_type="pacs.008")
    assert isinstance(output, str)
    assert "Scenario:" in output
    assert "Given" in output
    assert "When" in output
    assert "Then" in output

def test_generate_with_empty_fields():
    output = generate_agent.generate({}, msg_type="pacs.008")
    assert isinstance(output, str)
    assert "Scenario:" in output  # Should still generate a fallback scenario

def test_generate_with_invalid_msg_type():
    fields = {"DebtorAccount": "XYZ123"}
    output = generate_agent.generate(fields, msg_type="unknown")
    assert isinstance(output, str)
    assert "Scenario:" in output
