#!/bin/bash

set -euo pipefail

DB_CONTAINER="devops-assessment-mysql"
RESTORE_DB="bookings_restore"
DB_USER="root"

if [ $# -ne 1 ]; then
    echo "Usage: $0 <backup_file>"
    exit 1
fi

BACKUP_FILE="$1"

if [ ! -s "$BACKUP_FILE" ]; then
    echo "ERROR: Backup file is missing or empty."
    exit 1
fi

echo "Checking MySQL backup file..."

if ! grep -q "CREATE TABLE" "$BACKUP_FILE"; then
    echo "ERROR: Backup does not appear to contain table definitions."
    exit 1
fi

echo "Backup file verified."

echo "Creating restore database..."

docker exec "$DB_CONTAINER" sh -c \
    'mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -e "DROP DATABASE IF EXISTS bookings_restore; CREATE DATABASE bookings_restore;"'

echo "Restoring database..."

docker exec -i "$DB_CONTAINER" sh -c \
    'exec mysql -uroot -p"$MYSQL_ROOT_PASSWORD" bookings_restore' \
    < "$BACKUP_FILE"

echo "Restore completed successfully!"

echo "Verifying restored bookings..."

docker exec "$DB_CONTAINER" sh -c \
    'mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -N -e "SELECT COUNT(*) AS restored_bookings FROM bookings_restore.hotel_bookings;"'

echo "Verifying restored events..."

docker exec "$DB_CONTAINER" sh -c \
    'mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -N -e "SELECT COUNT(*) AS restored_events FROM bookings_restore.booking_events;"'
