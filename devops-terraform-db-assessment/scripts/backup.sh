#!/bin/bash

set -euo pipefail

DB_CONTAINER="devops-assessment-postgres"
DB_NAME="bookings"
DB_USER="appuser"
BACKUP_DIR="backups"

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="${BACKUP_DIR}/${DB_NAME}_${TIMESTAMP}.dump"

mkdir -p "$BACKUP_DIR"

echo "Starting PostgreSQL backup..."

docker exec "$DB_CONTAINER" \
    pg_dump -U "$DB_USER" \
    -d "$DB_NAME" \
    -Fc > "$BACKUP_FILE"

if [ -s "$BACKUP_FILE" ]; then
    echo "Backup completed successfully!"
    echo "Backup file: $BACKUP_FILE"
    ls -lh "$BACKUP_FILE"
else
    echo "ERROR: Backup file is empty!"
    rm -f "$BACKUP_FILE"
    exit 1
fi
