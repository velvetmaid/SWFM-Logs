import os
import pandas as pd
import psycopg2
from dotenv import load_dotenv
from datetime import datetime
import re

# --- Load .env ---
load_dotenv()

# --- DB credentials ---
DB_HOST = os.getenv("DB_HOST")
DB_PORT = os.getenv("DB_PORT")
DB_USER = os.getenv("DB_USER")
DB_PASSWORD = os.getenv("DB_PASSWORD")
DB_NAME = os.getenv("DB_NAME")

# --- Timestamp for file naming ---
current_time = datetime.now().strftime("%Y%m%d_%H%M%S")
excel_path = f"{current_time}_export.xlsx"

# --- Connect to DB ---
conn = psycopg2.connect(
    host=DB_HOST,
    port=DB_PORT,
    user=DB_USER,
    password=DB_PASSWORD,
    dbname=DB_NAME
)

# --- Query ---
with open("query.sql", "r") as f:
    query = f.read()

# --- Get data ---
df = pd.read_sql_query(query, conn)
conn.close()

# --- Clean ---
df = df.applymap(lambda val: re.sub(r"[\x00-\x1F\x7F]", "", val) if isinstance(val, str) else val)

# --- Export with xlsxwriter ---
with pd.ExcelWriter(excel_path, engine="xlsxwriter") as writer:
    df.to_excel(writer, sheet_name="Sheet1", index=False)
    workbook = writer.book
    worksheet = writer.sheets["Sheet1"]

    # Bold header
    header_format = workbook.add_format({"bold": True})
    for col_num, value in enumerate(df.columns.values):
        worksheet.write(0, col_num, value, header_format)

    # Freeze top row
    worksheet.freeze_panes(1, 0)

    # Sort
    worksheet.add_table(0, 0, len(df), len(df.columns) - 1, {
        "name": "DataTable",
        "columns": [{"header": col} for col in df.columns],
        "style": "Table Style Medium 9"
    })

print(f"\n Finished -> {excel_path}")
