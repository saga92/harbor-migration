#!/bin/bash

source ./migration.cfg

WAITTIME=60


DBCNF="-hlocalhost -u${db_username} -p${db_password}"

if [[ $# > 0 ]]; then
    if [[ $1 = "help" || $1 = "h" ]]; then
        echo "Usage:"
        echo "backup                perform database backup"
        echo "restore               perform database restore"
        echo "up,   upgrade         perform database schema upgrade"
        echo "down, downgrade       perform database schema downgrade"
        echo "h,    help            usage help"
        exit 0
    fi

    echo 'Trying to start mysql server...'
    DBRUN=0
    nohup mysqld 2>&1 > ./nohup.log&
    for i in $(seq 1 $WAITTIME); do
        echo "$(/usr/sbin/service mysql status)"
        if [[ "$(/usr/sbin/service mysql status)" =~ "not running" ]]; then
            sleep 1
        else
            DBRUN=1
            break
        fi
    done

    if [[ $DBRUN -eq 0 ]]; then
        echo "timeout. Can't run mysql server."
        exit 1
    fi

    key="$1"
    case $key in
    up|upgrade)
        echo "Performing upgrade ${VERSION}..."
        VERSION="$2"
        mysql $DBCNF < ./alembic.sql
        alembic -c ./alembic.ini upgrade ${VERSION}
        echo "Upgrade performed."
        ;;
    down|downgrade)
        echo "Performing downgrade ${VERSION}..."
        VERSION="$2"
        mysql $DBCNF < ./alembic.sql
        alembic -c ./alembic.ini downgrade ${VERSION}
        echo "Downgrade performed."
        ;;
    backup)
        echo "Performing backup..."
        mysqldump $DBCNF --add-drop-database --databases registry > ./backup/registry.sql
        echo "Backup performed."
        ;;
    restore)
        echo "Performing restore..."
        mysql $DBCNF < ./backup/registry.sql
        echo "Restore performed."
        ;;
    *)
        echo "unknown option"
        exit 0
        ;;
    esac
fi
