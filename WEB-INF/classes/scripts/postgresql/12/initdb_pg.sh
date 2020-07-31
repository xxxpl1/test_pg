#!/bin/bash

CURR_DIR=$(readlink -f "$(dirname "$0")")

POSTGRES_HOME="$1"
DATA_HOME="$2"
SUPER_USER="$3"

LOG_PATH="$CURR_DIR/log"

# use getopt to parse parameter
TEMP=$(getopt -o u:D: -a -l user:,pghome:,data: -- "$@")

if [ $? != 0 ]; then
  echo "args error....." >&2
  exit 1
fi

eval set -- "$TEMP"

# if use getopt , skip the old parameter
if [[ $1 != '--' ]]; then
  POSTGRES_HOME=""
  DATA_HOME=""
  SUPER_USER=""
fi

while true; do
  case "$1" in
  -u | --user | -user)
    SUPER_USER=$2
    shift 2
    ;;
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
if [ -e "$DATA_HOME" ]; then
  if [ "$(ls -A "$DATA_HOME")" != "" ]; then
    echo
    echo "Error: data path must be empty."
    echo
    exit 1
  fi
fi

if [ -z "$SUPER_USER" ]; then
  SUPER_USER=$PG_USER
fi
if [ -z "$SUPER_USER" ]; then
  SUPER_USER=postgres
fi

export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$POSTGRES_HOME/lib:$POSTGRES_HOME/lib/postgresql:$POSTGRES_HOME/plugin"
export PROJ_LIB="$POSTGRES_HOME/share/proj"
RUN_CMD="$POSTGRES_HOME/bin/initdb -U $SUPER_USER -E UTF8 -D $DATA_HOME --auth-host=scram-sha-256	--auth-local=trust"
eval "$RUN_CMD"
