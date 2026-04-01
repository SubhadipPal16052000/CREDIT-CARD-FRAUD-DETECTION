from sqlalchemy import create_engine
import streamlit as st
import pandas as pd 
import os
def get_db_engine():

    db = st.secrets["postgres"]

    return create_engine(
        f"postgresql+psycopg2://{db['user']}:{db['password']}@{db['host']}:{db['port']}/{db['database']}"
    )

def run_query(query):
    engine = get_db_engine()
    return pd.read_sql(query, engine)

    '''
    Create PostgreSQL database connection
    

    username = "postgres"
    password = "Admin"
    host = "localhost"
    port = "5432"
    database = "fraud_db"

    try:
        engine = create_engine(
            f"postgresql://{username}:{password}@{host}:{port}/{database}"
        )
        print("Database connected successfully")
        return engine

    except Exception as e:
        print("Connection error:", e)
        return None'''