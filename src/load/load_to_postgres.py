from src.db.connection import get_connection
import pandas as pd

conn = get_connection()

csv_file = "data/processed/laliga_matches.csv"
df = pd.read_csv(csv_file)
#df = df.head(100)

cur = conn.cursor()
for index, row in df.iterrows():
    cur.execute("""
        INSERT INTO matches (match_id, country, competition, utc_date, status, season, matchday, home_team, away_team, home_goals, away_goals, winner, referee)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
    """, (int(row['match_id']), row['country'], row['competition'], row['utc_date'], row['status'], row['season'], int(row['matchday']), row['home_team'], row['away_team'], int(row['home_goals']), int(row['away_goals']), row['winner'], row['referee']))
conn.commit()
cur.close()
conn.close()