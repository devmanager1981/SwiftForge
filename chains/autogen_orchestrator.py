import os
import json
import io
import sys
from datetime import datetime
from collections import defaultdict
import mlflow
from azureml.core import Workspace
from dotenv import load_dotenv
load_dotenv()

from autogen import GroupChat, GroupChatManager
from agents.autogen_agents import (
    generate_agent,
    enhance_agent,
    review_agent,
    export_agent,
    user_proxy
)
from agents.llm_client import get_llm_config, LLM_CALL_COUNT, LLM_TOKEN_ESTIMATE
from agents.exporter import export_feature_file
from agents.utils import setup_logger
from agents.xml_ingestor import parse_and_extract

# Setup logger
logger = setup_logger("Orchestrator", log_file="logs/orchestrator.log")

# ✅ Connect to Azure ML Workspace
try:
    ws = Workspace.get(
            name="SwiftForgeAML", 
            subscription_id=os.getenv("AZURE_SUB_ID"), 
            resource_group=os.getenv("AZURE_RES_GROUP")
    )
    mlflow.set_tracking_uri(ws.get_mlflow_tracking_uri())
    mlflow.set_experiment("ScenarioFeedbackAML")
    print("✅ Connected to Azure ML workspace and MLflow tracking is set.")
except Exception as e:
    logger.error(f"Azure ML workspace connection failed: {str(e)}")
    print(f"❌ Failed to connect to Azure ML workspace: {str(e)}")
    raise e  # Fail fast

def format_scenarios(blocks: list[str]) -> str:
    formatted_blocks = []
    for block in blocks:
        lines = block.strip().splitlines()
        spaced_lines = []
        for line in lines:
            if line.startswith("Scenario:"):
                spaced_lines.append("")  # Add blank line before scenario
            spaced_lines.append(line)
        formatted_blocks.append("\n".join(spaced_lines))
    return "\n\n".join(formatted_blocks)

def run_orchestrator(input_text: str, msg_type: str = "camt.054") -> tuple[str, str]:
    llm_config = get_llm_config()
    logger.info(f"Starting orchestration for {msg_type.upper()}")

    try:
        extracted_fields = parse_and_extract(input_text, msg_type)
    except Exception as e:
        logger.error(f"Extraction failed for {msg_type}: {str(e)}")
        print("\n❌ Extraction failed.")
        return "", ""

    initial_message = f"""Here are the extracted fields from a {msg_type.upper()} message:

Please generate Gherkin scenarios based on this data."""

    group_chat = GroupChat(
        agents=[
            user_proxy,
            generate_agent,
            enhance_agent,
            review_agent,
            export_agent
        ],
        messages=[],
        max_round=5
    )

    manager = GroupChatManager(groupchat=group_chat, llm_config=llm_config)

    stdout_buffer = io.StringIO()
    original_stdout = sys.stdout
    sys.stdout = stdout_buffer

    try:
        user_proxy.initiate_chat(manager, message=initial_message)
    finally:
        sys.stdout = original_stdout

    printed_output = stdout_buffer.getvalue()

    # Parse scenario blocks
    agent_scenarios = defaultdict(list)
    current_agent = None
    current_block = []

    for line in printed_output.splitlines():
        line = line.strip()
        if line.startswith("Next speaker:"):
            if current_agent and current_block:
                agent_scenarios[current_agent].append("\n".join(current_block))
                current_block = []
            current_agent = line.replace("Next speaker:", "").strip()
        elif current_agent and (
            line.startswith("Feature:") or
            line.startswith("Scenario") or
            line.startswith("Examples:") or
            line.startswith("Given") or
            line.startswith("When") or
            line.startswith("Then") or
            line.startswith("And") or
            line.startswith("But") or
            line.startswith("|")
        ):
            current_block.append(line)

    if current_agent and current_block:
        agent_scenarios[current_agent].append("\n".join(current_block))

    # Combine all agent blocks
    all_blocks = []
    scenario_count = 0
    scenario_metadata = []

    for agent_name, blocks in agent_scenarios.items():
        for block in blocks:
            header = f"# Agent: {agent_name}\n# Message Type: {msg_type.upper()}\n"
            formatted = header + block.strip()
            all_blocks.append(formatted)
            count = block.strip().count("Scenario")
            scenario_count += count
            scenario_metadata.append({
                "agent": agent_name,
                "scenarios": count
            })

    spaced_output = format_scenarios(all_blocks)

    timestamp = datetime.now().strftime("%Y%m%d_%H%M")
    base_name = f"{msg_type}_{timestamp}"
    feature_filename = f"{base_name}.feature"
    json_filename = f"{base_name}_stats.json"

    export_path = export_feature_file([spaced_output], filename=feature_filename)

    stats = {
        "message_type": msg_type,
        "timestamp": timestamp,
        "llm_calls": LLM_CALL_COUNT,
        "estimated_tokens": LLM_TOKEN_ESTIMATE,
        "total_scenarios": scenario_count,
        "agents": scenario_metadata
    }
    json_path = os.path.join("output", json_filename)
    os.makedirs("output", exist_ok=True)
    with open(json_path, "w", encoding="utf-8") as f:
        json.dump(stats, f, indent=2)

    # ✅ Log to MLflow (Azure ML)
    run_id = ""
    try:
        print("✅ Logging to MLflow...")
        with mlflow.start_run(run_name=f"{msg_type.upper()}_{timestamp}"):
            mlflow.log_param("message_type", msg_type)
            mlflow.log_param("llm_calls", LLM_CALL_COUNT)
            mlflow.log_metric("total_scenarios", scenario_count)
            mlflow.log_metric("estimated_tokens", LLM_TOKEN_ESTIMATE)
            mlflow.log_artifact(export_path)
            mlflow.log_artifact(json_path)
            run_id = mlflow.active_run().info.run_id
            print(f"🧪 MLflow run started: {run_id}")
    except Exception as e:
        logger.error(f"MLflow logging failed: {str(e)}")
        print(f"❌ MLflow logging failed: {str(e)}")

    # Final summary
    logger.info(f"Orchestration complete for {msg_type.upper()}")
    logger.info(f"Scenarios written: {scenario_count}")
    logger.info(f"Feature file exported to: {export_path}")
    logger.info(f"Stats saved to: {json_path}")

    print(f"\n📦 Exported {scenario_count} scenarios to {feature_filename}")
    print(f"📊 Stats saved to {json_filename}")
    return export_path, run_id
