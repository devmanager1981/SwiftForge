import os
import openai
import mlflow
from dotenv import load_dotenv
from agents.utils import setup_logger

load_dotenv()
logger = setup_logger("LLMClient")

# Azure OpenAI credentials
AZURE_OPENAI_KEY = os.getenv("AZURE_OPENAI_KEY")
AZURE_OPENAI_ENDPOINT = os.getenv("AZURE_OPENAI_ENDPOINT")
AZURE_OPENAI_DEPLOYMENT = os.getenv("AZURE_OPENAI_DEPLOYMENT")
AZURE_OPENAI_API_VERSION = "2025-01-01-preview"

# Global usage counters
LLM_CALL_COUNT = 0
LLM_TOKEN_ESTIMATE = 0

# Azure OpenAI client setup
openai.api_type = "azure"
openai.api_key = AZURE_OPENAI_KEY
openai.api_base = AZURE_OPENAI_ENDPOINT
openai.api_version = AZURE_OPENAI_API_VERSION

def get_llm_config():
    return {
        "config_list": [
            {
                "api_key": AZURE_OPENAI_KEY,
                "api_type": "azure",
                "api_version": AZURE_OPENAI_API_VERSION,
                "base_url": AZURE_OPENAI_ENDPOINT,
                "model": AZURE_OPENAI_DEPLOYMENT
            }
        ]
    }

def get_config_list():
    return [get_llm_config()]

def call_llm(prompt: str, track_run: bool = False, run_name: str = None) -> str:
    global LLM_CALL_COUNT, LLM_TOKEN_ESTIMATE

    try:
        response = openai.ChatCompletion.create(
            engine=AZURE_OPENAI_DEPLOYMENT,
            messages=[{"role": "user", "content": prompt}],
            temperature=0.7
        )
        reply = response.choices[0].message.content
        prompt_tokens = len(prompt.split())
        response_tokens = len(reply.split())
        total_tokens = prompt_tokens + response_tokens

        LLM_CALL_COUNT += 1
        LLM_TOKEN_ESTIMATE += total_tokens

        # ✅ Log to MLflow if enabled
        if track_run:
            try:
                with mlflow.start_run(run_name=run_name or f"LLM_Call_{LLM_CALL_COUNT}", nested=True):
                    mlflow.log_param("deployment", AZURE_OPENAI_DEPLOYMENT)
                    mlflow.log_param("api_version", AZURE_OPENAI_API_VERSION)
                    mlflow.log_param("call_number", LLM_CALL_COUNT)
                    mlflow.log_metric("tokens_used", total_tokens)
                    mlflow.log_text(prompt, "prompt.txt")
                    mlflow.log_text(reply, "response.txt")
                    run_id = mlflow.active_run().info.run_id
                    logger.info(f"🧪 LLM MLflow run started: {run_id}")
            except Exception as e:
                logger.error(f"❌ MLflow logging failed inside LLM call: {e}")

        return reply

    except Exception as e:
        logger.error(f"❌ LLM call failed: {e}")
        return ""
