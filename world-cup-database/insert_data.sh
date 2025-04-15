#!/bin/bash

# Script to insert data from games.csv into worldcup database

# Ensure script exits if any command fails
set -e

# Check if games.csv exists
if [[ ! -f games.csv ]]
then
  echo "Error: games.csv not found!"
  exit 1
fi

# Database connection variable - Adjust username/dbname if necessary
# -t = tuples only (no headers)
# --no-align = unaligned text format (easier for variable assignment)
PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"

# Clear existing data from tables and reset sequences
echo $($PSQL "TRUNCATE teams, games RESTART IDENTITY CASCADE")

# Read games.csv, skip header row (using tail -n +2)
tail -n +2 games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # --- Handle Teams ---

  # Check if winner team exists, if not insert it
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  if [[ -z $WINNER_ID ]]
  then
    INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
    if [[ $INSERT_WINNER_RESULT == "INSERT 0 1" ]]
    then
      echo Inserted team: $WINNER
      # Get the new winner_id
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    else
      echo "Error inserting team: $WINNER"
      exit 1 # Exit if team insertion fails
    fi
  fi

  # Check if opponent team exists, if not insert it
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  if [[ -z $OPPONENT_ID ]]
  then
    INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
    if [[ $INSERT_OPPONENT_RESULT == "INSERT 0 1" ]]
    then
      echo Inserted team: $OPPONENT
      # Get the new opponent_id
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    else
       echo "Error inserting team: $OPPONENT"
       exit 1 # Exit if team insertion fails
    fi
  fi

  # --- Handle Games ---
  # Insert game data using the retrieved IDs
  INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
  if [[ $INSERT_GAME_RESULT == "INSERT 0 1" ]]
  then
    echo Inserted game: $YEAR $ROUND - $WINNER vs $OPPONENT ($WINNER_GOALS-$OPPONENT_GOALS)
  else
    echo "Error inserting game: $YEAR $ROUND $WINNER vs $OPPONENT"
    exit 1 # Exit if game insertion fails
  fi

done < <(tail -n +2 games.csv) # Feed the loop correctly

echo "Data insertion complete."
echo "Total teams inserted: $($PSQL "SELECT COUNT(*) FROM teams")"
echo "Total games inserted: $($PSQL "SELECT COUNT(*) FROM games")"