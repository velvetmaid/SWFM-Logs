import os
import pandas as pd
import psycopg2
from dotenv import load_dotenv
from openpyxl import load_workbook
from openpyxl.styles import Font

load_dotenv()

DB_HOST = os.getenv("DB_HOST")
DB_PORT = os.getenv("DB_PORT")
DB_USER = os.getenv("DB_USER")
DB_PASSWORD = os.getenv("DB_PASSWORD")
DB_NAME = os.getenv("DB_NAME")

conn = psycopg2.connect(
    host=DB_HOST,
    port=DB_PORT,
    user=DB_USER,
    password=DB_PASSWORD,
    dbname=DB_NAME
)

query = "SELECT * FROM wfm_schema.asset_safe_guard"
df = pd.read_sql_query(query, conn)

conn.close()

excel_path =  current_time + "output_data_only.xlsx"
df.to_excel(excel_path, index=False)

wb = load_workbook(excel_path)
ws = wb.active

for cell in ws[1]:
    cell.font = Font(bold=True)

ws.freeze_panes = "A2"

ws.auto_filter.ref = ws.dimensions

for col in ws.columns:
    max_len = 0
    col_letter = col[0].column_letter
    for cell in col:
        try:
            if cell.value:
                max_len = max(max_len, len(str(cell.value)))
        except:
            pass
    ws.column_dimensions[col_letter].width = max_len + 2

wb.save(excel_path)

print("✅ Output Excel udah langsung tajir dan ganteng 😎 ->", excel_path)
