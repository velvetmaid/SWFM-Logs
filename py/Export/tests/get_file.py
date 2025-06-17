import os
import psycopg2
import pysftp
from dotenv import load_dotenv

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

TEST_GUID = "83a566aa-a5d8-437f-9959-086fc93e6dd7"

LOCAL_FOLDER = "attachments"
os.makedirs(LOCAL_FOLDER, exist_ok=True)

def get_path_by_guid(guid):
    conn = psycopg2.connect(
        host=DB_HOST,
        port=DB_PORT,
        user=DB_USER,
        password=DB_PASSWORD,
        dbname=DB_NAME
    )
    cursor = conn.cursor()
    query = f"""
        SELECT file_path 
        FROM wfm_admin_schema.tx_attachment_reference 
        WHERE id = '{guid}'
    """
    cursor.execute(query)
    result = cursor.fetchone()
    conn.close()
    return result[0] if result else None

# Connection options
cnopts = pysftp.CnOpts()
cnopts.hostkeys = None  

try:
    print("🔎 Nyari path dari DB...")
    file_path = get_path_by_guid(TEST_GUID)
    
    if not file_path:
        print("❌ GUID gak ketemu di DB")
        exit()

    local_file = os.path.join(LOCAL_FOLDER, f"{TEST_GUID}.jpg")

    print("🚀 Connect ke SFTP...")
    with pysftp.Connection(
        host=SFTP_HOST,
        port=SFTP_PORT,
        username=SFTP_USER,
        password=SFTP_PASS,
        cnopts=cnopts
    ) as sftp:
        print(f"📥 Sedot file dari: {file_path}")
        sftp.get(file_path, local_file)

    print(f"✅ File berhasil disedot ke: {local_file}")
except Exception as e:
    print(f"❌ GAGAL NYEDOT BRO: {e}")
