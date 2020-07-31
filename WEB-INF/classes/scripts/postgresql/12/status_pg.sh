#!/bin/bash

CURR_DIR=$(readlink -f "$(dirname "$0")")

POSTGRES_HOME="$1"
DATA_HOME="$2"

LOG_PATH="$CURR_DIR/log"

# use getopt to parse parameter
TEMP=$(getopt -o D: -a -l pghome:,data: -- "$@")

if [ $? != 0 ]; then
  echo "args error....." >&2
  exit 1
fi

eval set -- "$TEMP"

# if use getopt , skip the old parameter
if [[ $1 != '--' ]]; then
  POSTGRES_HOME=""
  DATA_HOME=""
fi

while true; do
  case "$1" in
  --pghome | -pghome)
    POSTGRES_HOME=$2
    shift 2
    ;;
  -D | --data | -data)
    DATA_HOME=$2
    shift 2
    ;;
  --)
    shift
    break
    ;;
  *)
    echo "Internal error!"
    exit 1
    ;;
  esac

done

if [ -z "$POSTGRES_HOME" ]; then
  POSTGRES_HOME=$PG_HOME
fi
if [ ! -e "$POSTGRES_HOME/bin/pg_ctl" ]; then
  echo
  echo "Error: pg_ctl can't not found."
  echo
  exit 1
fi

if [ -z "$DATA_HOME" ]; then
  DATA_HOME=$PG_DATA
fi
if [ ! -e "$DATA_HOME" ]; then
  echo
  echo "Error: data path is  not exists."
  echo
  exit 1
fi

export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$POSTGRES_HOME/lib:$POSTGRES_HOME/lib/postgresql:$POSTGRES_HOME/plugin"
export PROJ_LIB="$POSTGRES_HOME/share/proj"
RUN_CMD="$POSTGRES_HOME/bin/pg_ctl -D $DATA_HOME status"
eval "$RUN_CMD"
