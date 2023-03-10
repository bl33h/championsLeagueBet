select * from "match" m limit 5;

-- country PK
id
ALTER TABLE country
ADD PRIMARY KEY (id);

-- match PK
match_api_id
ALTER TABLE match
ADD PRIMARY KEY (match_api_id);

-- league PK
id
ALTER TABLE league
ADD PRIMARY KEY (id);

-- player PK
player_api_id
ALTER TABLE player
ADD PRIMARY KEY (player_api_id);

-- player attributes PK
id
ALTER TABLE player_attributes
ADD PRIMARY KEY (id);

-- team PK
team_api_id
ALTER TABLE team
ADD PRIMARY KEY (team_api_id);

-- team attributes PK
team_fifa_api_id
ALTER TABLE team_attributes 
ADD PRIMARY KEY (id);

-- 
ALTER TABLE match
ADD FOREIGN KEY (league_id) REFERENCES league(id);

--
ALTER TABLE league
ADD FOREIGN KEY (country_id) REFERENCES country(id);

--
ALTER TABLE player_attributes
ADD FOREIGN KEY (player_api_id) REFERENCES player(player_api_id);

--
ALTER TABLE team_attributes
ADD FOREIGN KEY (team_api_id) REFERENCES team(team_api_id);

--
select * from match limit 2;
select * from team limit 2;
select * from league limit 2;
select * from player_attributes limit 2;
select * from team limit 2;
select * from team_attributes limit 2;

--- Query 1
SELECT league.name AS league_name, match.season, 
       COALESCE(t_home.team_long_name, t_away.team_long_name) AS team_name,-- it executes the count regardless the team plays as home or away
       COUNT(*) AS season_matches_played
FROM match
	INNER JOIN league ON league.id = match.league_id
	LEFT JOIN team t_home ON t_home.team_api_id = match.home_team_api_id
	LEFT JOIN team t_away ON t_away.team_api_id = match.away_team_api_id
GROUP BY league.name, match.season, team_name
ORDER BY league.name, match.season, season_matches_played DESC;

--- Alter tabler
ALTER TABLE match
ALTER COLUMN away_team_goal TYPE INTEGER
USING CAST(away_team_goal AS INTEGER);

--- Query 2.1
WITH goals AS (
  SELECT 
    l.name AS league_name,
    t.team_long_name, 
    m.season, 
    SUM(CASE WHEN m.home_team_api_id = t.team_api_id THEN m.home_team_goal ELSE m.away_team_goal END) AS goals_in_favor,
    SUM(CASE WHEN m.home_team_api_id = t.team_api_id THEN m.away_team_goal ELSE m.home_team_goal END) AS goals_against,
    SUM(CASE WHEN m.home_team_api_id = t.team_api_id THEN m.home_team_goal - m.away_team_goal ELSE m.away_team_goal - m.home_team_goal END) AS difference
  FROM 
    match m
    INNER JOIN team t ON t.team_api_id = m.home_team_api_id OR t.team_api_id = m.away_team_api_id
    INNER JOIN league l ON l.id = m.league_id
  GROUP BY 
    l.name,
    t.team_long_name, 
    m.season
)
SELECT 
  g.league_name,
  g.season,
  g.team_long_name,
  g.goals_in_favor,
  g.goals_against,
  g.difference,
  RANK() OVER (PARTITION BY g.league_name, g.season ORDER BY g.difference DESC, g.goals_in_favor DESC) AS ranking
FROM 
  goals g
ORDER BY 
  g.league_name,
  g.season,
  ranking;

--- Query 2.2
 WITH goals AS (
  SELECT 
    l.name AS league_name,
    t.team_long_name, 
    m.season, 
    SUM(CASE WHEN m.home_team_api_id = t.team_api_id THEN m.home_team_goal ELSE m.away_team_goal END) AS goals_in_favor,
    SUM(CASE WHEN m.home_team_api_id = t.team_api_id THEN m.away_team_goal ELSE m.home_team_goal END) AS goals_against,
    SUM(CASE WHEN m.home_team_api_id = t.team_api_id THEN m.home_team_goal - m.away_team_goal ELSE m.away_team_goal - m.home_team_goal END) AS difference
  FROM 
    match m
    INNER JOIN team t ON t.team_api_id = m.home_team_api_id OR t.team_api_id = m.away_team_api_id
    INNER JOIN league l ON l.id = m.league_id
  GROUP BY 
    l.name,
    t.team_long_name, 
    m.season
)
SELECT 
  goals.team_long_name,
  goals.season,
  goals.goals_in_favor,
  goals.goals_against,
  goals.difference,
  RANK() OVER (PARTITION BY goals.season ORDER BY goals.goals_in_favor DESC, goals.difference ASC) AS ranking
