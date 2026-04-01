import pandas as pd
import joblib
import os
import streamlit as st
from sqlalchemy import create_engine

# ==============================
# 🔹 DATABASE CONNECTION
# ==============================
@st.cache_resource
def get_engine():
    return create_engine(st.secrets["DB_URL"])

    '''return create_engine(
        f"postgresql+psycopg2://{db['user']}:{db['password']}@{db['host']}:{db['port']}/{db['database']}",
        connect_args={"sslmode": "require"}   # for Neon database
    )'''

def run_query(query):
    engine = get_engine()
    return pd.read_sql(query, engine)


# ==============================
# 🔹 LOAD DATA
# ==============================
def load_data():
    path = "data/clean_transactions.csv"
    if os.path.exists(path):
        return pd.read_csv(path)
    else:
        return pd.DataFrame()


# ==============================
# 🔹 MODEL LOADERS
# ==============================
def load_model():
    return joblib.load("models/fraud_model.pkl")

def load_features():
    return joblib.load("models/features.pkl")

def load_threshold():
    try:
        return joblib.load("models/threshold.pkl")
    except:
        return 0.5


# ==============================
# 🔹 PREPROCESS INPUT
# ==============================
def preprocess_input(input_df, feature_columns):
    input_df = input_df.copy()

    for col in feature_columns:
        if col not in input_df.columns:
            input_df[col] = 0

    return input_df[feature_columns]


# ==============================
# 🔹 PREDICT
# ==============================
def predict(input_df):
    model = load_model()
    features = load_features()
    threshold = load_threshold()

    input_df = preprocess_input(input_df, features)

    prob = model.predict_proba(input_df)[0][1]
    pred = int(prob >= threshold)

    return pred, prob