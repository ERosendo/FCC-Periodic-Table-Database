#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ $1 ]]
then
  if [[ ! $1 =~ ^[0-9]+$ ]]
  
  then
    ATOMIC_NUMBER=$($PSQL "select atomic_number from elements where symbol='$1' or name='$1'")
  else
    ATOMIC_NUMBER=$($PSQL "select atomic_number from elements where atomic_number=$1")
  fi

  if [[ -z $ATOMIC_NUMBER ]]
  then
    echo "I could not find that element in the database."
  else
    ELEMENT=$($PSQL "select elements.atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, types.type  from properties inner join elements on properties.atomic_number=elements.atomic_number full join types on properties.type_id=types.type_id where elements.atomic_number=$ATOMIC_NUMBER")
    IFS='|'
    read ATOMIC_NUMBER_DB SYMBOL NAME ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS TYPE <<< $ELEMENT
    
    ATOMIC_NUMBER_DB_FORMATTED=$(echo $ATOMIC_NUMBER_DB | sed -E 's/ *//g')
    NAME_FORMATTED=$(echo $NAME | sed -E 's/ *//g')
    SYMBOL_FORMATTED=$(echo $SYMBOL | sed -E 's/ *//g')
    TYPE_FORMATTED=$(echo $TYPE | sed -E 's/ *//g')
    ATOMIC_MASS_FORMATTED=$(echo $ATOMIC_MASS | sed -E 's/ *//g')
    MELTING_POINT_CELSIUS_FORMATTED=$(echo $MELTING_POINT_CELSIUS | sed -E 's/ *//g')
    BOILING_POINT_CELSIUS_FORMATTED=$(echo $BOILING_POINT_CELSIUS | sed -E 's/ *//g')

    echo "The element with atomic number $ATOMIC_NUMBER_DB_FORMATTED is $NAME_FORMATTED ($SYMBOL_FORMATTED). It's a $TYPE_FORMATTED, with a mass of $ATOMIC_MASS_FORMATTED amu. $NAME_FORMATTED has a melting point of $MELTING_POINT_CELSIUS_FORMATTED celsius and a boiling point of $BOILING_POINT_CELSIUS_FORMATTED celsius."
  fi
else
  echo -e "Please provide an element as an argument."
fi