FROM 
  goals
ORDER BY 
  ranking ASC
LIMIT 1;


--- Alter tabler
ALTER TABLE player_attributes 
ALTER COLUMN crossing TYPE INTEGER
USING CAST(crossing AS INTEGER);

ALTER TABLE player_attributes 
ALTER COLUMN finishing TYPE INTEGER
USING CAST(finishing AS INTEGER);

ALTER TABLE player_attributes 
ALTER COLUMN heading_accuracy TYPE INTEGER
USING CAST(heading_accuracy AS INTEGER);

ALTER TABLE player_attributes 
ALTER COLUMN short_passing TYPE INTEGER
USING CAST(short_passing AS INTEGER);

ALTER TABLE player_attributes 
ALTER COLUMN volleys TYPE INTEGER
USING CAST(volleys AS INTEGER);

ALTER TABLE player_attributes 
ALTER COLUMN dribbling TYPE INTEGER
USING CAST(dribbling AS INTEGER);

ALTER TABLE player_attributes 
ALTER COLUMN curve TYPE INTEGER
USING CAST(curve AS INTEGER);

ALTER TABLE player_attributes 
ALTER COLUMN free_kick_accuracy TYPE INTEGER
USING CAST(free_kick_accuracy AS INTEGER);

ALTER TABLE player_attributes 
ALTER COLUMN long_passing TYPE INTEGER
USING CAST(long_passing AS INTEGER);

ALTER TABLE player_attributes 
ALTER COLUMN ball_control TYPE INTEGER
USING CAST(ball_control AS INTEGER);

ALTER TABLE player_attributes 
ALTER COLUMN acceleration TYPE INTEGER
USING CAST(acceleration AS INTEGER);

ALTER TABLE player_attributes 
ALTER COLUMN sprint_speed TYPE INTEGER
USING CAST(sprint_speed AS INTEGER);

ALTER TABLE player_attributes 
ALTER COLUMN agility TYPE INTEGER
USING CAST(agility AS INTEGER);

ALTER TABLE player_attributes 
ALTER COLUMN reactions TYPE INTEGER
USING CAST(reactions AS INTEGER);

ALTER TABLE player_attributes 
ALTER COLUMN balance TYPE INTEGER
USING CAST(balance AS INTEGER);

ALTER TABLE player_attributes 
ALTER COLUMN shot_power TYPE INTEGER
USING CAST(shot_power AS INTEGER);

ALTER TABLE player_attributes 
ALTER COLUMN jumping TYPE INTEGER
USING CAST(jumping AS INTEGER);

ALTER TABLE player_attributes 
ALTER COLUMN stamina TYPE INTEGER
USING CAST(stamina AS INTEGER);

ALTER TABLE player_attributes 
ALTER COLUMN strength TYPE INTEGER
USING CAST(strength AS INTEGER);

ALTER TABLE player_attributes 
ALTER COLUMN long_shots TYPE INTEGER
USING CAST(long_shots AS INTEGER);

ALTER TABLE player_attributes 
ALTER COLUMN aggression TYPE INTEGER
USING CAST(aggression AS INTEGER);

ALTER TABLE player_attributes 
ALTER COLUMN interceptions TYPE INTEGER
USING CAST(interceptions AS INTEGER);

ALTER TABLE player_attributes 
ALTER COLUMN positioning TYPE INTEGER
USING CAST(positioning AS INTEGER);

ALTER TABLE player_attributes 
ALTER COLUMN vision TYPE INTEGER
USING CAST(vision AS INTEGER);

ALTER TABLE player_attributes 
ALTER COLUMN penalties TYPE INTEGER
USING CAST(penalties AS INTEGER);

ALTER TABLE player_attributes 
ALTER COLUMN marking TYPE INTEGER
USING CAST(marking AS INTEGER);

ALTER TABLE player_attributes 
ALTER COLUMN standing_tackle TYPE INTEGER
USING CAST(standing_tackle AS INTEGER);

