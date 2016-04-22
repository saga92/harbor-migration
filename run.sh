#! /bin/bash

source ./migration.cfg
mysql -h${db_host} -u${db_username} -p${db_password} < ./alembic.sql

while [[ $# > 0 ]]
do
    key="$1"
    case $key in
    -up|--upgrade)
        VERSION="$2"
        alembic -c ./alembic.ini upgrade ${VERSION}
        shift
        ;;
    -down|--downgrade)
        VERSION="$2"
        alembic -c ./alembic.ini downgrade ${VERSION}
        shift
        ;;
    -h|--help)
        echo "run.sh -up|--upgrade"
        echo "-down|--downgrade"
        echo "-h|--help"
        ;;
    *)
        echo "unknown option"
        ;;
esac
shift
done
