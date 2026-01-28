"""add execution close and device tracking

Revision ID: 0002
Revises: 0001
Create Date: 2024-01-02 00:00:00.000000

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = "0002"
down_revision: Union[str, None] = "0001"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.add_column("users", sa.Column("device_id", sa.String(), nullable=True))
    op.add_column(
        "executions",
        sa.Column("is_closed", sa.Boolean(), nullable=False, server_default=sa.false()),
    )
    op.alter_column("executions", "is_closed", server_default=None)


def downgrade() -> None:
    op.drop_column("executions", "is_closed")
    op.drop_column("users", "device_id")
