from src.config.settings import API_KEY
import requests
import json
from datetime import datetime

uri = "https://api.football-data.org/v4/competitions/PD/matches"

def fetch_matches_from_api(uri, api_key):
    headers = {"X-Auth-Token": api_key}
    response = requests.get(uri, headers=headers)

    if response.status_code == 200:
        return response.json()['matches']
    else:
        print(f"Error fetching data: {response.status_code} - {response.text}")
        return None
    
def save_raw_matches(data, filename):
    with open(filename, "w", encoding="utf-8") as f:
        json.dump(data, f, indent=4, ensure_ascii=False)
    
def run_extraction():
    matches = fetch_matches_from_api(uri, API_KEY)

    if matches:
        filename = f"data/raw/matches_{datetime.now().strftime('%Y%m%d_%H%M%S')}.json"
        save_raw_matches(matches, filename)
        print(f"Data fetched and saved to {filename}")
        return filename

    print("No data to save.")
    return None
        
if __name__ == "__main__":
    run_extraction()
