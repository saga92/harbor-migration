#!/bin/bash

source ./migration.cfg

WAITTIME=60

DBCNF="-hlocalhost -u${db_username} -p${db_password}"

if [[ $# > 0 ]]; then
    if [[ $1 = "help" || $1 = "h" ]]; then
        echo "run.sh up|upgrade"
        echo "down|downgrade"
        echo "h|help"
        exit 0
    fi

    nohup mysqld 2>&1 > ./nohup.log&
    for i in $(seq 1 $WAITTIME); do
        echo "$(/usr/sbin/service mysql status)"
        if [[ "$(/usr/sbin/service mysql status)" =~ "not running" ]]; then
            sleep 1
        else
            break
        fi
    done

    key="$1"
    case $key in
    up|upgrade)
        VERSION="$2"
        mysql $DBCNF < ./alembic.sql
        alembic -c ./alembic.ini upgrade ${VERSION}
        ;;
    down|downgrade)
        VERSION="$2"
        mysql $DBCNF < ./alembic.sql
        alembic -c ./alembic.ini downgrade ${VERSION}
        ;;
    backup)
        mysqldump $DBCNF --add-drop-database --databases registry > ./backup/registry.sql
        ;;
    restore)
        mysql $DBCNF < ./backup/registry.sql
        ;;
    *)
        echo "unknown option"
        exit
        ;;
    esac
fi
