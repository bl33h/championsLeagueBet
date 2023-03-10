#/**
 #* *Copyright (C), 2023-2024, Sara Echeverria (bl33h)
    # *@author Sara Echeverria, Ricardo Mendez
    # *FileName: championsleaguebet_graphics
    # @version: I
    #- Creation: 20/02/2023
    #- Last modification: 05/03/2023

# Library import
import pandas as pd
import psycopg2
import matplotlib.pyplot as plt

# PostgreSQL database connection
conn = psycopg2.connect(
    host="localhost",
    database="championsleaguebet", # Database name (it must be created before executing the code)
    user="postgres", # psql user, it usually remains postgres
    password="passworD" # psql password
)
cur = conn.cursor()

# Query 12
query12 = """
SELECT team.team_long_name, COUNT(*) as wins_as_visitors
FROM match
JOIN team ON match.away_team_api_id = team.team_api_id
WHERE match.home_team_goal < match.away_team_goal AND match.season IN ('2015/2016')
GROUP BY team.team_long_name
ORDER BY wins_as_visitors DESC 
LIMIT 5;
"""
# Query 13
query13 = """ 
SELECT team.team_long_name, COUNT(*) as wins_as_locals
FROM match
JOIN team ON match.home_team_api_id = team.team_api_id
WHERE match.home_team_goal > match.away_team_goal AND match.season IN ('2015/2016')
GROUP BY team.team_long_name
ORDER BY wins_as_locals DESC 
LIMIT 5;
"""

# Query 14
query14 = """ 
SELECT league.name, AVG(match.home_team_goal + match.away_team_goal) AS avg_goals 
FROM league 
JOIN match ON league.id = match.league_id 
WHERE season IN ('2013/2014', '2014/2015', '2015/2016') 
GROUP BY league.name 
ORDER BY avg_goals DESC
"""
df = pd.read_sql_query(query14, conn)

# Execute query
cur.execute(query13)

# Data results in a list
teams = []
wins = []
for row in cur.fetchall():
     teams.append(row[0])
     wins.append(row[1])

# Bars graphic creation
plt.bar(teams, wins)
plt.title("Equipos con más victorias como locales en la temporada 2015/2016")
plt.xlabel("Equipo")
plt.ylabel("Número de victorias")

# Box and whiskers
plt.boxplot(df['avg_goals'])
plt.xticks([1], ['Promedio de goles'])
plt.title('Promedio de goles por liga')
plt.show()

# Show bars graphic
plt.show()

# Finish the PostgreSQL database connection
# cur.close()
conn.close()