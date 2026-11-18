@echo off
REM ==============================================================================
REM Script Setup INLISLite v3.3 untuk Windows (Laragon / XAMPP / CMD)
REM ==============================================================================

echo ====================================================
echo     Setup INLISLite v3.3 untuk Windows
echo ====================================================
echo.

REM 1. Salin .env
if not exist ".env" (
    if exist "env.sample" (
        copy env.sample .env >nul
        echo [OK] File .env berhasil disalin dari env.sample.
        echo [INFO] Jangan lupa sesuaikan koneksi database di file .env.
    )
) else (
    echo [INFO] File .env sudah ada.
)

REM 2. Buat folder writable jika belum ada
if not exist "writable\cache" mkdir "writable\cache"
if not exist "writable\logs" mkdir "writable\logs"
if not exist "writable\session" mkdir "writable\session"
if not exist "writable\uploads" mkdir "writable\uploads"
if not exist "writable\debugbar" mkdir "writable\debugbar"
if not exist "writable\exports" mkdir "writable\exports"
if not exist "public\uploads" mkdir "public\uploads"
echo [OK] Folder writable dan public/uploads siap.

REM 3. Jalankan composer install jika composer tersedia
where composer >nul 2>nul
if %ERRORLEVEL% EQU 0 (
    echo.
    echo Menjalankan composer install...
    call composer install --no-interaction --prefer-dist --optimize-autoloader
) else (
    echo.
    echo [WARNING] Composer tidak terdeteksi di PATH sistem.
    echo Jika menggunakan Laragon, pastikan terminal dibuka lewat tombol 'Terminal' Laragon.
)

echo.
echo ====================================================
echo Setup selesai!
echo.
echo Langkah berikutnya:
echo 1. Buat database: inlislite_v33 di MySQL/HeidiSQL/phpMyAdmin
echo 2. Import file: inlislite_v33.sql ke database tersebut
echo 3. Jalankan aplikasi via Laragon atau command: php spark serve
echo ====================================================
echo.
pause
