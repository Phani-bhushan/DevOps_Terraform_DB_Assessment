#!/bin/bash

set -euo pipefail

DB_CONTAINER="devops-assessment-mysql"
DB_NAME="bookings"
BACKUP_DIR="backups"

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="${BACKUP_DIR}/${DB_NAME}_${TIMESTAMP}.sql"

mkdir -p "$BACKUP_DIR"

echo "Starting MySQL backup..."

if docker exec "$DB_CONTAINER" sh -c \
    'exec mysqldump --single-transaction --routines --triggers --no-tablespaces -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE"' \
    > "$BACKUP_FILE"; then

    if [ -s "$BACKUP_FILE" ]; then
        echo "Backup completed successfully!"
        echo "Backup file: $BACKUP_FILE"
        ls -lh "$BACKUP_FILE"
    else
        echo "ERROR: Backup file is empty!"
        rm -f "$BACKUP_FILE"
        exit 1
    fi
else
    echo "ERROR: MySQL backup failed!"
    rm -f "$BACKUP_FILE"
    exit 1
fi

