#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
#!/bin/bash
#$($PSQL "TRUNCATE TABLE games, teams;")
#TRUNCATE TABLE games, teams;
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
### Lisää joukkueet ja estä duplikaatit

# aTarkista voittajajoukkue
WINNER_ID=$($PSQL "SELECT name FROM teams WHERE name='$WINNER';")
# joo, Jos joukkue ei ole olemassa lisää se
if [[ -z $WINNER_ID && "$WINNER" != "winner" ]]
then
  INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER');")
fi

# vastustajajoukkue
OPPONENT_ID=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT';")
# joo, Jos joukkue ei ole olemassa lisää se
if [[ -z $OPPONENT_ID && "$OPPONENT" != "opponent" ]]
then
  INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT');")
fi

WINNER_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
OPPONENT_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")

#echo -e "$YEAR,'$ROUND',$WINNER_GOALS,$OPPONENT_GOALS,$WINNER_TEAM_ID"
if [[ "$YEAR" != "year" ]]
then
  LISAA_RIVI=$($PSQL "INSERT INTO games(year, round, winner_id, team_id, winner_goals, opponent_goals) VALUES($YEAR,'$ROUND',$WINNER_TEAM_ID,$OPPONENT_TEAM_ID,$WINNER_GOALS,$OPPONENT_GOALS);")
fi

done








