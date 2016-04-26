#!/bin/bash
source ./migration.cfg
source ./alembic.tpl > ./alembic.ini
echo $proj_path|sed "s/\//\\\\\\\\\//g"|xargs -i sed -i "s/:proj_path:/{}/g" ./run.sh
