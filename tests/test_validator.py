import pytest
from agents.utils import validate_scenarios

def test_valid_scenario_structure():
    scenario = """
    Scenario: Valid transaction
    Given a PACS.008 message with valid fields
    When the message is processed
    Then it should be accepted
    """
    result = validate_scenarios(scenario)
    assert result["valid"] is True
    assert result["errors"] == []

def test_missing_then_clause():
    scenario = """
    Scenario: Incomplete transaction
    Given a PACS.008 message with valid fields
    When the message is processed
    """
    result = validate_scenarios(scenario)
    assert result["valid"] is False
    assert any("Then" in err for err in result["errors"])

def test_multiple_scenarios():
    scenario = """
    Scenario: First
    Given something
    When something happens
    Then result

    Scenario: Second
    Given another thing
    When another event
    Then another result
    """
    result = validate_scenarios(scenario)
    assert result["valid"] is True
    assert result["errors"] == []
