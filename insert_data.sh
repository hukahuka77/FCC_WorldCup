#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.


#start by emptying the rows in the tables of the database so we can rerun the file
echo $($PSQL "TRUNCATE TABLE games, teams")

# inserting here
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
# Get teams table data (team name)

  if [[ $WINNER != "winner" ]]
    then
      TEAM_NAME=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
        #if team name not found, add to db
        if [[ -z $TEAM_NAME ]]
          then 
           TEAM_NAME_INSERTED=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
           if [[ $TEAM_NAME_INSERTED == "INSERT 0 1" ]]
                  then
                    echo Inserted team $WINNER
                  else
                    echo Not Inserted
                fi
        fi
  fi
  if [[ $OPPONENT != "opponent" ]]
    then
      TEAM_NAME=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
        #if team name not found, add to db
        if [[ -z $TEAM_NAME ]]
          then 
           TEAM_NAME_INSERTED=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
           if [[ $TEAM_NAME_INSERTED == "INSERT 0 1" ]]
                  then
                    echo Inserted team $WINNER
                  else
                    echo Not Inserted
                fi
        fi
  fi

  #Get games data
  if [[ $YEAR != "year" ]]
    then
      WINNER_ID=$($PSQL "SELECT team_id from teams where name='$WINNER'")
      OPPONENT_ID=$($PSQL "SELECT team_id from teams where name='$OPPONENT'")
      INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals)
      VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)") 
      if [[ $INSERT_GAME == "INSERT 0 1" ]]
       then
          echo New game added: $YEAR, $ROUND, $WINNER_ID VS $OPPONENT_ID, score $WINNER_GOALS : $OPPONENT_GOALS
      fi
 
  fi
done
