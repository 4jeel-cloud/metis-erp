#!/bin/bash
set -e

APP_DIR="/var/www/metis"
cd "$APP_DIR"

log() { echo "[metis-entrypoint] $(date '+%Y-%m-%d %H:%M:%S') $*"; }

DB_HOST="${DB_HOST:-127.0.0.1}"
DB_PORT="${DB_PORT:-3306}"
DB_DATABASE="${DB_DATABASE:-metis}"
DB_USERNAME="${DB_USERNAME:-metis}"
DB_PASSWORD="${DB_PASSWORD:-metis}"

use_internal_mysql() { [[ "$DB_HOST" == "127.0.0.1" || "$DB_HOST" == "localhost" ]]; }

if use_internal_mysql; then
    log "Mode: INTERNAL MySQL"
    export MYSQL_AUTOSTART=true
else
    log "Mode: EXTERNAL MySQL (${DB_HOST}:${DB_PORT})"
    export MYSQL_AUTOSTART=false
fi

sed_escape() { printf '%s' "$1" | sed -e 's/[\\&/]/\\&/g'; }

set_env() {
    local key="$1" val
    val=$(sed_escape "$2")
    if grep -q "^${key}=" .env 2>/dev/null; then
        sed -i "s|^${key}=.*|${key}=${val}|" .env
    else
        echo "${key}=${val}" >> .env
    fi
}

log "Applying runtime environment overrides..."
set_env DB_HOST     "$DB_HOST"
set_env DB_PORT     "$DB_PORT"
set_env DB_DATABASE "$DB_DATABASE"
set_env DB_USERNAME "$DB_USERNAME"
set_env DB_PASSWORD "$DB_PASSWORD"

set_env APP_ENV "${APP_ENV:-production}"
set_env APP_DEBUG "${APP_DEBUG:-false}"

[ -n "$APP_URL" ]      && set_env APP_URL      "$APP_URL"
[ -n "$APP_NAME" ]     && set_env APP_NAME     "\"${APP_NAME}\""
[ -n "$APP_LOCALE" ]   && set_env APP_LOCALE   "$APP_LOCALE"
[ -n "$APP_CURRENCY" ] && set_env APP_CURRENCY "$APP_CURRENCY"
[ -n "$APP_TIMEZONE" ] && set_env APP_TIMEZONE "$APP_TIMEZONE"

if [ -z "$APP_KEY" ] || [ "$APP_KEY" = "APP_KEY" ]; then
    log "No APP_KEY provided. Generating one..."
    APP_KEY=$(php artisan key:generate --show --no-interaction 2>/dev/null || php -r "echo 'base64:' . base64_encode(random_bytes(32));")
    set_env APP_KEY "$APP_KEY"
    log "APP_KEY generated."
fi

if ! use_internal_mysql; then
    log "Waiting for external MySQL at ${DB_HOST}:${DB_PORT}..."
    for i in $(seq 1 60); do
        if php -r "try { new PDO('mysql:host=${DB_HOST};port=${DB_PORT}', '${DB_USERNAME}', '${DB_PASSWORD}'); } catch (Throwable \$e) { exit(1); }" 2>/dev/null; then
            log "External MySQL is reachable."
            break
        fi
        if [ "$i" -eq 60 ]; then
            log "ERROR: cannot reach external MySQL at ${DB_HOST}:${DB_PORT} after 60s."
            exit 1
        fi
        sleep 1
    done

    has_tables=$(php -r "try { \$p = new PDO('mysql:host=${DB_HOST};port=${DB_PORT};dbname=${DB_DATABASE}', '${DB_USERNAME}', '${DB_PASSWORD}'); \$r = \$p->query('SHOW TABLES'); echo \$r->rowCount(); } catch (Throwable \$e) { echo '0'; }" 2>/dev/null || echo "0")
    if [ "$has_tables" -eq 0 ]; then
        log "No tables found in database. Running fresh installation..."
        php artisan erp:install --no-interaction --force \
            --admin-name="${ADMIN_NAME:-Administrator}" \
            --admin-email="${ADMIN_EMAIL:-admin@example.com}" \
            --admin-password="${ADMIN_PASSWORD:-password}" 2>&1 | while read -r line; do log "$line"; done
        log "ERP installation completed."
    else
        log "Database contains $has_tables tables. Running pending migrations..."
        php artisan migrate --no-interaction --force 2>&1 | while read -r line; do log "$line"; done
        log "Migrations completed."
    fi
fi

log "Refreshing cached configuration..."
php artisan optimize:clear --no-interaction 2>/dev/null || true
php artisan config:cache --no-interaction 2>/dev/null || true
php artisan route:cache --no-interaction 2>/dev/null || true
php artisan view:cache --no-interaction 2>/dev/null || true

log "Starting services via Supervisor..."
exec "$@"
