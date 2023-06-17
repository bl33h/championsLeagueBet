# championsLeagueBet
This project utilizes database technologies to create and load data models, with the aim of using SQL language for research, development, and presenting results for business-related questions to support decision-making processes. The dataset used consists of CSV files containing information about European football matches, players, and their characteristics.

The main objective of the project is to analyze the provided data and answer the following question: Based on the performance of teams and players according to this model, which team would you bet on? The answer should be supported by data-driven justifications.

<p align="center">
  <br>
  <img src="https://media.tenor.com/uGJlZtw8MXIAAAAC/uefa-champions-league.gif" alt="pic" width="600">
  <br>
</p>
<p align="center" >
  <a href="#Files">Files</a> •
  <a href="#entity-relationship-diagram">ERD</a> •
  <a href="#features">Features</a> •
  <a href="#the-team-i-would-bet-on">The team I would bet on</a> •
  <a href="#how-to-use">How To Use</a> 
</p>

## Entity Relationship Diagram

<p align="center">
  <br>
  <img src="https://i.imgur.com/p2WA5X7.jpeg" alt="erd" width="600">
  <br>
</p>

## Files

- src: the file that implements de solution.
  - database: The .dump file is a backup file of the PostgreSQL database, containing the structure of the database, such as tables, indexes, and constraints, along with the stored data.
  - graphics: This Python script connects to the PostgreSQL database, executes SQL queries, and generates graphics to analyze team performance and average goals in the Champions League.
  - queries & mods: An SQL file that contains a collection of statements designed to create a schema specifically for managing and analyzing football match data.
  - script: This Python file creates a PostgreSQL database and imports data from CSV files into separate tables. It handles column renaming, special characters, empty cells, and excludes rows with ".xml" files.
    
## Features

- Processing and loading CSV files into a PostgreSQL database.
- Analyzing and understanding the data model.
- Defining metrics to justify decision-making.
- Developing queries to calculate the defined metrics.
- Executing queries to obtain statistics on games played, best teams, rankings, betting odds, player attributes, and other relevant information.
- Formulating additional questions to further justify the betting decision.
- Presenting the project results through SQL queries.

## The team I would bet on
According to the results obtained from 63% of the queries (10/16), the team I would bet on is FC Barcelona. If possible, specifying for roster reasons and performance, the club would be selected during the 2008/2009 or 2012/2013 season.

<p align="center">
  <br>
  <img src="https://3.bp.blogspot.com/-SuG29vc5mzI/UwB9koNY3pI/AAAAAAAAFfY/Smu23F9C1Lw/s1600/Iniesta+against+Rayo+Vallecano.jpg" alt="pic" width="400">
  <br>
</p>

## How To Use
To clone and run this application, you'll need [Git](https://git-scm.com), [Python](https://www.python.org/downloads/) and [psql](https://www.postgresql.org/download/) installed on your computer. From your command line:

```bash
# Clone this repository
$ git clone https://github.com/bl33h/temperatureConverter

# Restore the database in the psql cmd 
$ CREATE DATABASE champions

# Back to your normal command line
$ pg_restore -U <username> -d <champions> <path_to_dump_file> # The username is usually postgres and for the dump file path you can right click on it and copy as path

# Run the graphic queries
$ python championsleaguebet_graphics.py
```


