#!/bin/bash
set -o errexit
set -o nounset

migrations_prepare() {
  DB_HOST=$1
  DB_PORT=$2
  DB_NAME=$3
  DB_USER=$4
  SSM_PASS_PATH=$5
  FLYWAY_SCHEMA_VERSIONED=$6
  FLYWAY_SCHEMA_REPEATABLE=$7
  FLYWAY_SCHEMA_UTILITY=$8
  ENV="${10:-qa}"

  bash .github/scripts/database-migrations/apply_migrations.sh \
    "$DB_HOST" "$DB_PORT" "$DB_NAME" "$DB_USER" "$SSM_PASS_PATH" "$FLYWAY_SCHEMA_VERSIONED" regular "$ENV"

  bash .github/scripts/database-migrations/apply_migrations.sh \
    "$DB_HOST" "$DB_PORT" "$DB_NAME" "$DB_USER" "$SSM_PASS_PATH" "$FLYWAY_SCHEMA_REPEATABLE" repeatable "$ENV"

  bash .github/scripts/database-migrations/apply_migrations.sh \
    "$DB_HOST" "$DB_PORT" "$DB_NAME" "$DB_USER" "$SSM_PASS_PATH" "$FLYWAY_SCHEMA_UTILITY" utility "$ENV"
}
