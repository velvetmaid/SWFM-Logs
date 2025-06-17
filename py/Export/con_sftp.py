import os
import pysftp
from dotenv import load_dotenv

load_dotenv()

SFTP_HOST = os.getenv("SFTP_HOST")
SFTP_PORT = int(os.getenv("SFTP_PORT", 22))
SFTP_USER = os.getenv("SFTP_USER")
SFTP_PASS = os.getenv("SFTP_PASSWORD")

cnopts = pysftp.CnOpts()
cnopts.hostkeys = None

try:
    with pysftp.Connection(
        host=SFTP_HOST,
        username=SFTP_USER,
        password=SFTP_PASS,
        port=SFTP_PORT,
        cnopts=cnopts
    ) as sftp:
        print("✅ Connected to SFTP")

        print("📁 Root SFTP:")
        for file in sftp.listdir('.'):
            print(" -", file)

except Exception as e:
    print("❌ Fail to connect SFTP:", str(e))
