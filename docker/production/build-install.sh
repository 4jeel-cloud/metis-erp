#!/bin/bash
set -euo pipefail

APP_DIR="/var/www/metis"

ADMIN_NAME="${ADMIN_NAME:-Administrator}"
ADMIN_EMAIL="${ADMIN_EMAIL:-admin@example.com}"
ADMIN_PASSWORD="${ADMIN_PASSWORD:-password}"

echo "[build-install] Initialising MySQL data directory..."
mkdir -p /run/mysqld /var/lib/mysql
chown -R mysql:mysql /run/mysqld /var/lib/mysql

if [ ! -f /var/lib/mysql/ibdata1 ]; then
    mysqld --initialize-insecure --user=mysql --datadir=/var/lib/mysql
    echo "[build-install] MySQL data directory initialized."
else
    echo "[build-install] MySQL data directory already exists, skipping initialization."
fi

echo "[build-install] Starting MySQL..."
mysqld --user=mysql --datadir=/var/lib/mysql --skip-log-bin &
MYSQL_PID=$!

echo "[build-install] Waiting for MySQL to be ready..."
for i in $(seq 1 60); do
    if mysqladmin --silent ping 2>/dev/null; then
        echo "[build-install] MySQL is ready."
        break
    fi
    if [ "$i" -eq 60 ]; then
        echo "[build-install] ERROR: MySQL did not start within 60 seconds."
        tail -20 /var/log/mysql/error.log 2>/dev/null || true
        exit 1
    fi
    sleep 1
done

echo "[build-install] Creating database and user..."
mysql -u root < /docker-entrypoint-initdb.d/init.sql

cd "$APP_DIR"

echo "[build-install] Generating application key..."
php artisan key:generate --force --no-interaction

echo "[build-install] Installing Metis (migrations, seeders, roles, admin)..."
php artisan erp:install --force --no-interaction \
    --admin-name="$ADMIN_NAME" \
    --admin-email="$ADMIN_EMAIL" \
    --admin-password="$ADMIN_PASSWORD"

echo "[build-install] Shutting down MySQL..."
mysqladmin -u root shutdown || true
wait "$MYSQL_PID" 2>/dev/null || true

chown -R mysql:mysql /var/lib/mysql

echo "[build-install] Metis installation complete."
