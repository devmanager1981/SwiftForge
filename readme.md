# 💬 SwiftForge POC

## Overview

SwiftForge is a Proof of Concept (POC) that automates the generation of Gherkin-style test scenarios from financial XML messages using Azure LLMs orchestrated via Azure Machine Learning. It combines multi-agent collaboration, MLflow tracking, and a Streamlit UI for interactive execution and review.

## 🚀 Key Features

- Upload financial XML messages (e.g., PACS.008, CAMT.054)
- Extract structured fields using custom XML ingestors
- Generate Gherkin scenarios using a multi-agent LLM pipeline
- Powered by Azure LLM GPT-5-nano for fast, cost-efficient inference
- Track metrics and artifacts in Azure ML via MLflow
- Preview and download `.feature` and `.json` files
- Streamlit UI for interactive orchestration

## 🧰 Tech Stack

- Azure LLM GPT-5-nano (LLM orchestration)
- Azure Machine Learning (MLflow tracking, experiment logging)
- Autogen Agents (modular agent-based scenario generation)
- Streamlit (interactive UI)
- Behave (Cucumber-compatible feature file generation)
- lxml (XML parsing)

## 🤖 Agent Architecture

SwiftForge uses a modular agent pipeline powered by Autogen:

- **User Proxy**: Initiates the conversation and coordinates agent flow
- **Generate Agent**: Creates initial Gherkin scenarios from extracted fields
- **Enhance Agent**: Adds edge cases, validations, and business logic
- **Review Agent**: Validates scenario structure and correctness
- **Export Agent**: Formats scenarios into `.feature` files for Behave

Each agent collaborates in a GroupChat powered by Azure GPT-5-nano, ensuring diverse scenario coverage and quality.
## 📊 MLflow Integration
- Each run is tracked in Azure ML Studio
- Parameters: `message_type`, `llm_calls`
- Metrics: `total_scenarios`, `estimated_tokens`
- Artifacts: `.feature` file and stats `.json`

## 🖥️ Streamlit UI
- Upload XML → Select message type → Run orchestration
- View MLflow run ID and scenario stats
- Download generated files
- Sidebar includes tech stack and agent flow

## 📦 Output Files
- `*.feature`: Gherkin scenarios grouped by agent
- `*_stats.json`: Scenario counts and metadata
- `run_summary.json`: Summary of all processed messages

## 🛠️ Setup Instructions
```bash
# Create virtual environment
python -m venv venv
source venv/bin/activate  # or venv\Scripts\activate on Windows

# Install dependencies
pip install -r requirements.txt
# To run tests
pytest tests/

# Run Streamlit UI
streamlit run app.py

#Following Azure services are needed and should be setup before running UI. 
# 1. LLM deployed in Azure AI Foundry . I used GPT-5-nano
# AZURE_OPENAI_ENDPOINT=YOUR-ENDPOINT
# AZURE_OPENAI_KEY=YOUR-KEY
# AZURE_OPENAI_DEPLOYMENT=YOUR-DEPLOYMENT-NAME
# AZURE_OPENAI_VERSION=YOUR-VERSION

# 2. AZURE MACHINE LEARNING DEPLOYMENT for MLFLOW Tracking 
# AZURE_SUB_ID=YOUR-SUBSCRIPTION-ID
# AZURE_RES_GROUP=YOUR-RESOURCE-GROUP

📁 Folder Structure
SwiftForge/
agents/ 
--autogen_agents.py 
--exporter.py 
--llm_client.py 
--utils.py 
--xml_ingestor.py
-- enhancer.py - This is no longer used in POC
-- reviewer.py - This is no longer used in POC
---scenario_generator.py - This is no longer used in POC
chains/ autogen_orchestrator.py
data/ 
--pacs.008.xml 
--pacs.009.xml 
--camt.053.xml 
--camt.054.xml
tests/
-- test_generator.py
-- test_validator.py
output/ 
--*.feature 
--*_stats.json 
--run_summary.json
app.py  - Streamlit ui 
logs/ orchestrator.log
run_poc.py - non-ui version 
requirements.txt 
README.md