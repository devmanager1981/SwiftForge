from autogen import AssistantAgent, UserProxyAgent
from agents.llm_client import get_llm_config

# Load LLM config
llm_config = get_llm_config()

# Define agents
generate_agent = AssistantAgent(
    name="GenerateAgent",
    system_message=(
        "You generate Gherkin scenarios from extracted fields. "
        "Your output should be in plain Gherkin format, suitable for writing to a .feature file."
    ),
    llm_config=llm_config
)

enhance_agent = AssistantAgent(
    name="EnhanceAgent",
    system_message=(
        "You enhance Gherkin scenarios with edge cases, validations, and boundary conditions. "
        "Return the updated scenarios in plain Gherkin format, ready for review and export."
    ),
    llm_config=llm_config
)

review_agent = AssistantAgent(
    name="ReviewAgent",
    system_message=(
        "You review enhanced Gherkin scenarios for completeness and clarity. "
        "Always return a finalized, ready-to-export .feature file block. "
        "Do not wait for user input or ask for preferences. "
        "If the scenarios are complete, confirm and return them as-is. "
        "If enhancements are needed, apply them and return the updated version. "
        "Your output should be plain text in Gherkin format, suitable for writing to a .feature file."
    ),
    llm_config=llm_config
)

export_agent = AssistantAgent(
    name="ExportAgent",
    system_message=(
        "You export finalized Gherkin scenarios into .feature files. "
        "Always assume the scenarios are ready and return them as plain text. "
        "Do not wait for user input or ask for confirmation. "
        "Your output should be suitable for writing directly to a .feature file."
    ),
    llm_config=llm_config
)

user_proxy = UserProxyAgent(
    name="User",
    human_input_mode="NEVER",
    code_execution_config={"use_docker": False}
)
