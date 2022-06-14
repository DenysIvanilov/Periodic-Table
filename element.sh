#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

if [[ $1 ]]
then
  if [[ "$1" =~ ^[0-9]+$ ]]
  then
    GET_NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$1")
    if [[ -z $GET_NAME ]]
    then
      echo "I could not find that element in the database."
    else
      GET_SYM=$($PSQL "SELECT symbol FROM elements WHERE name='$GET_NAME'")
      GET_TYPE=$($PSQL "SELECT type FROM properties INNER JOIN types USING(type_id) WHERE atomic_number=$1")
      GET_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$1")
      GET_MPS=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$1")
      GET_BPS=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$1")
      echo "The element with atomic number $1 is $GET_NAME ($GET_SYM). It's a $GET_TYPE, with a mass of $GET_MASS amu. $GET_NAME has a melting point of $GET_MPS celsius and a boiling point of $GET_BPS celsius."
    fi
  else
    GET_NAME=$($PSQL "SELECT name FROM elements WHERE name='$1' OR symbol='$1'")
    if [[ -z $GET_NAME ]]
    then
      echo "I could not find that element in the database."
    else
      GET_SYM=$($PSQL "SELECT symbol FROM elements WHERE name='$GET_NAME'")
      GET_NUM=$($PSQL "SELECT atomic_number FROM elements WHERE name='$GET_NAME'")
      GET_TYPE=$($PSQL "SELECT type FROM properties INNER JOIN types USING(type_id) WHERE atomic_number=$GET_NUM")
      GET_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$GET_NUM")
      GET_MPS=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$GET_NUM")
      GET_BPS=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$GET_NUM")
      echo "The element with atomic number $GET_NUM is $GET_NAME ($GET_SYM). It's a $GET_TYPE, with a mass of $GET_MASS amu. $GET_NAME has a melting point of $GET_MPS celsius and a boiling point of $GET_BPS celsius."
    fi
  fi
else
  echo "Please provide an element as an argument."
fi