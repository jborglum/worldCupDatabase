#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
 #Make sure database is empty 
  echo=$($PSQL "TRUNCATE TABLE games, teams")
#Read CVS file and inert data  
cat games.csv | while IFS=',' read year round winner opponent winner_goals opponent_goals
do
  #Check if winner column is already in database and if not add 
  if [[ $winner != "winner" ]]
  then
    WINNING_TEAM=$($PSQL "select name from teams where name='$winner'")
    if [[ -z $WINNING_TEAM ]]
      then
        INSERT_WINNING_TEAM=$($PSQL "insert into teams(name) values('$winner')")
        if [[ $INSERT_WINNING_TEAM == "INSERT 0 1" ]]
        then
          echo $winner inserted successfully
        fi
    fi
  fi  
  #Check if opponent column is already in data and if not add 
  if [[ $opponent != "opponent" ]] 
  then
    OPPONENT_TEAM=$($PSQL "select name from teams where name='$opponent'")
    if [[ -z $OPPONENT_TEAM ]]
    then
      INSERT_OPPONENT_TEAM=$($PSQL "insert into teams(name) values('$opponent')")
      if [[ $INSERT_OPPONENT_TEAM == "INSERT 0 1" ]] 
      then
        echo $opponent inserted succesfully
      fi
    fi
  fi
  
  #Add game data into games table
  #Check and skip header row
  if [[ $year != "year" ]]
  then 
    #Get Winner ID
    WINNER_ID=$($PSQL "select team_id from teams where name='$winner'")
    #Get opponent ID
    OPPONENT_ID=$($PSQL "select team_id from teams where name='$opponent'") 
    #Insert into games table
    GAME=$($PSQL "insert into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values($year, '$round', $WINNER_ID, $OPPONENT_ID, $winner_goals, $opponent_goals)")
    #Echo Successfuly insert
    if [[ $GAME == "INSERT 0 1" ]]
    then
      echo Game inserted successfully
    fi
  fi
done