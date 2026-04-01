import pandas as pd
from database.db_connection import get_db_engine


def load_data():
    """
    Load full dataset from PostgreSQL
    """

    engine = get_db_engine()

    if engine is None:
        raise Exception("Database connection failed")

    query = "SELECT * FROM creditcard"

    df = pd.read_sql(query, engine)

    print("Data loaded successfully")
    print("Shape:", df.shape)

    return df


def load_filtered_data():
    
    #Load optimized dataset (for ML)

    engine = get_db_engine()

    query = """
    SELECT 
        *,
        FLOOR(time) AS hour
    FROM creditcard
    WHERE amount > 0
    """

    df = pd.read_sql(query, engine)

    print("Filtered data loaded")
    print("Shape:", df.shape)

    return df


if __name__ == "__main__":
    df = load_filtered_data()

    print("\nPreview:")
    print(df.head())

    print("\nInfo:")
    print(df.info())