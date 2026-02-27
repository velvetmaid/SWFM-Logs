import os
import pandas as pd
import psycopg2
from dotenv import load_dotenv
from datetime import datetime
import re

load_dotenv()

DB_HOST = os.getenv("DB_HOST")
DB_PORT = os.getenv("DB_PORT")
DB_USER = os.getenv("DB_USER")
DB_PASSWORD = os.getenv("DB_PASSWORD")
DB_NAME = os.getenv("DB_NAME")

current_time = datetime.now().strftime("%Y%m%d_%H%M%S")
excel_path = f"{current_time}_export.xlsx"

conn = psycopg2.connect(
    host=DB_HOST,
    port=DB_PORT,
    user=DB_USER,
    password=DB_PASSWORD,
    dbname=DB_NAME
)

with open("query.sql", "r") as f:
    query = f.read()

chunksize = 100000
max_rows = 1048575

with pd.ExcelWriter(excel_path, engine="xlsxwriter") as writer:

    sheet_index = 1
    row_offset = 0

    for chunk in pd.read_sql_query(query, conn, chunksize=chunksize):

        # vectorized cleaning (ONLY string columns)
        for col in chunk.select_dtypes(include=["object"]).columns:
            chunk[col] = chunk[col].str.replace(r"[\x00-\x1F\x7F]", "", regex=True)

        if row_offset + len(chunk) > max_rows:
            sheet_index += 1
            row_offset = 0

        chunk.to_excel(
            writer,
            sheet_name=f"Sheet{sheet_index}",
            index=False,
            startrow=row_offset,
            header=row_offset == 0
        )

        worksheet = writer.sheets[f"Sheet{sheet_index}"]

        if row_offset == 0:
            worksheet.freeze_panes(1, 0)

        row_offset += len(chunk)

conn.close()

print("Finished:", excel_path)
