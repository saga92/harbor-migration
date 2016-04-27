"""0.1.0 to 0.1.1

Revision ID: 0.1.1
Revises: 
Create Date: 2016-04-18 18:32:14.101897

"""

# revision identifiers, used by Alembic.
revision = '0.1.1'
down_revision = None
branch_labels = None
depends_on = None

from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import mysql
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, relationship
from datetime import datetime

Session = sessionmaker()

Base = declarative_base()

class Properties(Base):
    __tablename__ = 'properties'

    k = sa.Column(sa.String(64), primary_key = True)
    v = sa.Column(sa.String(128), nullable = False)

class ProjectMember(Base):
    __tablename__ = 'project_member'

    project_id = sa.Column(sa.Integer(), primary_key = True)
    user_id = sa.Column(sa.Integer(), primary_key = True)
    role = sa.Column(sa.Integer(), nullable = False)
    creation_time = sa.Column(sa.DateTime(), nullable = True)
    update_time = sa.Column(sa.DateTime(), nullable = True)
    sa.ForeignKeyConstraint(['project_id'], [u'project.project_id'], ),
    sa.ForeignKeyConstraint(['role'], [u'role.role_id'], ),
    sa.ForeignKeyConstraint(['user_id'], [u'user.user_id'], ),

class UserProjectRole(Base):
    __tablename__ = 'user_project_role'

    upr_id = sa.Column(sa.Integer(), primary_key = True)
    user_id = sa.Column(sa.Integer(), sa.ForeignKey('user.user_id'))
    pr_id = sa.Column(sa.Integer(), sa.ForeignKey('project_role.pr_id'))
    project_role = relationship("ProjectRole")

class ProjectRole(Base):
    __tablename__ = 'project_role'

    pr_id = sa.Column(sa.Integer(), primary_key = True)
    project_id = sa.Column(sa.Integer(), nullable = False)
    role_id = sa.Column(sa.Integer(), nullable = False)
    sa.ForeignKeyConstraint(['role_id'], [u'role.role_id'])
    sa.ForeignKeyConstraint(['project_id'], [u'project.project_id'])

class Access(Base):
    __tablename__ = 'access'

    access_id = sa.Column(sa.Integer(), primary_key = True)
    access_code = sa.Column(sa.String(1))
    comment = sa.Column(sa.String(30))

def upgrade():
    bind = op.get_bind()
    session = Session(bind=bind)

    #delete M from table access
    acc = session.query(Access).filter_by(access_id=1).first()
    session.delete(acc)

    #create table property
    Properties.__table__.create(bind)
    session.add(Properties(k='schema_version', v='0.1.1'))

    #create table project_member
    ProjectMember.__table__.create(bind)

    #fill data
    join_result = session.query(UserProjectRole).join(UserProjectRole.project_role).all()
    for result in join_result:
        session.add(ProjectMember(project_id=result.project_role.project_id, \
            user_id=result.user_id, role=result.project_role.role_id, \
            creation_time=datetime.now(), update_time=datetime.now()))

    #op.drop_table('project_role')
    #op.drop_table('user_project_role')

    #add column to table project
    op.add_column('project', sa.Column('update_time', sa.DateTime(), nullable=True))

    #add column to table role
    op.add_column('role', sa.Column('role_mask', sa.Integer(), server_default=sa.text(u"'0'"), nullable=False))

    #add column to table user
    op.add_column('user', sa.Column('creation_time', sa.DateTime(), nullable=True))
    op.add_column('user', sa.Column('sysadmin_flag', sa.Integer(), nullable=True))
    op.add_column('user', sa.Column('update_time', sa.DateTime(), nullable=True))
    session.commit()

def downgrade():
    bind = op.get_bind()
    session = Session(bind=bind)

    #add M to table access
    session.add(Access(access_id=1, access_code='A', comment='All access for the system'))

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
