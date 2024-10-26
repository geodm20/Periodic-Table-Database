#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only --no-align -c"

# Check for arguments on execution. If not present:
if [[ -z $1 ]]
then
  echo Please provide an element as an argument.
  exit
fi

# If argument is present and it's a number:
if [[ $1 =~ ^[0-9]+$ ]]
then
  element=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE atomic_number = '$1'")
else
# If it's a string:
  element=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties using(atomic_number) JOIN types USING(type_id) WHERE name = '$1' OR symbol = '$1'")
fi

# Check if argument is not on DB:
if [[ -z $element ]]
then
  echo -e "I could not find that element in the database."
else
  # Give the message:
  echo $element | while IFS=" |" read A_NUMBER NAME SYMBOL TYPE A_MASS MELTING_P BOILING_P 
  do
    echo -e "The element with atomic number $A_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $A_MASS amu. $NAME has a melting point of $MELTING_P celsius and a boiling point of $BOILING_P celsius."
  done
fi

