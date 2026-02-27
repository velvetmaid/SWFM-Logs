import pdfplumber
import pandas as pd
import os

folder = "Puma"   # ganti dengan folder tempat PDF tabel disimpan
all_data = []

for filename in os.listdir(folder):
    if filename.endswith(".pdf"):
        filepath = os.path.join(folder, filename)
        with pdfplumber.open(filepath) as pdf:
            for page in pdf.pages:
                table = page.extract_table()
                if table:
                    # baris pertama biasanya header
                    headers = table[0]
                    for row in table[1:]:
                        data = dict(zip(headers, row))
                        data["File"] = filename
                        all_data.append(data)

df = pd.DataFrame(all_data)
df.to_excel("output_tabel.xlsx", index=False)
