#!/usr/bin/env bash
# ==============================================================================
# Script Instalasi INLISLite v3.3 untuk Linux Server (Ubuntu / Debian)
# ==============================================================================

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}====================================================${NC}"
echo -e "${GREEN}   Installer Otomatis INLISLite v3.3 (CodeIgniter 4)${NC}"
echo -e "${GREEN}====================================================${NC}"

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$PROJECT_DIR"

# 1. Cek PHP
echo -e "\n${YELLOW}[1/5] Memeriksa PHP dan ekstensi...${NC}"
if ! command -v php &> /dev/null; then
    echo -e "${RED}[ERROR] PHP belum terpasang. Harap pasang PHP >= 8.1 beserta ekstensinya.${NC}"
    echo "Contoh: sudo apt install php8.2 php8.2-cli php8.2-fpm php8.2-mysql php8.2-intl php8.2-mbstring php8.2-curl php8.2-gd php8.2-zip php8.2-xml"
    exit 1
fi

PHP_VER=$(php -r "echo PHP_VERSION;")
echo -e "PHP terdeteksi: ${GREEN}v$PHP_VER${NC}"

REQUIRED_EXTS=("intl" "mbstring" "mysqli" "curl" "gd" "zip" "xml" "fileinfo")
MISSING_EXTS=()

for ext in "${REQUIRED_EXTS[@]}"; do
    if ! php -m | grep -iq "^$ext$"; then
        MISSING_EXTS+=("$ext")
    fi
done

if [ ${#MISSING_EXTS[@]} -ne 0 ]; then
    echo -e "${RED}[WARNING] Ekstensi PHP berikut belum terpasang/aktif: ${MISSING_EXTS[*]}${NC}"
    echo "Pasang ekstensi tersebut agar aplikasi dapat berjalan normal."
fi

# 2. Cek Composer
echo -e "\n${YELLOW}[2/5] Memeriksa Composer...${NC}"
if ! command -v composer &> /dev/null; then
    echo -e "${YELLOW}[WARNING] Composer belum terpasang secara global.${NC}"
    echo "Silakan install composer dari https://getcomposer.org atau via 'sudo apt install composer'."
else
    echo -e "Menjalankan ${GREEN}composer install${NC}..."
    composer install --no-interaction --prefer-dist --optimize-autoloader || echo -e "${YELLOW}Gagal composer install, silakan jalankan manual nanti.${NC}"
fi

# 3. Konfigurasi File .env
echo -e "\n${YELLOW}[3/5] Menyiapkan file .env...${NC}"
if [ ! -f .env ]; then
    if [ -f env.sample ]; then
        cp env.sample .env
        echo -e "${GREEN}File .env berhasil dibuat dari env.sample.${NC}"
        echo -e "${YELLOW}CATATAN: Silakan edit file .env untuk mengatur koneksi database dan app.baseURL Anda!${NC}"
    fi
else
    echo -e "File .env sudah ada, melewati langkah ini."
fi

# 4. Atur Permission Folder
echo -e "\n${YELLOW}[4/5] Mengatur hak akses folder (permissions)...${NC}"
mkdir -p writable/cache writable/logs writable/session writable/uploads writable/debugbar writable/exports public/uploads

if [ "$(id -u)" -eq 0 ]; then
    # Jika dijalankan sebagai root / sudo
    WEB_USER="www-data"
    if id "$WEB_USER" &>/dev/null; then
        chown -R "$WEB_USER":"$WEB_USER" writable public/uploads
    fi
fi

chmod -R 775 writable public/uploads
echo -e "${GREEN}Permission folder writable/ dan public/uploads/ berhasil diatur.${NC}"

# 5. Petunjuk Database
echo -e "\n${YELLOW}[5/5] Setup Database & Web Server${NC}"
echo -e "1. Buat database di MySQL/MariaDB:"
echo -e "   ${GREEN}CREATE DATABASE inlislite_v33 CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;${NC}"
echo -e "2. Import file database:"
echo -e "   ${GREEN}mysql -u root -p inlislite_v33 < inlislite_v33.sql${NC}"
echo -e "3. Arahkan DocumentRoot web server (Apache/Nginx) ke folder:"
echo -e "   ${GREEN}$PROJECT_DIR/public${NC}"
echo -e "4. Atau jalankan server bawaan PHP untuk testing:"
echo -e "   ${GREEN}php spark serve${NC}"

echo -e "\n${GREEN}====================================================${NC}"
echo -e "${GREEN}      Instalasi Awal INLISLite v3.3 Selesai!        ${NC}"
echo -e "${GREEN}====================================================${NC}"
