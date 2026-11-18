# INLISLite v3.3

<p align="center">
  <img src="public/perpusnas.png" alt="Logo Perpustakaan Nasional RI" width="140">
  <br>
  <b>Sistem Otomasi Perpustakaan Terintegrasi Berbasis Web</b>
  <br>
  <i>Dikembangkan oleh Perpustakaan Nasional Republik Indonesia (Perpusnas RI)</i>
</p>

---

## 📌 Tentang INLISLite

**INLISLite** (*Integrated Library System*) adalah perangkat lunak otomasi perpustakaan yang dibangun untuk membantu seluruh jenis perpustakaan di Indonesia — mulai dari perpustakaan umum, perguruan tinggi, sekolah, hingga instansi pemerintah dan swasta. 

INLISLite v3.3 dibangun di atas framework **CodeIgniter 4**, memberikan arsitektur yang modern, ringan, aman, dan modular untuk memenuhi kebutuhan otomasi perpustakaan, pencarian katalog (OPAC), peminjaman, pengembalian, sirkulasi, dan pengelolaan literatur digital.

---

## 🚀 Panduan Instalasi Cepat

Pilih salah satu metode instalasi yang paling sesuai dengan server atau lingkungan Anda:

### 🐳 Opsi 1: Menggunakan Docker (Rekomendasi — Paling Mudah & Otomatis)

Metode ini paling direkomendasikan karena **tidak memerlukan instalasi manual PHP, Composer, maupun MySQL di host Anda**. Semua dependensi dan database otomatis terkonfigurasi.

1. **Clone repository ini:**
   ```bash
   git clone https://github.com/kungfukomang/inlist3.3_no_captcha.git inlislite
   cd inlislite
   ```

2. **Jalankan Docker Compose:**
   ```bash
   docker compose up -d
   ```
   > **Catatan:** Saat pertama kali dijalankan, kontainer database MariaDB akan otomatis mengimpor data awal dari `inlislite_v33.sql`, dan kontainer web server akan otomatis menyiapkan `.env` dan dependensi.

