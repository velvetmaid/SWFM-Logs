import pdfplumber
import pandas as pd
import os

folder = "Sulawesi"   # ganti dengan folder tempat PDF disimpan
keys = ["Site ID/Nama Site", "Site Name", "Daya", "OA Date", "Cut Off Date", "Remark"]
all_data = []

for filename in os.listdir(folder):
    if filename.endswith(".pdf"):
        filepath = os.path.join(folder, filename)
        with pdfplumber.open(filepath) as pdf:
            all_text = ""
            for page in pdf.pages:
                text = page.extract_text()
                if text:
                    all_text += text + "\n"

        lines = all_text.splitlines()
        data = {"File": filename}

        for i, line in enumerate(lines):
            for key in keys:
                if key in line:
                    if ":" in line and line.strip().endswith(":"):
                        # format "Key :" lalu value di baris berikutnya
                        value = lines[i+1].strip()
                    else:
                        # format "Key : value" dalam satu baris
                        parts = line.split(":")
                        value = parts[1].strip() if len(parts) > 1 else ""
                    data[key] = value
        all_data.append(data)

# Gabungkan semua hasil ke Excel
df = pd.DataFrame(all_data)
df.to_excel("output_sites.xlsx", index=False)