ALTER TABLE player_attributes 
ALTER COLUMN sliding_tackle TYPE INTEGER
USING CAST(sliding_tackle AS INTEGER);

ALTER TABLE player_attributes 
ALTER COLUMN gk_diving TYPE INTEGER
USING CAST(gk_diving AS INTEGER);

ALTER TABLE player_attributes 
ALTER COLUMN gk_handling TYPE INTEGER
USING CAST(gk_handling AS INTEGER);

ALTER TABLE player_attributes 
ALTER COLUMN gk_kicking TYPE INTEGER
USING CAST(gk_kicking AS INTEGER);

ALTER TABLE player_attributes 
ALTER COLUMN gk_positioning TYPE INTEGER
USING CAST(gk_positioning AS INTEGER);

ALTER TABLE player_attributes 
ALTER COLUMN gk_reflexes TYPE INTEGER
USING CAST(gk_reflexes AS INTEGER);

--- Query 5
SELECT l.name AS league_name, m.season, p.player_name, pa.overall_rating, pa.potential
FROM league l
JOIN match m ON m.league_id = l.id
JOIN player_attributes pa ON pa.player_api_id = m.home_player_1 OR pa.player_api_id = m.home_player_2 OR pa.player_api_id = m.home_player_3 OR pa.player_api_id = m.home_player_4 OR pa.player_api_id = m.home_player_5 OR pa.player_api_id = m.home_player_6 OR pa.player_api_id = m.home_player_7 OR pa.player_api_id = m.home_player_8 OR pa.player_api_id = m.home_player_9 OR pa.player_api_id = m.home_player_10 OR pa.player_api_id = m.home_player_11 OR pa.player_api_id = m.away_player_1 OR pa.player_api_id = m.away_player_2 OR pa.player_api_id = m.away_player_3 OR pa.player_api_id = m.away_player_4 OR pa.player_api_id = m.away_player_5 OR pa.player_api_id = m.away_player_6 OR pa.player_api_id = m.away_player_7 OR pa.player_api_id = m.away_player_8 OR pa.player_api_id = m.away_player_9 OR pa.player_api_id = m.away_player_10 OR pa.player_api_id = m.away_player_11
JOIN player p ON p.player_api_id = pa.player_api_id
WHERE pa.overall_rating = (SELECT MAX(overall_rating) FROM player_attributes WHERE player_api_id = pa.player_api_id)
GROUP BY l.name, m.season, p.player_name, pa.overall_rating, pa.potential
ORDER BY l.name, m.season, pa.overall_rating DESC;

SELECT l.name AS league_name, m.season, p.player_name, pa.overall_rating, pa.potential
FROM league l
JOIN match m ON m.league_id = l.id
JOIN player_attributes pa ON pa.player_api_id = m.home_player_1 OR pa.player_api_id = m.home_player_2 OR pa.player_api_id = m.home_player_3 OR pa.player_api_id = m.home_player_4 OR pa.player_api_id = m.home_player_5 OR pa.player_api_id = m.home_player_6 OR pa.player_api_id = m.home_player_7 OR pa.player_api_id = m.home_player_8 OR pa.player_api_id = m.home_player_9 OR pa.player_api_id = m.home_player_10 OR pa.player_api_id = m.home_player_11 OR pa.player_api_id = m.away_player_1 OR pa.player_api_id = m.away_player_2 OR pa.player_api_id = m.away_player_3 OR pa.player_api_id = m.away_player_4 OR pa.player_api_id = m.away_player_5 OR pa.player_api_id = m.away_player_6 OR pa.player_api_id = m.away_player_7 OR pa.player_api_id = m.away_player_8 OR pa.player_api_id = m.away_player_9 OR pa.player_api_id = m.away_player_10 OR pa.player_api_id = m.away_player_11
JOIN player p ON p.player_api_id = pa.player_api_id
JOIN team t ON t.team_api_id = m.home_team_api_id OR t.team_api_id = m.away_team_api_id
JOIN team_attributes ta ON ta.team_api_id = t.team_api_id
WHERE pa.overall_rating = (SELECT MAX(overall_rating) FROM player_attributes WHERE player_api_id = pa.player_api_id)
AND ta.buildUpPlaySpeedClass = 'Fast' -- Ajustar según el atributo deseado
GROUP BY l.name, m.season, p.player_name, pa.overall_rating, pa.potential
ORDER BY l.name, m.season, pa.overall_rating DESC;

