from src.db.connection import get_connection
import pandas as pd

def read_processed_csv(file_path):
    return pd.read_csv(file_path)


def insert_matches(df):
    conn = get_connection()
    cur = conn.cursor()

    try:
        for _, row in df.iterrows():
            cur.execute("""
                INSERT INTO matches (
                    match_id,
                    country,
                    competition,
                    utc_date,
                    status,
                    season,
                    matchday,
                    home_team,
                    away_team,
                    home_goals,
                    away_goals,
                    winner,
                    referee
                )
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                ON CONFLICT (match_id) DO NOTHING;
            """, (
                int(row["match_id"]),
                row["country"],
                row["competition"],
                row["utc_date"],
                row["status"],
                row["season"],
                int(row["matchday"]),
                row["home_team"],
                row["away_team"],
                int(row["home_goals"]),
                int(row["away_goals"]),
                row["winner"],
                row["referee"],
            ))

        conn.commit()

    except Exception as e:
        conn.rollback()
        print(f"Error inserting matches: {e}")

    finally:
        cur.close()
        conn.close()


def run_load(processed_file_path):
    df = read_processed_csv(processed_file_path)
    insert_matches(df)
    print("Data loaded into PostgreSQL successfully.")


if __name__ == "__main__":
    run_load()