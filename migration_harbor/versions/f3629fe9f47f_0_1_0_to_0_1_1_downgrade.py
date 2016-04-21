#!/usr/bin/env python
# -*- coding: utf-8 -*-

from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import mysql
from sqlalchemy.orm import sessionmaker

revision = 'f3629fe9f47f'
down_revision = None
branch_labels = None
depends_on = None

Session = sessionmaker()

def downgrade():
    bind = op.get_bind()
    session = Session(bind=bind)
    #drop column from table user
    op.drop_column('user', 'update_time')
    op.drop_column('user', 'sysadmin_flag')
    op.drop_column('user', 'creation_time')

    #drop column from role
    op.drop_column('role', 'role_mask')

    #drop column from project
    op.drop_column('project', 'update_time')

    #drop table project_member
    op.drop_table('project_member')

    #drop table properties
    op.drop_table('properties')
    session.commit()
