import os
import pandas as pd
import psycopg2
from dotenv import load_dotenv
import paramiko

# --- Load env ---
load_dotenv()

DB_HOST = os.getenv("DB_HOST")
DB_PORT = os.getenv("DB_PORT")
DB_USER = os.getenv("DB_USER")
DB_PASSWORD = os.getenv("DB_PASSWORD")
DB_NAME = os.getenv("DB_NAME")

SFTP_HOST = os.getenv("SFTP_HOST")
SFTP_PORT = int(os.getenv("SFTP_PORT", 22))
SFTP_USER = os.getenv("SFTP_USER")
SFTP_PASS = os.getenv("SFTP_PASSWORD")

# Folder buat nyimpen file
LOCAL_ATTACHMENT_FOLDER = "attachments"
os.makedirs(LOCAL_ATTACHMENT_FOLDER, exist_ok=True)

# --- Koneksi DB ---
conn = psycopg2.connect(
    host=DB_HOST,
    port=DB_PORT,
    user=DB_USER,
    password=DB_PASSWORD,
    dbname=DB_NAME
)

# --- Query utama buat dapetin GUID ---
query_main = """
SELECT foto_pengukuran_kwh_bulan_sekarang_location 
FROM wfm_schema.tx_pm_site_power_pln
WHERE foto_pengukuran_kwh_bulan_sekarang_location <> ''
LIMIT 10
"""
df = pd.read_sql_query(query_main, conn)

# --- Ambil kolom location ---
location_columns = [col for col in df.columns if "location" in col.lower()]

# --- Ambil semua GUID unik ---
all_guids = set()
for col in location_columns:
    all_guids.update(df[col].dropna().tolist())

# --- Query path berdasarkan GUID ---
if not all_guids:
    print("⚠️ Tidak ada GUID ditemukan.")
    conn.close()
    exit()

placeholder = ', '.join(f"'{g}'" for g in all_guids)
query_path = f"""
    SELECT id, file_path FROM wfm_admin_schema.tx_attachment_reference
    WHERE id IN ({placeholder})
"""
guid_df = pd.read_sql_query(query_path, conn)
guid_to_path = dict(zip(guid_df['id'], guid_df['file_path']))

# --- Download file dari SFTP ---
with paramiko.Transport((SFTP_HOST, SFTP_PORT)) as transport:
    print("⚙️ Connecting to SFTP...")
    transport.connect(username=SFTP_USER, password=SFTP_PASS)
    sftp = paramiko.SFTPClient.from_transport(transport)

    for guid, path in guid_to_path.items():
        filename = f"{guid}.jpg"
        local_path = os.path.join(LOCAL_ATTACHMENT_FOLDER, filename)

        if os.path.exists(local_path):
            print(f"⚡ File sudah ada, skip: {filename}")
            continue

        try:
            sftp.get(path, local_path)
            print(f"📥 Downloaded: {filename}")
        except Exception as e:
            print(f"❌ Gagal download {filename}: {e}")

conn.close()
print("\n✅ Semua file berhasil diproses di folder 'attachments/'")
