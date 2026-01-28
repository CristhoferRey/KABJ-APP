"""initial schema

Revision ID: 0001
Revises: 
Create Date: 2024-01-01 00:00:00.000000

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql
from geoalchemy2 import Geometry


# revision identifiers, used by Alembic.
revision: str = "0001"
down_revision: Union[str, None] = None
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


user_role_enum = sa.Enum("ADMIN", "CAPATAZ", name="user_role")
form_type_enum = sa.Enum("PURGA", "VPA", "GENERIC", name="form_type")
execution_status_enum = sa.Enum(
    "PENDIENTE", "RESUELTO", "IMPOSIBILIDAD", "REPROGRAMACION", name="execution_status"
)


def upgrade() -> None:
    op.execute("CREATE EXTENSION IF NOT EXISTS postgis")

    user_role_enum.create(op.get_bind(), checkfirst=True)
    form_type_enum.create(op.get_bind(), checkfirst=True)
    execution_status_enum.create(op.get_bind(), checkfirst=True)

    op.create_table(
        "activities",
        sa.Column("id", sa.Integer(), primary_key=True),
        sa.Column("code", sa.String(), nullable=False),
        sa.Column("name", sa.String(), nullable=False),
    )
    op.create_index(op.f("ix_activities_code"), "activities", ["code"], unique=True)
    op.create_index(op.f("ix_activities_id"), "activities", ["id"], unique=False)

    op.create_table(
        "users",
        sa.Column("id", sa.Integer(), primary_key=True),
        sa.Column("name", sa.String(), nullable=False),
        sa.Column("email", sa.String(), nullable=False),
        sa.Column("password_hash", sa.String(), nullable=False),
        sa.Column("role", user_role_enum, nullable=False),
        sa.Column("is_active", sa.Boolean(), nullable=False, server_default=sa.true()),
    )
    op.create_index(op.f("ix_users_email"), "users", ["email"], unique=True)
    op.create_index(op.f("ix_users_id"), "users", ["id"], unique=False)

    op.create_table(
        "sectors",
        sa.Column("id", sa.Integer(), primary_key=True),
        sa.Column("name", sa.String(), nullable=False),
        sa.Column("district", sa.String(), nullable=False),
        sa.Column("locality", sa.String(), nullable=False),
    )
    op.create_index(op.f("ix_sectors_id"), "sectors", ["id"], unique=False)

    op.create_table(
        "subactivities",
        sa.Column("id", sa.Integer(), primary_key=True),
        sa.Column("activity_id", sa.Integer(), nullable=False),
        sa.Column("code", sa.String(), nullable=False),
        sa.Column("name", sa.String(), nullable=False),
        sa.Column("form_type", form_type_enum, nullable=False),
        sa.ForeignKeyConstraint(["activity_id"], ["activities.id"]),
    )
    op.create_index(op.f("ix_subactivities_activity_id"), "subactivities", ["activity_id"], unique=False)
    op.create_index(op.f("ix_subactivities_id"), "subactivities", ["id"], unique=False)

    op.create_table(
        "points",
        sa.Column("id", sa.Integer(), primary_key=True),
        sa.Column("subactivity_id", sa.Integer(), nullable=False),
        sa.Column("sector_id", sa.Integer(), nullable=False),
        sa.Column("sgio", sa.String(), nullable=True),
        sa.Column("gis", sa.String(), nullable=True),
        sa.Column("suministro", sa.String(), nullable=True),
        sa.Column("direccion", sa.String(), nullable=True),
        sa.Column("locality", sa.String(), nullable=True),
        sa.Column("district", sa.String(), nullable=True),
        sa.Column("geom", Geometry(geometry_type="POINT", srid=4326), nullable=False),
        sa.Column("is_active", sa.Boolean(), nullable=False, server_default=sa.true()),
        sa.ForeignKeyConstraint(["sector_id"], ["sectors.id"]),
        sa.ForeignKeyConstraint(["subactivity_id"], ["subactivities.id"]),
    )
    op.create_index(op.f("ix_points_id"), "points", ["id"], unique=False)
    op.create_index(op.f("ix_points_sector_id"), "points", ["sector_id"], unique=False)
    op.create_index(op.f("ix_points_subactivity_id"), "points", ["subactivity_id"], unique=False)

    op.create_table(
        "assignments",
        sa.Column("id", sa.Integer(), primary_key=True),
        sa.Column("subactivity_id", sa.Integer(), nullable=False),
        sa.Column("sector_id", sa.Integer(), nullable=False),
        sa.Column("capataz_id", sa.Integer(), nullable=False),
        sa.Column("date_from", sa.Date(), nullable=False),
        sa.Column("date_to", sa.Date(), nullable=False),
        sa.Column("is_active", sa.Boolean(), nullable=False, server_default=sa.true()),
        sa.ForeignKeyConstraint(["capataz_id"], ["users.id"]),
        sa.ForeignKeyConstraint(["sector_id"], ["sectors.id"]),
        sa.ForeignKeyConstraint(["subactivity_id"], ["subactivities.id"]),
    )
    op.create_index(op.f("ix_assignments_capataz_id"), "assignments", ["capataz_id"], unique=False)
    op.create_index(op.f("ix_assignments_id"), "assignments", ["id"], unique=False)
    op.create_index(op.f("ix_assignments_sector_id"), "assignments", ["sector_id"], unique=False)
    op.create_index(op.f("ix_assignments_subactivity_id"), "assignments", ["subactivity_id"], unique=False)

    op.create_table(
        "executions",
        sa.Column("id", sa.Integer(), primary_key=True),
        sa.Column("point_id", sa.Integer(), nullable=False),
        sa.Column("capataz_id", sa.Integer(), nullable=False),
        sa.Column("assignment_id", sa.Integer(), nullable=True),
        sa.Column("status", execution_status_enum, nullable=False),
        sa.Column("started_at", sa.DateTime(timezone=True), nullable=True),
        sa.Column("ended_at", sa.DateTime(timezone=True), nullable=True),
        sa.Column("duration_minutes", sa.Integer(), nullable=True),
        sa.Column("form_data", postgresql.JSONB(astext_type=sa.Text()), nullable=True),
        sa.Column("created_at", sa.DateTime(timezone=True), server_default=sa.text("now()"), nullable=False),
        sa.ForeignKeyConstraint(["assignment_id"], ["assignments.id"]),
        sa.ForeignKeyConstraint(["capataz_id"], ["users.id"]),
        sa.ForeignKeyConstraint(["point_id"], ["points.id"]),
    )
    op.create_index(op.f("ix_executions_assignment_id"), "executions", ["assignment_id"], unique=False)
    op.create_index(op.f("ix_executions_capataz_id"), "executions", ["capataz_id"], unique=False)
    op.create_index(op.f("ix_executions_id"), "executions", ["id"], unique=False)
    op.create_index(op.f("ix_executions_point_id"), "executions", ["point_id"], unique=False)

    op.create_table(
        "evidences",
        sa.Column("id", sa.Integer(), primary_key=True),
        sa.Column("execution_id", sa.Integer(), nullable=False),
        sa.Column("file_url", sa.String(), nullable=False),
        sa.Column("device_id", sa.String(), nullable=True),
        sa.Column("created_at", sa.DateTime(timezone=True), server_default=sa.text("now()"), nullable=False),
        sa.ForeignKeyConstraint(["execution_id"], ["executions.id"]),
    )
    op.create_index(op.f("ix_evidences_execution_id"), "evidences", ["execution_id"], unique=False)
    op.create_index(op.f("ix_evidences_id"), "evidences", ["id"], unique=False)


def downgrade() -> None:
    op.drop_index(op.f("ix_evidences_id"), table_name="evidences")
    op.drop_index(op.f("ix_evidences_execution_id"), table_name="evidences")
    op.drop_table("evidences")

    op.drop_index(op.f("ix_executions_point_id"), table_name="executions")
    op.drop_index(op.f("ix_executions_id"), table_name="executions")
    op.drop_index(op.f("ix_executions_capataz_id"), table_name="executions")
    op.drop_index(op.f("ix_executions_assignment_id"), table_name="executions")
    op.drop_table("executions")

    op.drop_index(op.f("ix_assignments_subactivity_id"), table_name="assignments")
    op.drop_index(op.f("ix_assignments_sector_id"), table_name="assignments")
    op.drop_index(op.f("ix_assignments_id"), table_name="assignments")
    op.drop_index(op.f("ix_assignments_capataz_id"), table_name="assignments")
    op.drop_table("assignments")

    op.drop_index(op.f("ix_points_subactivity_id"), table_name="points")
    op.drop_index(op.f("ix_points_sector_id"), table_name="points")
    op.drop_index(op.f("ix_points_id"), table_name="points")
    op.drop_table("points")

    op.drop_index(op.f("ix_subactivities_id"), table_name="subactivities")
    op.drop_index(op.f("ix_subactivities_activity_id"), table_name="subactivities")
    op.drop_table("subactivities")

    op.drop_index(op.f("ix_sectors_id"), table_name="sectors")
    op.drop_table("sectors")

    op.drop_index(op.f("ix_users_id"), table_name="users")
    op.drop_index(op.f("ix_users_email"), table_name="users")
    op.drop_table("users")

    op.drop_index(op.f("ix_activities_id"), table_name="activities")
    op.drop_index(op.f("ix_activities_code"), table_name="activities")
    op.drop_table("activities")

    execution_status_enum.drop(op.get_bind(), checkfirst=True)
    form_type_enum.drop(op.get_bind(), checkfirst=True)
    user_role_enum.drop(op.get_bind(), checkfirst=True)
