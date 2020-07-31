#!/bin/bash

CURR_DIR=$(readlink -f "$(dirname "$0")")

MASTER_HOST="$1"
MASTER_PORT="$2"
REWIND_USER="$3"
REWIND_PASSWORD="$4"
REPL_PASSWORD="$5"
POSTGRES_HOME="$6"
DATA_HOME="$7"
SLAVE_HOST="$8"
SLAVE_PORT="$9"

LOG_PATH="$CURR_DIR/log"
REPL_USER="repl"

TO_LOG=">> $LOG_PATH  2>&1"
#TO_LOG=""
BACKUP_FLAG=false

# use getopt to parse parameter
TEMP=$(getopt -o h:p:u:P:r:D:v -a -l host:,port:,user:,password:,repluser:,replpassword:,pghome:,data:,shost:,sport:,verbose -- "$@")

if [ $? != 0 ]; then
  echo "args error....." >&2
  exit 1
fi

eval set -- "$TEMP"

# if use getopt , skip the old parameter
if [[ $1 != '--' ]]; then
  MASTER_HOST=""
  MASTER_PORT=""
  REWIND_USER=""
  REWIND_PASSWORD=""
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
  -u | --user | -user)
    REWIND_USER=$2
    shift 2
    ;;
  -P | --password | -password)
    REWIND_PASSWORD=$2
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

if [ -z "$REPL_PASSWORD" ]; then
  if [ "$REWIND_USER" ] && [ "$REWIND_PASSWORD" ]; then
    REPL_USER="$REWIND_USER"
    REPL_PASSWORD="$REWIND_PASSWORD"
  fi
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

stop_pg() {
  STOP_CMD="$POSTGRES_HOME/bin/pg_ctl -D $DATA_HOME -t 600 stop  $TO_LOG"
  echo "cmd:$STOP_CMD" >>"$LOG_PATH"
  eval "$STOP_CMD"
}

backup_data_dir() {
  if [ -e "$DATA_HOME" ]; then
    if [ "$BACKUP_FLAG" == true ]; then
      TIME=$(date "+%Y%m%d%H%M%S")
      NEW_DIR="$DATA_HOME/../backups"
      MV_CMD="mkdir -p $NEW_DIR && mv $DATA_HOME $NEW_DIR/$TIME"
      echo "cmd:$MV_CMD" >>"$LOG_PATH"
      eval "$MV_CMD"
    else
      RM_CMD="rm -rf $DATA_HOME"
      echo "cmd:$RM_CMD" >>"$LOG_PATH"
      eval "$RM_CMD"
    fi
  fi
}

exec_check_primary() {
  export PGPASSWORD="$REWIND_PASSWORD"
  SQL='select 1;'
  CMD="$POSTGRES_HOME/bin/psql -t -h $MASTER_HOST -p $MASTER_PORT -U$REWIND_USER postgres -c '$SQL'"
  echo "cmd:$CMD" >>"$LOG_PATH"
  eval "$CMD"
  if [ $? -ne 0 ]; then
    echo "primary node can't connect." "$TO_LOG"
    exit 1
  fi
  export PGPASSWORD=
}

basebackup_restore_pg() {
  export PGPASSWORD="$REPL_PASSWORD"
  BACKUP_CMD="$POSTGRES_HOME/bin/pg_basebackup -D $DATA_HOME --checkpoint=fast -Fp -Xs -v -P -h $MASTER_HOST -p $MASTER_PORT -U $REPL_USER -w  $TO_LOG"
  date >>"$LOG_PATH"
  echo "cmd:$BACKUP_CMD" >>"$LOG_PATH"
  eval "$BACKUP_CMD"
  if [ $? -ne 0 ]; then
    echo "pg_basebackup fail."
    exit 1
  fi
  export PGPASSWORD=
}

backup_table_space() {
  table_space_path=$1
  if [ -e "$table_space_path" ]; then
    if [ "$BACKUP_FLAG" == true ]; then
      NEW_DIR="$table_space_path/../backups"
      MKDIR="mkdir -p $NEW_DIR"
      eval "$MKDIR"
      NAME=${table_space_path##*/}
      TIME=$(date "+%Y%m%d%H%M%S")
      NEW_DIR="$table_space_path/../backups"
      MV_CMD="mv $table_space_path $NEW_DIR/$NAME\_$TIME"
      echo "cmd:$MV_CMD" >>"$LOG_PATH"
      eval "$MV_CMD"
    else
      RM_CMD="rm -rf $table_space_path"
      echo "cmd:$RM_CMD" >>"$LOG_PATH"
      eval "$RM_CMD"
    fi
  fi
}

table_space_check() {
  export PGPASSWORD="$REWIND_PASSWORD"
  SQL='SELECT pg_catalog.pg_tablespace_location(oid) AS "Location" FROM pg_catalog.pg_tablespace;'
  CMD="$POSTGRES_HOME/bin/psql -t -h $MASTER_HOST -p $MASTER_PORT -U$REWIND_USER postgres -c '$SQL'"

  OUTPUT=$(eval "$CMD")

  array=(${OUTPUT//\n/ })
  for line in ${array[@]}; do
    backup_table_space "$line"
  done
  export PGPASSWORD=
}

update_primary_conninfo() {
  PG_PASS_FILE="$DATA_HOME/.pgpass"
  echo "$MASTER_HOST:$MASTER_PORT:replication:$REPL_USER:$REPL_PASSWORD" >"$PG_PASS_FILE"
  chmod 0600 "$PG_PASS_FILE"
  APPLIACTION_NAME=$SLAVE_HOST"_"$SLAVE_PORT
  CONF_CMD="cat > $DATA_HOME/recovery.conf << EOT
recovery_target_timeline = 'latest'
standby_mode = on
primary_conninfo = 'host=$MASTER_HOST port=$MASTER_PORT user=$REPL_USER passfile=$PG_PASS_FILE application_name=$APPLIACTION_NAME'
EOT"
  echo "cmd:$CONF_CMD" >>"$LOG_PATH"
  eval "$CONF_CMD"
}

start_pg() {
  START_CMD="$POSTGRES_HOME/bin/pg_ctl -D $DATA_HOME -l $DATA_HOME/console.log start $TO_LOG"
  echo "cmd:$START_CMD" >>"$LOG_PATH"
  eval "$START_CMD"
}

export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$POSTGRES_HOME/lib:$POSTGRES_HOME/lib/postgresql:$POSTGRES_HOME/plugin"
export PROJ_LIB="$POSTGRES_HOME/share/proj"

date >>"$LOG_PATH"
if [ -e "$DATA_HOME" ]; then
  stop_pg
  export PGPASSWORD="$REWIND_PASSWORD"
  REWIND_CMD="$POSTGRES_HOME/bin/pg_rewind -D $DATA_HOME --source-server='host=$MASTER_HOST port=$MASTER_PORT user=$REWIND_USER dbname=postgres' -P  $TO_LOG"
  echo "cmd:$REWIND_CMD" >>"$LOG_PATH"
  eval "$REWIND_CMD"
  if [ $? -ne 0 ]; then
    exec_check_primary
    backup_data_dir
    table_space_check
    basebackup_restore_pg
  fi
  export PGPASSWORD=
else
  exec_check_primary
  backup_data_dir
  table_space_check
  basebackup_restore_pg
fi

update_primary_conninfo
start_pg
