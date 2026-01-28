#!/bin/bash
set -o nounset
set -o errexit

if [ $# -lt 3 ]; then
  echo "Usage: $0 <config_file> <env>"
  exit 1
fi

# Prepare test database data directory
# Usage: ./prepare_pgdata.sh [config_file] qa

CONFIG_FILE=$1
ENV=$2
MIGRATIONS_BASE_PATH=$3

DB_NAME=$(yq ".database.name" "$CONFIG_FILE")

# Source postgres image
POSTGRES_VERSION=$(yq '.migrator.postgres_version' "$CONFIG_FILE")
POSTGRES_IMAGE="postgres:${POSTGRES_VERSION}-alpine"


# Get user data
DB_USER=$(yq ".environments.$ENV.database.user" "$CONFIG_FILE")
SSM_PASS_PATH=$(yq ".environments.$ENV.database.ssm_password_path" "$CONFIG_FILE")

if [ -z "$SSM_PASS_PATH" ] || [ "$SSM_PASS_PATH" = "null" ]; then
  echo "ERROR: environments.${ENV}.database.ssm_password_path is required"
  exit 1
fi


# Setup local user/password
# Get init password from SSM
INIT_PWD=$(aws ssm get-parameter \
  --name "$SSM_PASS_PATH" \
  --with-decryption \
  --query "Parameter.Value" \
  --output text)

if [ -z "$INIT_PWD" ]; then
  echo "ERROR: Failed to retrieve password"
  exit 1
fi

# Temporaty DB folder
TMP_CONTAINER_NAME=$DB_NAME-db-migrations-temp
TMP_PGDATA_FOLDER=pgdata


# Cleanup old data
docker rm -f "$TMP_CONTAINER_NAME" 2>/dev/null || true
rm -rf "${TMP_PGDATA_FOLDER:?}"/*
mkdir -p "${TMP_PGDATA_FOLDER}"


MIGRATIONS_PATH="${MIGRATIONS_BASE_PATH%/}"
MIGRATIONS_PATH="$(pwd)/$MIGRATIONS_PATH/migrations"
chmod -v o+rx "$MIGRATIONS_PATH/init_db"
chmod -v o+r "$MIGRATIONS_PATH/init_db"/*


# Start temporary container
echo "::group::Starting temporary container"
docker run \
  --name "${TMP_CONTAINER_NAME}" \
  -v "$(pwd)/${TMP_PGDATA_FOLDER}:/var/lib/postgresql/data" \
  -v "$MIGRATIONS_PATH/init_db/:/docker-entrypoint-initdb.d/" \
  -e INIT_PWD="$INIT_PWD" \
  -e INIT_USER="$DB_USER" \
  -e DB_NAME="$DB_NAME" \
  -e POSTGRES_PASSWORD=postgres \
  -p 5442:5432 \
  -d \
  ${POSTGRES_IMAGE}

# Wait for posrtgres
echo "Waiting for Postgres to be ready..."
    while [ $(docker top ${TMP_CONTAINER_NAME} | grep -q docker-entrypoint; echo $?) -eq 0 ]; do
        echo waiting for postgres startup and db import...
        # docker exec --tty ${TMP_CONTAINER_NAME} ls -la /docker-entrypoint-initdb.d/
        sleep 6
    done
echo "::endgroup::"

echo "::group::Postgres container logs"
docker logs ${TMP_CONTAINER_NAME}
echo "::endgroup::"

echo "::group::Applying migrations to test database"
DB_HOST="localhost"
DB_PORT="5442"

# Baseline migrations
bash .github/scripts/database-migrations/apply_migrations.sh $DB_HOST $DB_PORT $DB_NAME $DB_USER $SSM_PASS_PATH $MIGRATIONS_PATH baseline

# Regular migrations
bash .github/scripts/database-migrations/apply_migrations.sh $DB_HOST $DB_PORT $DB_NAME $DB_USER $SSM_PASS_PATH $MIGRATIONS_PATH regular

# Repeatable migrations
bash .github/scripts/database-migrations/apply_migrations.sh $DB_HOST $DB_PORT $DB_NAME $DB_USER $SSM_PASS_PATH $MIGRATIONS_PATH repeatable

# Utility migrations
bash .github/scripts/database-migrations/apply_migrations.sh $DB_HOST $DB_PORT $DB_NAME $DB_USER $SSM_PASS_PATH $MIGRATIONS_PATH utility

echo "::endgroup::"


# Cleanup temporary containers and postgres data folder
docker rm -f "$TMP_CONTAINER_NAME" 2>/dev/null || true
