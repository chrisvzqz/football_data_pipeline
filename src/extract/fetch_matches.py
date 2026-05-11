from src.config.settings import API_KEY
import requests
import json
from datetime import datetime

uri = "https://api.football-data.org/v4/competitions/PD/matches"
headers = {"X-Auth-Token": API_KEY}

response = requests.get(uri, headers=headers)

data = response.json()['matches']
filename = f"data/raw/matches_{datetime.now().strftime('%Y%m%d_%H%M%S')}.json"

with open(filename, "w", encoding="utf-8") as f:
    json.dump(data, f, indent=4, ensure_ascii=False)