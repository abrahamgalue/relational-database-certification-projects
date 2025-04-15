#!/bin/bash

# Script to execute queries against the worldcup database

# Database connection variable - Adjust username/dbname if necessary
# -t = tuples only (no headers)
# -A = unaligned text format (no column spacing, just | delimiters if multiple columns)
PSQL="psql --username=freecodecamp --dbname=worldcup -tA -c"

echo -e "\nTotal number of goals in all games from winning teams:"
echo "$($PSQL "SELECT SUM(winner_goals) FROM games")"

echo -e "\nTotal number of goals in all games from both teams combined:"
echo "$($PSQL "SELECT SUM(winner_goals + opponent_goals) FROM games")"

echo -e "\nAverage number of goals in all games from the winning teams:"
echo "$($PSQL "SELECT AVG(winner_goals) FROM games")"

echo -e "\nAverage number of goals in all games from the winning teams rounded to two decimal places:"
echo "$($PSQL "SELECT ROUND(AVG(winner_goals), 2) FROM games")"

echo -e "\nAverage number of goals in all games from both teams combined:"
echo "$($PSQL "SELECT AVG(winner_goals + opponent_goals) FROM games")"

echo -e "\nMost goals scored in a single game by one team:"

echo "$($PSQL "SELECT MAX(GREATEST(winner_goals, opponent_goals)) FROM games")"

echo -e "\nNumber of games where the winning team scored more than two goals:"
echo "$($PSQL "SELECT COUNT(*) FROM games WHERE winner_goals > 2")"

echo -e "\nWinner of the 2018 tournament team name:"
echo "$($PSQL "SELECT t.name FROM games g JOIN teams t ON g.winner_id = t.team_id WHERE g.year=2018 AND g.round='Final'")"

echo -e "\nList of teams who played in the 2014 'Eighth-Final' round:"

echo "$($PSQL "SELECT DISTINCT(t.name) FROM teams t INNER JOIN games g ON t.team_id = g.winner_id OR t.team_id = g.opponent_id WHERE g.year=2014 AND g.round='Eighth-Final' ORDER BY t.name")"


echo -e "\nList of unique winning team names in the whole data set, ordered alphabetically:"
echo "$($PSQL "SELECT DISTINCT(t.name) FROM teams t JOIN games g ON t.team_id = g.winner_id ORDER BY t.name")"

echo -e "\nYear and team name of all the champions:"
echo "$($PSQL "SELECT g.year, t.name FROM games g JOIN teams t ON g.winner_id = t.team_id WHERE g.round='Final' ORDER BY g.year")"

echo -e "\nList of teams that start with 'Co':"
echo "$($PSQL "SELECT name FROM teams WHERE name LIKE 'Co%' ORDER BY name")"

echo -e "\nQuery execution complete."