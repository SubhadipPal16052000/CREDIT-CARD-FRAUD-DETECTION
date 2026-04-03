# =========================================
# 📦 IMPORTS
# =========================================
import streamlit as st
import pandas as pd
import plotly.express as px
import datetime
import os

from utils import load_data, load_features, load_threshold, predict, run_query

# =========================================
# ⚙️ CONFIG
# =========================================
st.set_page_config(page_title="Transactional Fraud Detection", layout="wide")

st.markdown("""
<style>

/* Full width tab layout */
div[role="tablist"] {
    justify-content: space-between;
}

/* Tab container */
button[data-baseweb="tab"] {
    flex: 1;
    padding: 16px 0px !important;
    text-align: center;
}

/* FIX: Tab text styling */
button[data-baseweb="tab"] > div {
    font-size: 30px !important;
    font-weight: 700;
    width: 100%;
    text-align: center;
}

/* Active tab */
button[aria-selected="true"] {
    background-color: #1f2937 !important;
    border-bottom: 4px solid #FF4B4B !important;
}

/* Hover effect */
button[data-baseweb="tab"]:hover {
    background-color: #111827 !important;
}

</style>
""", unsafe_allow_html=True)

# Centered title
st.markdown(
    "<h1 style='text-align: center;'>💳 Transactional Fraud Detection System</h1>",
    unsafe_allow_html=True
)

st.markdown("""
<style>

/* KPI container */
[data-testid="stMetric"] {
    background-color: #111827;
    padding: 20px;
    border-radius: 12px;
    text-align: center;
    border: 1px solid #1f2937;
}

/* KPI label (title) */
[data-testid="stMetricLabel"] {
    font-size: 30px !important;
    font-weight: 600;
}

/* KPI value (number) */
[data-testid="stMetricValue"] {
    font-size: 32px !important;
    font-weight: 700;
    color: #22c55e;
}

</style>
""", unsafe_allow_html=True)
# =========================================
# 🔄 CACHE DATA
# =========================================
@st.cache_data
def get_data():
    return load_data()

df = get_data()
features = load_features()
threshold = load_threshold()

# =========================================
# 📊 SMART VISUALIZATION ENGINE
# =========================================


# =========================================
# 📊 KPI SECTION
# =========================================
def show_kpis():

    try:
        total = int(run_query("SELECT COUNT(*) AS total FROM clean_transactions")["total"][0])
        fraud = int(run_query("SELECT COUNT(*) AS fraud FROM clean_transactions WHERE class=1")["fraud"][0])
        amount = float(run_query("SELECT SUM(amount) AS total_amount FROM clean_transactions")["total_amount"][0])

        fraud_pct = (fraud / total) * 100 if total else 0

        col1, col2, col3, col4 = st.columns(4)

        col1.metric(" 💳 Total", f"{total:,}")
        col2.metric("🚨 Fraud", f"{fraud:,}")
        col3.metric("📊 Fraud %", f"{fraud_pct:.2f}%")
        col4.metric("💰 Amount", f"{amount:,.2f}")

        return fraud_pct, amount

    except:
        st.warning("KPI not available")
        return 0, 0


# =========================================
# 🧾 SQL QUERIES
# =========================================
queries = {
        "1. Preview Data(Quick data check)" : "SELECT * FROM quick_data_check",
        "2. Count Total Records(Dataset size)" : "SELECT * FROM dataset_size_check",
        "3. Check Class Distribution(Fraud imbalance)" : "SELECT * FROM check_class_distribution",
        "4. Get Fraud Transactions(Extract fraud data)" : "SELECT * FROM get_fraud_transactions",
        "5. Get Legitimate Transactions(Extract normal data)" : "SELECT * FROM get_legitimate_transactions",
        "6. Average Transaction Amount(Overall spending trend)" : "SELECT * FROM average_transaction_amount",
        "7. Max Transaction Amount(Detect extreme values)" : "SELECT * FROM max_transaction_amount",
        "8. Min Transaction Amount(Lower bound check)" : "SELECT * FROM min_transaction_amount",
        "9. Average Amount by Class(Compare fraud vs normal)" : "SELECT * FROM average_amount_by_class",
        "10. Count Transactions Above Threshold(High-value transactions)" : "SELECT * FROM transactions_above_threshold",
        "11. Create Fraud View(Reusable fraud dataset)" : "SELECT * FROM v_fraud_transactions",
        "12. Top 10 Highest Transactions(Detect anomalies)" : "SELECT * FROM top_10_highest_transactions",
        "13. Count Transactions Per Hour(Time-based analysis)": "SELECT * FROM transaction_time_dayhours",
        "14. Fraud Percentage(Fraud rate)" : "SELECT * FROM fraud_percentage",
        "15. Top 10 Fraud Amounts" : "SELECT * FROM top_fraud_amount",
        "16. Suspicious Small Transactions (Fraud)" : "SELECT * FROM suspicious_small_transactions",
        "17. Compare Fraud vs Normal Count by Hour" : "SELECT * FROM fraud_vs_normal_hours_count",
        "18. Fraud Ratio by Amount Buckets" : "SELECT * FROM fraud_ratio_by_amount_buckets",
        "19. Peak Fraud Hour" : "SELECT * FROM peak_fraud_hour",
        "20. Transactions with High Risk Pattern" : "SELECT * FROM transactions_with_high_risk_pattern",
        "21. Transactions Per Hour": "SELECT * FROM transactions_per_hour"
    }

