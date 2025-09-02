import requests
from bs4 import BeautifulSoup

url = "https://www.hargasolarindustri.com/2020/01/harga-solar-industri-hsd-terbaru-harga.html"

headers = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"
}
response = requests.get(url, headers=headers)
response.raise_for_status() 

soup = BeautifulSoup(response.text, "html.parser")

periode = soup.select_one(
    "#post-body-3033859995764641079 > div > div:nth-of-type(3) > span"
)
if periode:
    print(periode.get_text(strip=True))

table_rows = soup.select(
    "#post-body-3033859995764641079 > div:nth-child(1) > table:nth-child(8) > tbody > tr"
)

for i, row in enumerate(table_rows, start=1):
    cells = [cell.get_text(strip=True) for cell in row.find_all(['td', 'th'])]
    print(f"Row {i}: {cells}")

PERIODE
AFTER: #post-body-3033859995764641079 > div > div:nth-of-type(3) > span
BEFORE: #post-body-3033859995764641079 > div:nth-child(1) > div:nth-child(3) > span

CURRENT DATE
AFTER: #post-body-3033859995764641079 > div:nth-child(1) > table:nth-child(8) > thead > tr > th:nth-child(2)
BEFORE: #post-body-3033859995764641079 > div:nth-child(1) > table:nth-child(4) > thead:nth-child(1) > tr:nth-child(1) > th:nth-child(2)

PREVIOUS DATE
AFTER: #post-body-3033859995764641079 > div:nth-child(1) > table:nth-child(8) > thead > tr > th:nth-child(3)
BEFORE: #post-body-3033859995764641079 > div:nth-child(1) > table:nth-child(4) > thead:nth-child(1) > tr:nth-child(1) > th:nth-child(3)

DATA ROWS
AFTER: #post-body-3033859995764641079 > div:nth-child(1) > table:nth-child(8) > tbody > tr
BEFORE: #post-body-3033859995764641079 > div:nth-child(1) > table:nth-child(4) > tbody > tr