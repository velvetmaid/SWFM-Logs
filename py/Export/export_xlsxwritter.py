import math
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

# --- Export with xlsxwriter (split if needed) ---
max_rows = 1048576  # Excel limit
usable_rows = max_rows - 1
num_sheets = math.ceil(len(df) / usable_rows)

with pd.ExcelWriter(excel_path, engine="xlsxwriter") as writer:
    for i in range(num_sheets):
        start_row = i * usable_rows
        end_row = min((i + 1) * usable_rows, len(df))
        df_chunk = df.iloc[start_row:end_row]

        sheet_name = f"Sheet{i+1}"
        df_chunk.to_excel(writer, sheet_name=sheet_name, index=False)

        workbook = writer.book
        worksheet = writer.sheets[sheet_name]

        # Bold header
        header_format = workbook.add_format({"bold": True})
        for col_num, value in enumerate(df_chunk.columns.values):
            worksheet.write(0, col_num, value, header_format)

        # Freeze top row
        worksheet.freeze_panes(1, 0)

        # Add table (make sure range sesuai dengan chunk)
        worksheet.add_table(0, 0, len(df_chunk), len(df_chunk.columns) - 1, {
            "name": f"DataTable_{i+1}",
            "columns": [{"header": col} for col in df_chunk.columns],
            "style": "Table Style Medium 9"
        })

print(f"\n Finished -> {excel_path} dengan {num_sheets} sheet")