# =========================================
# 🧭 TABS
# =========================================
tab1, tab2, tab3 = st.tabs(["📊 Summary", "🤖 ML Prediction", "📈 Dashboard"])

class show_insights:
    def __init__(self, fraud_pct, amount):
        self.fraud_pct = fraud_pct
        self.amount = amount

    def __call__(self, *args, **kwargs):
        raise NotImplementedError

# =========================================
# 📊 SUMMARY TAB
# =========================================
with tab1:

    st.subheader("📊 KPI Dashboard")
    fraud_pct, amount = show_kpis()
    # =========================================
    # 💼 BUSINESS INSIGHTS
    # =========================================
    st.markdown("---")
    st.subheader("💼 Business Impact & Insights")

    col1, col2 = st.columns(2)

    with col1:
        st.markdown("🧠 Insights")

        if fraud_pct > 0.5:
            st.error("🚨 High fraud rate detected → Immediate action required")
        else:
            st.success("✅ Fraud rate is under control")

        if amount > 1_000_000:
            st.warning("💰 High transaction volume → Increased fraud exposure")

        st.write("1. Most fraud occurs during specific hours (analyze peak time)")
        st.write("2. High-value transactions are more risky")
        st.write("3. Fraud patterns indicate potential automated attacks")

    with col2:
        st.markdown("🏦 Business Value")

        st.write("I. Prevent financial losses from fraudulent transactions")
        st.write("II. Improve customer trust and security")
        st.write("III. Enable real-time fraud detection using ML")
        st.write("IV. Reduce manual fraud investigation effort")
        st.write("V. Enhance compliance with banking regulations")

        show_insights(fraud_pct, amount)

    st.markdown("---")
    st.subheader("📊 Query Analysis")

    selected = st.selectbox("Select Query", list(queries.keys()))

    if st.button("Run Query"):
        df_sql = run_query(queries[selected])
        
        st.dataframe(df_sql, use_container_width=True)

        
        

# =========================================
# 🤖 ML TAB
# =========================================
with tab2:

    st.header("🤖 Fraud Prediction")

    threshold = st.slider("Threshold", 0.1, 0.9, float(threshold), 0.01)

    amount = st.number_input("Amount", 0.0, 100000.0, 100.0)
    hour = st.slider("Hour", 0, 23, 12)

    input_data = {f: 0 for f in features}
    for f in features:
        if "amount" in f.lower():
            input_data[f] = amount
        elif "time" in f.lower():
            input_data[f] = hour

    input_df = pd.DataFrame([input_data])

    if st.button("Predict"):

        pred, prob = predict(input_df)

        col1, col2 = st.columns(2)
        col1.metric("Fraud Probability", f"{prob*100:.2f}%")
        col2.metric("Threshold", f"{threshold*100:.2f}%")

        st.progress(prob)

        if prob >= threshold:
            st.error("🚨 Fraudulent Transaction Detected")
        else:
            st.success("✅ Legitimate Transaction")

        # =========================================
        # 💼 BUSINESS INSIGHTS (TAB 2)
        # =========================================
        st.markdown("---")
        st.subheader("💼 Prediction Insights & Business Impact")

        col1, col2 = st.columns(2)

        with col1:
            st.markdown("Model Prediction Insights")

            if prob >= threshold:
                st.error("🚨 High-risk transaction detected")
                st.write("📌 Transaction likely fraudulent based on model pattern")
                st.write("📌 Immediate action recommended (block / verify user)")
            else:
                st.success("✅ Low-risk transaction")
                st.write("📌 Transaction appears normal")
                st.write("📌 No immediate action required")

            st.write("📌 Risk depends on transaction amount & timing")
            st.write("📌 Model detects hidden fraud patterns using ML")

        with col2:
            st.markdown("🏦 Business Value")

            st.write("✔️ Real-time fraud detection")
            st.write("✔️ Prevent financial loss before transaction completes")
            st.write("✔️ Reduce manual fraud investigation")
            st.write("✔️ Improve customer trust & security")
            st.write("✔️ Enable automated decision-making systems")

# =========================================
# 📈 DASHBOARD TAB
# =========================================
with tab3:
    st.header("📈 Power BI Dashboard")
    st.info("Transactional Fraud Detection Power BI Dashboard made by Subhadip")

    power_bi_url = "https://app.powerbi.com/view?r=eyJrIjoiYTAzYjE5MjAtZmVlZC00OTg0LThjNGItZDU1ZGMyYzZjNjI0IiwidCI6IjlhOTkzMjZhLTliZjQtNGYwNS04MmFmLWVkNWMwOTZhMjQ1OSJ9&pageName=7e36062a4875fee878bd"
    st.components.v1.iframe(power_bi_url, height=700)

#"https://app.powerbi.com/view?r=eyJrIjoiYzRmMDZmNTYtMTYxYi00ZDE4LWEzNjktYjdkMDJmM2Y5NWNkIiwidCI6IjlhOTkzMjZhLTliZjQtNGYwNS04MmFmLWVkNWMwOTZhMjQ1OSJ9"
# https://app.powerbi.com/view?r=eyJrIjoiYzRmMDZmNTYtMTYxYi00ZDE4LWEzNjktYjdkMDJmM2Y5NWNkIiwidCI6IjlhOTkzMjZhLTliZjQtNGYwNS04MmFmLWVkNWMwOTZhMjQ1OSJ9