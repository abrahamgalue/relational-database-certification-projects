#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi
# Do not change code above this line. Use the PSQL variable above to query your database.

# Vaciar las tablas y reiniciar secuencias
$PSQL "TRUNCATE teams, games RESTART IDENTITY CASCADE" >/dev/null

# Procesar el archivo CSV
while IFS=',' read -r year round winner opponent winner_goals opponent_goals
do
    # Saltar la primera línea (cabecera)
    if [[ $year != "year" ]]; then
        # Insertar equipos si no existen (con manejo de mayúsculas/minúsculas)
        $PSQL "INSERT INTO teams(name) VALUES('$winner') ON CONFLICT (name) DO NOTHING" >/dev/null
        $PSQL "INSERT INTO teams(name) VALUES('$opponent') ON CONFLICT (name) DO NOTHING" >/dev/null

        # Obtener IDs exactos (case-sensitive)
        winner_id=$($PSQL "SELECT team_id FROM teams WHERE name='$winner'")
        opponent_id=$($PSQL "SELECT team_id FROM teams WHERE name='$opponent'")

        # Insertar el partido con todos los campos requeridos
        $PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($year, '$round', $winner_id, $opponent_id, $winner_goals, $opponent_goals)" >/dev/null
    fi
done < games.csv

# Verificación de conteos (opcional, para debug)
TEAMS_COUNT=$($PSQL "SELECT COUNT(*) FROM teams")
GAMES_COUNT=$($PSQL "SELECT COUNT(*) FROM games")

echo "Total equipos insertados: $TEAMS_COUNT (deberían ser 24)"
echo "Total partidos insertados: $GAMES_COUNT (deberían ser 32)"