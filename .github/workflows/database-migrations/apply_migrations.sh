#!/bin/bash
# apply_migrations.sh (Flyway version)
set -o nounset
set -o errexit

if [ $# -lt 6 ]; then
  echo "Usage: $0 <db_host> <db_port> <db_name> <db_user> <ssm_path> <migration_type> [env]"
  exit 1
fi

DB_HOST=$1
DB_PORT=$2
DB_NAME=$3
DB_USER=$4
SSM_PASS_PATH=$5
MIGRATIONS_PATH=$6
MIGRATION_TYPE=$7
ENV="${8:-qa}"
DRYRUN="${9:-false}"

# Get password from SSM
DB_PASSWORD=$(aws ssm get-parameter \
  --with-decryption \
  --name "$SSM_PASS_PATH" \
  --query "Parameter.Value" \
  --output text)

if [ -z "$DB_PASSWORD" ]; then
  echo "ERROR: Failed to retrieve DB password"
  exit 1
fi

case "$MIGRATION_TYPE" in
  regular)
    MIGRATION_DIR="$MIGRATIONS_PATH/postgres"
    FLYWAY_TABLE="flyway_schema_history"
    VALIDATE_ON_MIGRATE=false
    BASELINE_ON_MIGRATE=false
    SQL_MIGRATION_PREFIX=false
    ;;
  repeatable)
    MIGRATION_DIR="$MIGRATIONS_PATH/postgres-repeatable"
    FLYWAY_TABLE="flyway_schema_history_repeatable"
    VALIDATE_ON_MIGRATE=false
    BASELINE_ON_MIGRATE=true
    SQL_MIGRATION_PREFIX=true
    ;;
  utility)
    MIGRATION_DIR="$MIGRATIONS_PATH/postgres-utility"
    FLYWAY_TABLE="flyway_schema_history_utility"
    VALIDATE_ON_MIGRATE=false
    BASELINE_ON_MIGRATE=true
    SQL_MIGRATION_PREFIX=true
    ;;
  baseline) 
    MIGRATION_DIR="$MIGRATIONS_PATH/postgres-baseline"
    FLYWAY_TABLE="flyway_schema_history_baseline"
    VALIDATE_ON_MIGRATE=false
    BASELINE_ON_MIGRATE=true
    SQL_MIGRATION_PREFIX=true
    ;;
  *)
    echo "ERROR: Unknown migration type: $MIGRATION_TYPE"
    exit 1
    ;;
esac


export FLYWAY_PLACEHOLDERS_ENV="${ENV}"


# Create flyway config
CMD=(
  flyway
  -url="jdbc:postgresql://${DB_HOST}:${DB_PORT}/${DB_NAME}"
  -user="${DB_USER}"
  -password="${DB_PASSWORD}"
  -locations="filesystem:${MIGRATION_DIR}"
  -table="${FLYWAY_TABLE}"
  -validateOnMigrate="${VALIDATE_ON_MIGRATE}"
  -validateMigrationNaming=true
)

if [ "$BASELINE_ON_MIGRATE" = "true" ]; then
  CMD+=("-baselineOnMigrate=true")
fi

if [ "$SQL_MIGRATION_PREFIX" = "false" ]; then
  CMD+=("-sqlMigrationPrefix=")
fi

if [ "$DRYRUN" = "true" ]; then
  CMD+=("-dryRunOutput=dryrun.sql")

CMD+=(migrate)


"${CMD[@]}"