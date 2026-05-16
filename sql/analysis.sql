-- PARTIDOS CON MÁS GOLES
SELECT 
    match_id,
    home_team,
    away_team,
    home_goals,
    away_goals,
    (home_goals + away_goals) AS total_goals
FROM matches
ORDER BY total_goals DESC
LIMIT 10;

 -- EQUIPOS CON MÁS VICTORIAS
 WITH winners AS(
    SELECT
        CASE WHEN winner = 'HOME_TEAM' THEN home_team
            WHEN winner = 'AWAY_TEAM' THEN away_team
        END AS winner_team
    FROM matches
 )
 SELECT 
    winner_team, 
    COUNT(*) AS victorias
 FROM winners
 WHERE winner_team IS NOT NULL
 GROUP BY winner_team
 ORDER BY victorias DESC;

 -- PROMEDIO GOLES POR PARTIDO
 SELECT
    AVG(home_goals + away_goals) AS AvgGoals
 FROM matches;

 -- GOLES COMO LOCAL VS VISITANTE
 WITH goles_combinados AS (
    -- Goles cuando juegan en casa
    SELECT home_team AS equipo, home_goals AS goles, 'local' AS condicion
    FROM matches
    UNION ALL
    -- Goles cuando juegan fuera
    SELECT away_team AS equipo, away_goals AS goles, 'visitante' AS condicion
    FROM matches
 )
 SELECT 
    equipo,
    SUM(CASE WHEN condicion = 'local' THEN goles ELSE 0 END) AS goles_como_local,
    SUM(CASE WHEN condicion = 'visitante' THEN goles ELSE 0 END) AS goles_como_visitante
 FROM goles_combinados
 GROUP BY equipo;

 -- PUNTOS POR EQUIPO
 WITH puntos_por_partido AS (
    -- Puntos jugando en casa
    SELECT
        home_team AS equipo,
        CASE
            WHEN winner = 'HOME_TEAM' THEN 3
            WHEN winner = 'DRAW' THEN 1
            ELSE 0
            END AS puntos
    FROM matches
    UNION ALL
    -- Puntos jugando fuera
    SELECT
        away_team AS equipo,
        CASE
            WHEN winner = 'AWAY_TEAM' THEN 3
            WHEN winner = 'DRAW' THEN 1
            ELSE 0
            END AS puntos
    FROM matches
 )
 SELECT
    equipo,
    SUM(puntos) AS puntos_totales
 FROM puntos_por_partido
 GROUP BY equipo
 ORDER BY puntos_totales DESC;


 -- RENDIMIENTO VALENCIA CF
 WITH partidos_valencia AS (
    -- Partidos en casa
    SELECT 
        away_team AS rival,
        home_goals AS goles_a_favor,
        away_goals AS goles_en_contra,
        CASE 
            WHEN winner = 'HOME_TEAM' THEN 3
            WHEN winner = 'DRAW' THEN 1
            ELSE 0
        END AS puntos,
        CASE WHEN winner = 'HOME_TEAM' THEN 1 ELSE 0 END AS victoria,
        CASE WHEN winner = 'DRAW' THEN 1 ELSE 0 END AS empate,
        CASE WHEN winner = 'AWAY_TEAM' THEN 1 ELSE 0 END AS derrota
    FROM matches
    WHERE home_team = 'Valencia CF'

    UNION ALL

    -- Partidos fuera
    SELECT 
        home_team AS rival,
        away_goals AS goles_a_favor,
        home_goals AS goles_en_contra,
        CASE 
            WHEN winner = 'AWAY_TEAM' THEN 3
            WHEN winner = 'DRAW' THEN 1
            ELSE 0
        END AS puntos,
        CASE WHEN winner = 'AWAY_TEAM' THEN 1 ELSE 0 END AS victoria,
        CASE WHEN winner = 'DRAW' THEN 1 ELSE 0 END AS empate,
        CASE WHEN winner = 'HOME_TEAM' THEN 1 ELSE 0 END AS derrota
    FROM matches
    WHERE away_team = 'Valencia CF'
 )
 SELECT 
    'Valencia CF' AS equipo,
    COUNT(*) AS partidos_jugados,
    SUM(victoria) AS victorias_totales,
    SUM(empate) AS empates_totales,
    SUM(derrota) AS derrotas_totales,
    SUM(puntos) AS puntos_totales,
    SUM(goles_a_favor) AS total_goles_marcados,
    SUM(goles_en_contra) AS total_goles_recibidos,
    ROUND(AVG(goles_a_favor), 2) AS promedio_goles_por_partido,
    ROUND(CAST(SUM(victoria) AS DECIMAL) / COUNT(*) * 100, 2) AS porcentaje_victorias
 FROM partidos_valencia;


-- PARTIDOS CON MÁS GOLES 
 SELECT
    home_team,
    away_team,
    (home_goals + away_goals) AS total_goals
FROM matches
ORDER BY (home_goals + away_goals) DESC
LIMIT 10;


-- CLASIFICACIÓN COMPLETA: PUNTOS, PARTIDOS JUGADOS, VICTORIAS, EMPATES, DERRROTAS, GOLES A FAVOR, GOLES EN CONTRA, DIFERENCIA DE GOLES
WITH puntos_por_partido AS(
SELECT
    home_team AS equipo,
    home_goals AS goles_a_favor,
    away_goals AS goles_en_contra,
    CASE WHEN winner = 'HOME_TEAM' THEN 3
        WHEN winner = 'DRAW' THEN 1
        ELSE 0
    END AS puntos,
    CASE WHEN winner = 'HOME_TEAM' THEN 1 ELSE 0 END AS victorias,
    CASE WHEN winner = 'DRAW' THEN 1 ELSE 0 END AS empates,
    CASE WHEN winner = 'AWAY_TEAM' THEN 1 ELSE 0 END AS derrotas
FROM matches

    UNION ALL

SELECT
    away_team AS equipo,
    away_goals AS goles_a_favor,
    home_goals AS goles_en_contra,
    CASE WHEN winner = 'AWAY_TEAM' THEN 3
        WHEN winner = 'DRAW' THEN 1
        ELSE 0
    END AS puntos,
    CASE WHEN winner = 'AWAY_TEAM' THEN 1 ELSE 0 END AS victorias,
    CASE WHEN winner = 'DRAW' THEN 1 ELSE 0 END AS empates,
    CASE WHEN winner = 'HOME_TEAM' THEN 1 ELSE 0 END AS derrotas
FROM matches
)
SELECT
    equipo,
    COUNT(*) AS partidos_jugados,
    SUM(puntos) AS puntos_totales,
    SUM(victorias) AS victorias_totales,
    SUM(empates) AS empates_totales,
    SUM(derrotas) AS derrotas_totales,
    SUM(goles_a_favor) AS goles_favor,
    SUM(goles_en_contra) AS goles_contra,
    SUM(goles_a_favor) - SUM(goles_en_contra) AS diff_goles
FROM puntos_por_partido
GROUP BY equipo
ORDER BY SUM(puntos) DESC;


-- PROMEDIO DE GOLES POR JORNADA
SELECT
    matchday AS jornada,
    ROUND(AVG(COALESCE(home_goals, 0) + COALESCE(away_goals, 0)), 2) AS promedio_goles
FROM matches
GROUP BY matchday
ORDER BY matchday