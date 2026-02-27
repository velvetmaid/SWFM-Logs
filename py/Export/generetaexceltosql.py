import pandas as pd

# Baca file Excel/CSV
df = pd.read_excel("CDC BA Cut Off 2025.xlsx")  # atau pd.read_csv("update_sites.csv")

# Buat blok VALUES untuk PostgreSQL
values = []
for _, row in df.iterrows():
    values.append(f"('{row['Site ID']}', '{row['Remark Cut Off']}', '{row['Reason']}', '{row['Tanggal Off Service']}'::timestamp, '{row['Status']}')")

values_block = ",\n    ".join(values)

# Buat query final
query = f"""
UPDATE wfm_schema.tx_cdc_site_list 
SET keterangan = v.keterangan,
    reason = v.reason,
    tanggal_off_service = v.tanggal_off_service,
    status = v.status
FROM (VALUES
    {values_block}
) AS v(site_id, keterangan, reason, tanggal_off_service, status)
WHERE tx_cdc_site_list.site_id = v.site_id;
"""

print(query)
