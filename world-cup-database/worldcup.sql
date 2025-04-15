-- Drop existing database if it exists (optional, useful for testing)
-- Run this command separately in psql or terminal: DROP DATABASE IF EXISTS worldcup;
-- Run this command separately in psql or terminal: CREATE DATABASE worldcup;

-- Connect to the database (if running script via psql)
-- \c worldcup;

DROP TABLE IF EXISTS games;
DROP TABLE IF EXISTS teams;

CREATE TABLE teams (
  team_id SERIAL PRIMARY KEY,
  name VARCHAR(255) UNIQUE NOT NULL
);

CREATE TABLE games (
  game_id SERIAL PRIMARY KEY,
  year INT NOT NULL,
  round VARCHAR(50) NOT NULL,
  winner_id INT NOT NULL,
  opponent_id INT NOT NULL,
  winner_goals INT NOT NULL,
  opponent_goals INT NOT NULL,
  FOREIGN KEY(winner_id) REFERENCES teams(team_id),
  FOREIGN KEY(opponent_id) REFERENCES teams(team_id)
);

COMMENT ON TABLE teams IS 'Stores unique team names and their IDs';
COMMENT ON TABLE games IS 'Stores game details, linking winners and opponents to the teams table';