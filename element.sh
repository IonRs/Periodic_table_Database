#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ $1 -ge 1 && $1 -le 10 ]]
then
  ATOMIC_NUMBER=$1
  ELEMENT_NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$1;")
  ELEMENT_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$1;")
  SYMBOL_ARRAY=$($PSQL "SELECT symbol FROM elements;")
else
  SYMBOL_ARRAY=$($PSQL "SELECT symbol FROM elements;")
  NAME_ARRAY=$($PSQL "SELECT name FROM elements;")
  for item in $SYMBOL_ARRAY
  do
    if [ "$item" == "$1" ]
    then
      ELEMENT_SYMBOL=$1
      ELEMENT_NAME=$($PSQL "SELECT name FROM elements WHERE symbol='$1';")
      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1';")
      break
    fi
  done
  for item in $NAME_ARRAY
  do
    if [ "$item" == "$1" ]
    then
      ELEMENT_NAME=$1
      ELEMENT_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE name='$1';")
      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name='$1';")
    fi
  done
fi
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
elif [[ -z "$ATOMIC_NUMBER" ]]
then
  echo "I could not find that element in the database."
else
  TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number=$ATOMIC_NUMBER;")
  TYPE=$($PSQL "SELECT type FROM types WHERE type_id=$TYPE_ID;")
  ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUMBER;")
  MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER;")
  BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER;")
  echo "The element with atomic number $ATOMIC_NUMBER is $ELEMENT_NAME ($ELEMENT_SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $ELEMENT_NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
fi