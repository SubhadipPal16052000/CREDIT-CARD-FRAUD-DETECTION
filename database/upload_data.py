import pandas as pd
from sqlalchemy import create_engine

engine = create_engine(
    "postgresql://neondb_owner:npg_xfNHkrFu56Kq@ep-twilight-sun-a11cc5iu-pooler.ap-southeast-1.aws.neon.tech/neondb",
    connect_args={"sslmode": "require"}
)

df = pd.read_csv("data/clean_transactions.csv")

df.to_sql("clean_transactions", engine, if_exists="replace", index=False)

print("Data uploaded successfully")