--- Query 12
SELECT team.team_long_name, COUNT(*) as wins_as_locals
FROM match
	JOIN team ON match.home_team_api_id = team.team_api_id
		WHERE match.home_team_goal > match.away_team_goal AND match.season IN ('2015/2016')
GROUP BY team.team_long_name
ORDER BY wins_as_locals DESC 
LIMIT 5;

--- Query 13
SELECT team.team_long_name, COUNT(*) as wins_as_visitors
FROM match
	JOIN team ON match.away_team_api_id = team.team_api_id
		WHERE match.home_team_goal < match.away_team_goal AND match.season IN ('2015/2016')
GROUP BY team.team_long_name
ORDER BY wins_as_visitors DESC 
LIMIT 5;

--- Query 14.1
SELECT DISTINCT league.name, AVG(match.home_team_goal + match.away_team_goal) as avg_goals
FROM match
	JOIN league ON match.league_id = league.id
	WHERE match.season IN ('2013/2014', '2014/2015', '2015/2016')
GROUP BY league.name;

-- Query 14.2
SELECT league.name, AVG(match.home_team_goal + match.away_team_goal) as avg_goals
FROM match
JOIN league ON match.league_id = league.id
WHERE match.season IN ('2013/2014', '2014/2015', '2015/2016')
GROUP BY league.name
ORDER BY avg_goals DESC
LIMIT 1;

--
with avg_home as(
	select home_team_api_id, season, 
	(coalesce(1/b365h::float,0)+coalesce(1/bwh::float,0)+coalesce(1/iwh::float,0)
	+coalesce(1/lbh::float,0)+coalesce(1/psh::float,0)+coalesce(1/whh::float,0)
	+coalesce(1/sjh::float,0)+coalesce(1/vch::float,0)+coalesce(1/gbh::float,0)
	+coalesce(1/bsh::float,0)/10) as prob_home
	from match
	where ((coalesce(1/b365h::float,0)+coalesce(1/bwh::float,0)+coalesce(1/iwh::float,0)
	+coalesce(1/lbh::float,0)+coalesce(1/psh::float,0)+coalesce(1/whh::float,0)
	+coalesce(1/sjh::float,0)+coalesce(1/vch::float,0)+coalesce(1/gbh::float,0)
	+coalesce(1/bsh::float,0)/10)) > 0
),
	avg_away as(
	select away_team_api_id, 
	(coalesce(1/b365a::float,0)+coalesce(1/bwa::float,0)+coalesce(1/iwa::float,0)
	+coalesce(1/lba::float,0)+coalesce(1/psa::float,0)+coalesce(1/wha::float,0)
	+coalesce(1/sja::float,0)+coalesce(1/vca::float,0)+coalesce(1/gba::float,0)
	+coalesce(1/bsa::float,0)/10) as prob_away
	from match
	where ((coalesce(1/b365a::float,0)+coalesce(1/bwa::float,0)+coalesce(1/iwa::float,0)
	+coalesce(1/lba::float,0)+coalesce(1/psa::float,0)+coalesce(1/wha::float,0)
	+coalesce(1/sja::float,0)+coalesce(1/vca::float,0)+coalesce(1/gba::float,0)
	+coalesce(1/bsa::float,0)/10)) > 0
)


select t.team_long_name, season, sum(((avg_home.prob_home + avg_away.prob_away)/2)) 
as probs
from avg_home
inner join avg_away on avg_home.home_team_api_id = avg_away.away_team_api_id
inner join team t on avg_home.home_team_api_id = team_api_id
group by t.team_long_name, season
order by probs desc

---
SELECT
    m.season,
    m.home_team_api_id AS team_id,
    t.team_long_name AS team_name,
    COUNT(*) AS num_wins
FROM (
    SELECT
        season,
        home_team_api_id,
        away_team_api_id,
        CASE
            WHEN home_team_goal > away_team_goal THEN home_team_api_id
            WHEN home_team_goal < away_team_goal THEN away_team_api_id
        END AS winner
    FROM match
) m
JOIN team t ON m.home_team_api_id = t.team_api_id
WHERE winner IS NOT NULL
GROUP BY 1,2,3
ORDER BY 1 DESC, 4 DESC
LIMIT 10;

