"""0.1.0 to 0.1.1

Revision ID: f3629fe9f47f
Revises: 
Create Date: 2016-04-18 18:32:14.101897

"""

# revision identifiers, used by Alembic.
revision = 'f3629fe9f47f'
down_revision = None
branch_labels = None
depends_on = None

from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import mysql

from f3629fe9f47f_0_1_0_to_0_1_1_upgrade import upgrade
from f3629fe9f47f_0_1_0_to_0_1_1_downgrade import downgrade
