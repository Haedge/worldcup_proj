#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE teams, games restart identity")

cat games.csv | while IFS="," read year round winner opponent winner_goals opponent_goals
do
  if [[ $year != "year" ]]
    then
      #gets both teams' team_id
      winner_id=$($PSQL "select team_id from teams where name='$winner'");
      opp_id=$($PSQL "select team_id from teams where name='$opponent'");
      #checks to see if both team is already in teams
      if [[ -z $winner_id ]]
      then
        # inserts the winning team into the table and gets team_id
        echo $($PSQL "insert into teams(name) values ('$winner')");
        winner_id=$($PSQL "select team_id from teams where name='$winner'");
      fi

      if [[ -z $opp_id ]]
      then
        # inserts the opponent team into the table and gets team_id
        echo $($PSQL "insert into teams(name) values ('$opponent')");
        opp_id=$($PSQL "select team_id from teams where name='$opponent'");
      fi

      # Finally inserts everything into the db
      echo $($PSQL "insert into games (year, round, winner_id, opponent_id, winner_goals, opponent_goals)
      values ('$year', '$round', '$winner_id', '$opp_id', '$winner_goals', '$opponent_goals')");
  fi
done
