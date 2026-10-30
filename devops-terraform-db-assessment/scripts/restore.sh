#!/bin/bash

set -euo pipefail

DB_USER="appuser"
RESTORE_DB="bookings_restore"

if [ $# -ne 1 ]; then
    echo "Usage: $0 <backup_file>"
    exit 1
fi

BACKUP_FILE="$1"

if [ ! -s "$BACKUP_FILE" ]; then
    echo "ERROR: Backup file is missing or empty."
    exit 1
fi

echo "Checking backup format..."

docker-compose exec -T postgres pg_restore -l < "$BACKUP_FILE" > /dev/null

echo "Backup format verified."

echo "Creating restore database..."

docker-compose exec -T postgres dropdb \
    -U "$DB_USER" --if-exists "$RESTORE_DB"

docker-compose exec -T postgres createdb \
    -U "$DB_USER" "$RESTORE_DB"

echo "Restoring database..."

docker-compose exec -T postgres pg_restore \
    -U "$DB_USER" \
    -d "$RESTORE_DB" \
    --no-owner \
    --no-acl < "$BACKUP_FILE"

echo "Restore completed successfully!"

echo "Verifying restored bookings..."

docker-compose exec -T postgres psql \
    -U "$DB_USER" -d "$RESTORE_DB" \
    -c "SELECT COUNT(*) AS restored_bookings FROM hotel_bookings;"

echo "Verifying restored events..."

docker-compose exec -T postgres psql \
    -U "$DB_USER" -d "$RESTORE_DB" \
    -c "SELECT COUNT(*) AS restored_events FROM booking_events;"