3. **Akses Aplikasi di Browser:**
   - **INLISLite Web (OPAC & Login Petugas):** [http://localhost:8080](http://localhost:8080)
   - **phpMyAdmin (Manajemen Database):** [http://localhost:8081](http://localhost:8081) *(User: `root`, Password: `root`)*

---

### 🪟 Opsi 2: Menggunakan Laragon / XAMPP di Windows

Cocok untuk pengguna Windows atau komputer lokal perpustakaan.

1. **Clone repository ke folder root web server:**
   - Untuk Laragon: `C:\laragon\www\inlislite`
   - Untuk XAMPP: `C:\xampp\htdocs\inlislite`

2. **Jalankan Setup Otomatis:**
   - Buka folder project, lalu **double-click** file `setup.bat`.
   - Atau buka terminal Laragon dan jalankan:
     ```bash
     composer install
     cp env.sample .env
     ```

3. **Buat Database & Import File SQL:**
   - Buka **HeidiSQL** (bawaan Laragon) atau **phpMyAdmin**.
   - Buat database baru:
     ```sql
     CREATE DATABASE inlislite_v33 CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
     ```
   - Import file `inlislite_v33.sql` ke database `inlislite_v33`.

4. **Konfigurasi `.env`:**
   Pastikan pengaturan database di file `.env` sudah sesuai:
   ```env
   CI_ENVIRONMENT = development
   app.baseURL = 'http://localhost:8080/'

   database.default.hostname = localhost
   database.default.database = inlislite_v33
   database.default.username = root
   database.default.password =
   database.default.DBDriver = MySQLi
   ```

5. **Jalankan Aplikasi:**
   - **Via CLI / PHP Spark:**
     ```bash
     php spark serve
     ```
     Buka di browser: [http://localhost:8080](http://localhost:8080)
   - **Via Virtual Host Laragon:**
     Arahkan DocumentRoot virtual host ke folder `public/`, misalnya: `C:/laragon/www/inlislite/public`.

---

### 🐧 Opsi 3: Instalasi di Linux Server / VPS (Ubuntu / Debian)

Untuk deployment di server produksi (VPS / Dedicated Server).

1. **Persyaratan Server:**
   - PHP >= 8.1
   - Ekstensi PHP wajib: `intl`, `mbstring`, `mysqli`, `curl`, `gd`, `zip`, `xml`, `fileinfo`
   - Composer
   - MariaDB / MySQL Server
   - Web Server (Nginx atau Apache)

2. **Clone & Jalankan Script Installer:**
   ```bash
   git clone https://github.com/kungfukomang/inlist3.3_no_captcha.git /var/www/inlislite
   cd /var/www/inlislite
   chmod +x install.sh
   ./install.sh
   ```

3. **Buat Database & Import Data:**
   ```bash
   mysql -u root -p -e "CREATE DATABASE inlislite_v33 CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;"
   mysql -u root -p inlislite_v33 < inlislite_v33.sql
   ```

4. **Konfigurasi Web Server (PENTING!):**
   > ⚠️ **PERHATIAN:** DocumentRoot web server **wajib** diarahkan ke folder `public/`, **bukan ke root project**.

   **Contoh Konfigurasi Nginx:**
   ```nginx
   server {
       listen 80;
       server_name perpustakaan.domain-anda.com;
       root /var/www/inlislite/public;
       index index.php index.html;

       location / {
           try_files $uri $uri/ /index.php$is_args$args;
       }

       location ~ \.php$ {
           include snippets/fastcgi-php.conf;
           fastcgi_pass unix:/var/run/php/php8.2-fpm.sock;
           fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
           include fastcgi_params;
       }

       location ~ /\.ht {
           deny all;
       }
   }
   ```

   **Atur Hak Akses File:**
   ```bash
   chown -R www-data:www-data /var/www/inlislite/writable /var/www/inlislite/public/uploads
   chmod -R 775 /var/www/inlislite/writable /var/www/inlislite/public/uploads
   ```

---

## 🔑 Akun & Kredensial Login Bawaan

Setelah database berhasil di-import, Anda dapat masuk menggunakan akun default:

| Role | Username / Email | Password Default | Akses URL |
| :--- | :--- | :--- | :--- |
| **Administrator Pusat** | `admin` *(atau `admin@admin.com`)* | `P@ssw0rd` | `/login` |
| **Petugas INLISLite** | `inlislite` *(atau `inlislite@gmail.com`)* | `inlislite` | `/login` |
| **Pemustaka (OPAC)** | Akses Publik Bebas | - | `/` (Halaman Utama) |

> 🔒 **Tips Keamanan:** Segera ubah password default administrator setelah pertama kali login di menu **Master Akun / Pengguna**.

---

## ⚙️ Penjelasan Konfigurasi `.env`

File konfigurasi utama berada pada `.env` di root project. Beberapa konfigurasi penting:

| Parameter | Keterangan | Nilai Contoh |
| :--- | :--- | :--- |
| `CI_ENVIRONMENT` | Lingkungan aplikasi (`development` atau `production`) | `production` |
| `app.baseURL` | URL dasar aplikasi (wajib berakhiran `/`) | `http://localhost:8080/` |
| `database.default.hostname` | Host MySQL (`localhost` atau nama service docker `db`) | `localhost` |
| `database.default.database` | Nama database yang dibuat | `inlislite_v33` |
| `database.default.username` | Username MySQL | `root` |
| `database.default.password` | Password MySQL | *(sesuai server Anda)* |
| `database.default.port` | Port server MySQL | `3306` |

---

## 🛠️ Troubleshooting & Masalah Umum

1. **Halaman Blank Putih atau Error 500:**
   - Periksa izin folder `writable/` dan pastikan web server memiliki akses tulis:
     ```bash
     chmod -R 777 writable
     ```
   - Cek log error di `writable/logs/` untuk melihat pesan error spesifik.

2. **Ekstensi `intl` tidak aktif:**
   - Pada Windows/Laragon/XAMPP: Buka `php.ini`, cari `;extension=intl`, hilangkan tanda titik koma (`;`), lalu restart web server.
   - Pada Linux: Jalankan `sudo apt install php-intl` dan restart `php-fpm`.

3. **Halaman 404 saat membuka menu atau modul:**
   - Pastikan modul rewrite Apache aktif (`sudo a2enmod rewrite`).
   - Pastikan direktif `AllowOverride All` aktif pada konfigurasi VirtualHost Apache.
   - Jika menggunakan Nginx, pastikan baris `try_files $uri $uri/ /index.php$is_args$args;` sudah ada.

4. **Error "MySQL server has gone away" saat import SQL:**
   - Ukuran file SQL adalah ~9 MB. Naikkan nilai `max_allowed_packet` di `my.cnf` / `my.ini` menjadi minimal `64M`.

---
NB: Butuh bantuan bisa wa ke nomer 081227232112

## 📄 Lisensi & Kredit

- **Pengembang Asli:** Divisi Pusat Data dan Informasi, Perpustakaan Nasional Republik Indonesia ([Perpusnas RI](https://www.perpusnas.go.id)).
- **Framework:** [CodeIgniter 4](https://codeigniter.com).
- Dibagikan untuk memudahkan pengelolaan perpustakaan di seluruh Indonesia.

**#SalamLiterasi**
