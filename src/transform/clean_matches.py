import json
from datetime import datetime
import pandas as pd

def read_raw_matches(file_path):
    with open(file_path, "r", encoding="utf-8") as f:
        data = json.load(f)

    return data


def transform_matches(data):
    partidos = []

    for match in data:
        partidos.append({
            "match_id": match["id"],
            "country": match["area"]["name"],
            "competition": match["competition"]["name"],
            "utc_date": match["utcDate"],
            "status": match["status"],
            "season": f"{match['season']['startDate'][:4]} - {match['season']['endDate'][:4]}",
            "matchday": match["matchday"],
            "home_team": match["homeTeam"]["name"],
            "away_team": match["awayTeam"]["name"],
            "home_goals": match["score"]["fullTime"]["home"],
            "away_goals": match["score"]["fullTime"]["away"],
            "winner": match["score"]["winner"],
            "referee": match["referees"][0]["name"] if match["referees"] else "Desconocido",
        })

    df = pd.DataFrame(partidos)

    df_finished = df.loc[df["status"] == "FINISHED"].copy()

    df_finished["home_goals"] = df_finished["home_goals"].astype(int)
    df_finished["away_goals"] = df_finished["away_goals"].astype(int)
    df_finished["utc_date"] = pd.to_datetime(df_finished["utc_date"])

    return df_finished


def save_processed_matches(df, output_dir="./data/processed"):
    output_path = f"{output_dir}/laliga_matches_{datetime.now().strftime('%Y%m%d_%H%M%S')}.csv"
    df.to_csv(output_path, index=False)

    return output_path


def run_transformation(raw_file_path):
    data = read_raw_matches(raw_file_path)
    df = transform_matches(data)
    output_path = save_processed_matches(df)

    print(f"Processed file saved at: {output_path}")
    return output_path


if __name__ == "__main__":
    run_transformation()