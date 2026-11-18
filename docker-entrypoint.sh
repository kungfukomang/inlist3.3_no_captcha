#!/bin/bash
set -e

# Salin konfigurasi environment Docker jika .env belum ada
if [ ! -f /var/www/html/.env ]; then
    if [ -f /var/www/html/env.docker ]; then
        cp /var/www/html/env.docker /var/www/html/.env
        echo "[INLISLite] .env dibuat otomatis dari env.docker."
    elif [ -f /var/www/html/env.sample ]; then
        cp /var/www/html/env.sample /var/www/html/.env
        echo "[INLISLite] .env dibuat dari env.sample."
    fi
fi

# Pastikan folder writable dan subfoldernya tersedia
mkdir -p /var/www/html/writable/cache \
         /var/www/html/writable/logs \
         /var/www/html/writable/session \
         /var/www/html/writable/uploads \
         /var/www/html/writable/debugbar \
         /var/www/html/writable/exports \
         /var/www/html/public/uploads

# Atur permission agar web server dapat menulis ke folder writable dan uploads
chmod -R 777 /var/www/html/writable /var/www/html/public/uploads

# Install dependencies jika vendor belum terpasang
if [ ! -d /var/www/html/vendor ]; then
    echo "[INLISLite] Memasang dependencies PHP via Composer..."
    composer install --no-interaction --prefer-dist --optimize-autoloader
fi

echo "[INLISLite] Siap dijalankan!"

exec "$@"

