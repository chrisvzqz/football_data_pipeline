CREATE TABLE IF NOT EXISTS matches (
    match_id INTEGER PRIMARY KEY,
    country TEXT,
    competition TEXT,
    utc_date TIMESTAMP,
    status TEXT,
    season TEXT,
    matchday INTEGER,
    home_team TEXT,
    away_team TEXT,
    home_goals INTEGER,
    away_goals INTEGER,
    winner TEXT,
    referee TEXT
);