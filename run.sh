#!/bin/bash
cd :proj_path:

source ./migration.cfg

if [ $# > 0 ]; then
    key="$1"
    case $key in
    up|upgrade)
        VERSION="$2"
        alembic -c :proj_path:/alembic.ini upgrade ${VERSION}
        ;;
    down|downgrade)
        VERSION="$2"
        alembic -c :proj_path:/alembic.ini downgrade ${VERSION}
        ;;
    init)
        mysql -h${db_host} -u${db_username} -p${db_password} < :proj_path:/alembic.sql
        ;;
    h|help)
        echo "run.sh up|upgrade"
        echo "down|downgrade"
        echo "init"
        echo "h|help"
        ;;
    *)
        echo "unknown option"
        exit
        ;;
    esac
fi