--
SELECT ta.team_long_name AS team_name, AVG(m.possession) AS avg_possession
FROM match AS m
JOIN (
    SELECT team_api_id, team_long_name
    FROM team
    WHERE team_api_id IN (
        SELECT DISTINCT home_team_api_id
        FROM match
        WHERE season = '2015/2016' AND league_id = 21518
    ) OR team_api_id IN (
        SELECT DISTINCT away_team_api_id
        FROM match
        WHERE season = '2015/2016' AND league_id = 21518
    )
) AS ta ON m.home_team_api_id = ta.team_api_id OR m.away_team_api_id = ta.team_api_id
WHERE m.season = '2015/2016' AND m.league_id = 21518 AND m.possession IS NOT NULL
GROUP BY ta.team_long_name
ORDER BY avg_possession DESC
LIMIT 1;

--
SELECT AVG(CAST(p.possession AS DECIMAL)) AS avg_possession, 
       t.team_long_name AS team_name 
FROM Match m 
JOIN Team t ON m.home_team_api_id = t.team_api_id OR m.away_team_api_id = t.team_api_id 
JOIN League l ON m.league_id = l.id 
JOIN (
    SELECT * 
    FROM Match 
    WHERE season = '2015/2016' AND league_id = (SELECT id FROM League WHERE name = 'Spain LIGA BBVA')
) p ON m.id = p.id 
WHERE l.name = 'Spain LIGA BBVA' AND m.season = '2015/2016' 
GROUP BY t.team_long_name 
ORDER BY avg_possession DESC 
LIMIT 1;

--
SELECT 
    t.team_long_name AS team_name,
    CAST(SUM(CASE WHEN m.home_team_goal > m.away_team_goal THEN 1 ELSE 0 END) AS FLOAT)/COUNT(*) AS home_win_percentage,
    CAST(SUM(CASE WHEN m.home_team_goal < m.away_team_goal THEN 1 ELSE 0 END) AS FLOAT)/COUNT(*) AS away_win_percentage
FROM 
    Match m
    JOIN Team t ON m.home_team_api_id = t.team_api_id OR m.away_team_api_id = t.team_api_id
    JOIN League l ON m.league_id = l.id
WHERE 
    l.name = 'Spain LIGA BBVA'
    AND m.season = '2015/2016'
GROUP BY 
    t.team_long_name
order by home_win_percentage desc limit 10;


-- Query 15
SELECT t.team_long_name, COUNT(m.id) AS losses_all_along, 
       SUM(CASE WHEN m.home_team_api_id = t.team_api_id AND m.home_team_goal < m.away_team_goal THEN 1
                WHEN m.away_team_api_id = t.team_api_id AND m.home_team_goal > m.away_team_goal THEN 1
                ELSE 0 END) AS redemption_wins
FROM team AS t
	INNER JOIN match AS m ON t.team_api_id = m.home_team_api_id OR t.team_api_id = m.away_team_api_id
	INNER JOIN league AS l ON m.league_id = l.id
		WHERE l.name = 'Spain LIGA BBVA' AND m.season IN ('2008/2009', '2012/2013', '2015/2016')
GROUP BY t.team_long_name
	HAVING COUNT(m.id) >= 20 -- at least 20 matches
	AND SUM(CASE WHEN m.home_team_api_id = t.team_api_id AND m.home_team_goal < m.away_team_goal THEN 1
             WHEN m.away_team_api_id = t.team_api_id AND m.home_team_goal > m.away_team_goal THEN 1
             ELSE 0 END) > COUNT(m.id) / 2 -- consider only teams that had more wins than losses after the initial seasons
ORDER BY redemption_wins DESC
LIMIT 3;

-- Query 16
SELECT 
    t.team_long_name AS team_name,
    CAST(SUM(CASE WHEN m.home_team_goal > m.away_team_goal THEN 1 ELSE 0 END) AS FLOAT)/COUNT(*) AS home_win_percentage,
    CAST(SUM(CASE WHEN m.home_team_goal < m.away_team_goal THEN 1 ELSE 0 END) AS FLOAT)/COUNT(*) AS away_win_percentage
FROM 
    match m
    JOIN Team t ON m.home_team_api_id = t.team_api_id OR m.away_team_api_id = t.team_api_id
    JOIN League l ON m.league_id = l.id
WHERE 
    l.name = 'Spain LIGA BBVA'
    AND m.season = '2015/2016'
GROUP BY 
    t.team_long_name
ORDER BY home_win_percentage DESC LIMIT 10;




select * from league;