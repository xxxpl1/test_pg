#!/bin/bash

CURR_DIR=$(readlink -f "$(dirname "$0")")

MASTER_HOST="$1"
MASTER_PORT="$2"
REPL_PASSWORD="$3"
POSTGRES_HOME="$4"
DATA_HOME="$5"
SLAVE_HOST="$6"
SLAVE_PORT="$7"

LOG_PATH="$CURR_DIR/log"
REPL_USER="repl"

TO_LOG=">> $LOG_PATH  2>&1"
#TO_LOG=""

# use getopt to parse parameter
TEMP=$(getopt -o h:p:r:D:v -a -l host:,port:,repluser:,replpassword:,pghome:,data:,shost:,sport:,verbose -- "$@")

if [ $? != 0 ]; then
  echo "args error....." >&2
  exit 1
fi

eval set -- "$TEMP"

# if use getopt , skip the old parameter
if [[ $1 != '--' ]]; then
  MASTER_HOST=""
  MASTER_PORT=""
  REPL_PASSWORD=""
  POSTGRES_HOME=""
  DATA_HOME=""
  SLAVE_HOST=""
  SLAVE_PORT=""
fi

while true; do
  case "$1" in
  -h | --host | -host)
    MASTER_HOST=$2
    shift 2
    ;;
  -p | --port | -port)
    MASTER_PORT=$2
    shift 2
    ;;
  --repluser | -repluser)
    REPL_USER=$2
    shift 2
    ;;
  -r | --replpassword | -replpassword)
    REPL_PASSWORD=$2
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
  --shost | -shost)
    SLAVE_HOST=$2
    shift 2
    ;;
  --sport | -sport)
    SLAVE_PORT=$2
    shift 2
    ;;
  -v | --verbose | -verbose)
    TO_LOG=""
    shift 1
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

if [ -z "$MASTER_HOST" ]; then
  echo
  echo "Error: host can't be empty."
  echo
  exit 1
fi

if [ -z "$MASTER_PORT" ]; then
  echo
  echo "Error: port can't be empty."
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

if [ -z "$SLAVE_HOST" ]; then
  SLAVE_HOST=$PG_SLAVE_HOST
fi
if [ -z "$SLAVE_HOST" ]; then
  echo
  echo "Error: slave host must not be empty."
  echo
  exit 1
fi

if [ -z "$SLAVE_PORT" ]; then
  SLAVE_PORT=$PG_SLAVE_PORT
fi
if [ -z "$SLAVE_PORT" ]; then
  echo
  echo "Error: slave port must not be empty."
  echo
  exit 1
fi

export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$POSTGRES_HOME/lib:$POSTGRES_HOME/lib/postgresql:$POSTGRES_HOME/plugin"
export PROJ_LIB="$POSTGRES_HOME/share/proj"
export PGPASSWORD="$REPL_PASSWORD"
RUN_CMD="$POSTGRES_HOME/bin/pg_basebackup -D $DATA_HOME -Fp -Xs -v -P -h $MASTER_HOST -p $MASTER_PORT -U $REPL_USER -w  $TO_LOG"
date >>"$LOG_PATH"
echo "cmd:$RUN_CMD" >>"$LOG_PATH"
eval "$RUN_CMD"
export PGPASSWORD=

PG_PASS_FILE="$DATA_HOME/.pgpass"
echo "$MASTER_HOST:$MASTER_PORT:replication:$REPL_USER:$REPL_PASSWORD" > "$PG_PASS_FILE"
chmod 0600 "$PG_PASS_FILE"

# change '/' to  '\/'  , otherwise sed will fail
PG_PASS_FILE=$(echo "$PG_PASS_FILE" | sed -s 's/\//\\\//g')
APPLIACTION_NAME=$SLAVE_HOST"_"$SLAVE_PORT
PRIMARY_CONNIFO="'host=$MASTER_HOST port=$MASTER_PORT user=$REPL_USER passfile=$PG_PASS_FILE application_name=$APPLIACTION_NAME'"

sed -i -s "s/.*primary_conninfo = .*/primary_conninfo = $PRIMARY_CONNIFO/g" "$DATA_HOME/postgresql.conf"
touch "$DATA_HOME/standby.signal"
