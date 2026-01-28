#!/bin/bash
set -o nounset
set -o errexit

FLYWAY_VERSION="$1"
POSTGRES_JDBC_VERSION="$2"
POSTGRES_VERSION="$3"
ENVIRONMENT="${4:-qa}"

FLYWAY_DIR="/tmp/flyway-${FLYWAY_VERSION}-${ENVIRONMENT}"
DRIVER_DIR="${FLYWAY_DIR}/drivers"

# Cleanup if previous installations exist
rm -rf "$FLYWAY_DIR"
rm -rf "$DRIVER_DIR"

# Download Flyway
mkdir -p "$FLYWAY_DIR"
curl -sL "https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/${FLYWAY_VERSION}/flyway-commandline-${FLYWAY_VERSION}.tar.gz" -o /tmp/flyway.tar.gz
tar -xzf /tmp/flyway.tar.gz -C "$FLYWAY_DIR" --strip-components=1
chmod +x "$FLYWAY_DIR/flyway"

# Download JDBC driver
mkdir -p "$DRIVER_DIR"
curl -sL "https://repo1.maven.org/maven2/org/postgresql/postgresql/${POSTGRES_JDBC_VERSION}/postgresql-${POSTGRES_JDBC_VERSION}.jar" -o "$DRIVER_DIR/postgresql.jar"

export PATH="$FLYWAY_DIR:$PATH"
flyway -v

echo "$FLYWAY_DIR" >> $GITHUB_PATH
