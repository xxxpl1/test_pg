#!/bin/bash

CURR_DIR=$(readlink -f "$(dirname "$0")")

USER="$1"
NEW_PASSWORD="$2"
POSTGRES_HOME="$3"
PORT="$4"
SUPER_USER="$5"

# use getopt to parse parameter
TEMP=$(getopt -o u:P:p: -a -l user:,pghome:,password:,port:,superuser: -- "$@")

if [ $? != 0 ]; then
  echo "args error....." >&2
  exit 1
fi

eval set -- "$TEMP"

# if use getopt , skip the old parameter
if [[ $1 != '--' ]]; then
  USER=""
  NEW_PASSWORD=""
  POSTGRES_HOME=""
  PORT=""
  SUPER_USER=""
fi

while true; do
  case "$1" in
  -u | --user | -user)
    USER=$2
    shift 2
    ;;
  -P | --password | -password)
    NEW_PASSWORD=$2
    shift 2
    ;;
  --pghome | -pghome)
    POSTGRES_HOME=$2
    shift 2
    ;;
  -p | --port | -port)
    PORT=$2
    shift 2
    ;;
  --superuser | -superuser)
    SUPER_USER=$2
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

if [ -z "$USER" ]; then
  echo
  echo "Error: user can't be empty."
  echo
  exit 1
fi

if [ -z "$NEW_PASSWORD" ]; then
  echo
  echo "Error: password can't be empty."
  echo
  exit 1
fi

if [ -z "$POSTGRES_HOME" ]; then
  POSTGRES_HOME=$PG_HOME
fi
if [ ! -e "$POSTGRES_HOME/bin/pg_ctl" ]; then
  echo
  echo "Error: pg_ctl can't not found."
  echo
  exit 1
fi

if [ -z "$PORT" ]; then
  PORT=$PG_PORT
fi
if [ -z "$PORT" ]; then
  echo
  echo "Error: port can't be empty."
  echo
  exit 1
fi

if [ -z "$SUPER_USER" ]; then
  SUPER_USER=$PG_USER
fi

export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$POSTGRES_HOME/lib:$POSTGRES_HOME/lib/postgresql:$POSTGRES_HOME/plugin"
export PROJ_LIB="$POSTGRES_HOME/share/proj"
RUN_CMD="$POSTGRES_HOME/bin/psql -p $PORT -U $SUPER_USER -w -c \"ALTER USER $USER PASSWORD '$NEW_PASSWORD'\" postgres "
eval "$RUN_CMD"
