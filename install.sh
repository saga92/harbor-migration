#!/bin/bash
source ./migration.cfg
source ./alembic.tpl > ./alembic.ini
mysql -h${db_host} -u${db_username} -p${db_password} < ./alembic.sql
