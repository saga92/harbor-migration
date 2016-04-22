#! /bin/bash

while [[ $# > 0 ]]
do
    key="$1"
    case $key in
    -up|--upgrade)
        VERSION="$2"
        alembic upgrade ${VERSION}
        shift
        ;;
    -down|--downgrade)
        VERSION="$2"
        alembic downgrade ${VERSION}
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
