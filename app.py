import streamlit as st
import os
import json
from datetime import datetime
from chains.autogen_orchestrator import run_orchestrator

# Page setup
st.set_page_config(page_title="SwiftForge", layout="wide")

# Sidebar content
st.sidebar.markdown("## 🧠 SwiftForge POC")
st.sidebar.markdown("Automated Test scenario generation for ISO20022 payments using LLMs and Azure ML.")

with st.sidebar.expander("🧰 Tech Stack", expanded=False):
    st.markdown("""
- Azure Machine Learning  
- Azure OpenAI  
- Autogen Agents  
- Streamlit  
- MLflow  
""")

with st.sidebar.expander("🤖 Agent Flow", expanded=False):
    st.markdown("""
1. User Proxy  
2. Generate Agent  
3. Enhance Agent  
4. Review Agent  
5. Export Agent  
""")

with st.sidebar.expander("📊 MLflow Integration", expanded=False):
    st.markdown("""
- Runs tracked in Azure ML Studio  
- Metrics: `total_scenarios`, `llm_calls`, `estimated_tokens`  
- Artifacts: `.feature` and `.json` files  
""")

# Main UI
st.markdown("### 💬 Scenario Generator")
st.caption("Upload XML, select message type, and generate Gherkin scenarios with MLflow tracking.")

msg_type = st.selectbox("Message type:", ["pacs.008", "pacs.009", "camt.053", "camt.054"])
uploaded_file = st.file_uploader("Upload XML file", type=["xml"])

if uploaded_file:
    xml_string = uploaded_file.read().decode("utf-8")

    if st.button("🚀 Run Orchestrator"):
        with st.spinner("Running orchestration..."):
            try:
                output_file, run_id = run_orchestrator(xml_string, msg_type=msg_type)

                st.success(f"✅ {msg_type.upper()} orchestration complete")
                st.markdown(f"📦 Scenarios saved to: `{os.path.basename(output_file)}`")
                st.markdown(f"📊 MLflow Run ID: `{run_id}`")

                stats_file = output_file.replace(".feature", "_stats.json")
                if os.path.exists(stats_file):
                    with open(stats_file, "r", encoding="utf-8") as f:
                        stats = json.load(f)
                    st.markdown("#### 📈 Scenario Stats")
                    st.json(stats)

                with open(output_file, "r", encoding="utf-8") as f:
                    st.download_button("📥 Download Feature File", f.read(), file_name=os.path.basename(output_file))

                if os.path.exists(stats_file):
                    with open(stats_file, "r", encoding="utf-8") as f:
                        st.download_button("📥 Download Stats JSON", f.read(), file_name=os.path.basename(stats_file))

            except Exception as e:
                st.error(f"❌ Error: {str(e)}")
