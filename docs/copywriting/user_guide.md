# CMMS SIGMA — Panduan Pengguna Cepat

## Daftar Isi

1. [Operator](#1-operator)
2. [Teknisi](#2-teknisi)
3. [Supervisor](#3-supervisor)
4. [Admin](#4-admin)

---

## 1. Operator

### Peran & Tanggung Jawab
Operator bertanggung jawab mengoperasikan mesin produksi dan melaporkan jika ditemukan kejanggalan atau kerusakan.

### Panduan Cepat

#### 🚀 Memulai
1. **Login** ke aplikasi SIGMA menggunakan email dan kata sandi yang diberikan atasan.
2. Setelah masuk, Anda akan melihat **Dashboard** dengan ringkasan mesin dan work order.

#### 📋 Melihat Daftar Mesin
1. Buka tab **Mesin** di navigasi bawah.
2. Gunakan kolom pencarian `Cari berdasarkan nama atau kode mesin...` untuk mencari mesin.
3. Ketuk kartu mesin untuk melihat **Detail Mesin**.

#### 🚨 Melaporkan Kerusakan
1. Dari halaman **Detail Mesin**, ketuk tombol **LAPORKAN KERUSAKAN**.
2. Atau dari Dashboard, ketuk tombol **(+) Buat Laporan**.
3. Isi formulir **Laporan Kerusakan**:
   - **Mesin**: Pilih mesin yang mengalami kerusakan.
   - **Deskripsi Kerusakan**: Jelaskan gejala yang terlihat.
   - **Foto**: Ambil foto kerusakan (wajib).
   - **Prioritas**: Pilih tingkat prioritas (Darurat/Tinggi/Sedang/Rendah).
   - **Stop Produksi**: Centang jika mesin berhenti berproduksi.
4. Ketuk **KIRIM LAPORAN**.

#### ✅ Menjalankan Checklist
1. Jika ada work order yang ditugaskan, buka tab **WO**.
2. Pilih work order dengan status **Terbuka**.
3. Ketuk **MULAI CHECKLIST**.
4. Isi setiap item checklist dengan **Ya** / **Tidak** / **N/A**.
5. Tambahkan catatan jika diperlukan.
6. Ketuk **SIMPAN** setelah selesai.

#### 📌 Tips Penggunaan
- Laporkan kerusakan sesegera mungkin saat ditemukan.
- Sertakan foto yang jelas agar Teknisi dapat menganalisis dengan tepat.
- Gunakan prioritas **Darurat** hanya jika mesin benar-benar berhenti produksi.

---

## 2. Teknisi

### Peran & Tanggung Jawab
Teknisi bertanggung jawab melakukan perawatan dan perbaikan mesin sesuai work order yang ditugaskan.

### Panduan Cepat

#### 🚀 Memulai
1. **Login** ke aplikasi SIGMA.
2. **Dashboard** akan menampilkan jumlah WO Aktif dan WO yang perlu ditangani hari ini.

#### 📋 Mengambil & Mengerjakan Work Order
1. Buka tab **WO**.
2. Pilih tab **Terbuka** untuk melihat work order yang tersedia.
3. Ketuk work order yang ingin dikerjakan.
4. Ketuk **AMBIL WO** untuk mengambil alih pekerjaan.
5. Ketuk **MULAI BEKERJA** saat Anda mulai mengerjakan.

#### ✅ Melaksanakan Checklist Perawatan
1. Di halaman **Detail WO**, ketuk **MULAI CHECKLIST**.
2. Kerjakan setiap item checklist satu per satu.
3. Tandai hasil dengan **Ya** ✓ (sesuai), **Tidak** ✗ (tidak sesuai), atau **N/A** (tidak berlaku).
4. Tambahkan catatan pada item yang memerlukan penjelasan.
5. Perhatikan **Progress** checklist di bagian atas.
6. Setelah selesai, ketuk **SIMPAN**.

#### 📸 Dokumentasi Pekerjaan
1. Di bagian **Foto & Dokumentasi**, ambil foto sebelum dan sesudah perbaikan.
2. Ketuk **AMBIL FOTO** atau **PILIH DARI GALERI**.
3. Tambahkan keterangan pada setiap foto.

#### 🔧 Mencatat Penggunaan Spare Part
1. Di bagian **Spare Part**, ketuk **+ TAMBAH SPARE PART**.
2. Pilih atau masukkan:
   - Nama dan kode spare part
   - Jumlah yang digunakan
   - Satuan
3. Perhatikan stok tersedia yang ditampilkan.

#### 📝 Mengisi Catatan Teknisi
1. Di bagian **Catatan**, tulis:
   - **Temuan**: Hasil inspeksi atau masalah yang ditemukan.
   - **Tindakan**: Langkah perbaikan yang dilakukan.
   - **Catatan Tambahan**: Informasi lain yang relevan.

#### 🏁 Menyelesaikan Work Order
1. Pastikan semua checklist, foto, spare part, dan catatan sudah lengkap.
2. Ketuk **SELESAIKAN**.
3. WO akan masuk ke status **Selesai** dan menunggu verifikasi Supervisor.

#### 📌 Tips Penggunaan
- Selalu lengkapi dokumentasi foto (sebelum & sesudah) sebagai bukti pekerjaan.
- Catat spare part yang digunakan untuk memudahkan inventaris.
- Jika menemui kendala, gunakan catatan untuk berkomunikasi dengan Supervisor.

---

## 3. Supervisor

### Peran & Tanggung Jawab
Supervisor bertanggung jawab mengawasi, menugaskan, dan memverifikasi work order yang dikerjakan oleh Teknisi.

### Panduan Cepat

#### 🚀 Memulai
1. **Login** ke aplikasi SIGMA.
2. **Dashboard** menampilkan gambaran umum: Total WO Aktif, WO Terlambat, dan KPI kinerja.

#### 📊 Memantau Kinerja
1. Dari **Dashboard**, lihat KPI utama:
   - **OEE** (Overall Equipment Effectiveness)
   - **MTBF** (Mean Time Between Failures)
   - **MTTR** (Mean Time To Repair)
   - **Availability**, **Kinerja**, dan **Kualitas**
2. Grafik **WO Mingguan** menunjukkan tren pekerjaan.

#### 📋 Menugaskan Work Order
1. Buka tab **WO** → **Semua** atau **Terbuka**.
2. Ketuk tombol **+ BUAT WO** untuk membuat work order baru.
3. Isi informasi WO:
   - Mesin, tipe perawatan, prioritas
   - Deskripsi pekerjaan
   - Tugaskan ke Teknisi tertentu
   - Tenggat waktu
4. Ketuk **SIMPAN**.

#### ✅ Melakukan Verifikasi
1. Buka work order dengan status **Selesai**.
2. Periksa kelengkapan:
   - Checklist yang sudah diisi
   - Foto dokumentasi
   - Spare part yang digunakan
   - Catatan Teknisi
3. Di bagian **Verifikasi**, pilih:
   - **SETUJUI** jika pekerjaan sesuai standar → WO menjadi **Terverifikasi**.
   - **TOLAK** jika ada yang tidak sesuai → WO dikembalikan ke Teknisi.
4. Tambahkan **Catatan Verifikasi** sebagai feedback.

#### 📈 Melihat Riwayat & Statistik
1. Buka tab **Riwayat** untuk melihat statistik perawatan:
   - Total perawatan, rata-rata per bulan
   - Breakdown Preventif vs Korektif
   - Total biaya, MTBF, MTTR
2. Gunakan **Filter** untuk mempersempit data berdasarkan tanggal, mesin, atau tipe perawatan.
3. Ketuk **EXPORT CSV** atau **EXPORT PDF** untuk mengunduh laporan.

#### 📌 Tips Penggunaan
- Verifikasi work order tepat waktu agar Teknisi dapat melanjutkan pekerjaan berikutnya.
- Gunakan data riwayat untuk mengidentifikasi mesin yang sering bermasalah.
- Berikan catatan verifikasi yang konstruktif.

---

## 4. Admin

### Peran & Tanggung Jawab
Admin memiliki akses penuh ke seluruh fitur aplikasi, termasuk manajemen pengguna, mesin, dan pengaturan sistem.

### Panduan Cepat

#### 🚀 Memulai
1. **Login** dengan akun Admin.
2. **Dashboard** menampilkan gambaran menyeluruh operasional perawatan.

#### 👥 Manajemen Pengguna
1. Buka **Profil** → **Manajemen Pengguna**.
2. Dari sini Anda dapat:
   - **Melihat daftar** semua pengguna
   - **Menambah** pengguna baru
   - **Mengedit** peran dan akses pengguna
   - **Menonaktifkan** akun pengguna

#### 🏭 Manajemen Mesin
1. Buka tab **Mesin**.
2. Ketuk **+ TAMBAH MESIN** untuk menambahkan mesin baru.
3. Isi informasi:
   - Kode mesin, nama, tipe, produsen
   - Lokasi, departemen
   - Tahun pembuatan, spesifikasi teknis
4. Sistem akan otomatis membuat **Kode QR** untuk setiap mesin.

#### ⚙️ Konfigurasi Sistem
1. Buka **Profil** → **Pengaturan Aplikasi**.
2. Konfigurasi yang tersedia:
   - **Checklist Templates**: Kelola template checklist untuk berbagai tipe mesin.
   - **Kategori WO**: Atur tipe dan prioritas work order.
   - **Jam Kerja**: Tentukan jam kerja dan hari libur.
   - **Notifikasi**: Atur pengiriman notifikasi (FCM, Email, WhatsApp).

#### 📊 Laporan & Analitik
1. Buka **Profil** → **Laporan & Statistik**.
2. Akses laporan lengkap:
   - Ringkasan perawatan periodik
   - Biaya perawatan per mesin/departemen
   - Analisis downtime
   - Tren MTBF & MTTR
3. Export data dalam format **CSV** atau **PDF**.

#### 🔐 Pengaturan Keamanan
1. Atur kebijakan kata sandi (minimal karakter, kompleksitas).
2. Atur masa berlaku sesi login.
3. Kelola akses biometrik (sidik jari).
4. Tinjau **Log Aktivitas** untuk memantau penggunaan sistem.

#### 📌 Tips Penggunaan
- Lakukan audit pengguna secara berkala untuk memastikan hanya pengguna aktif yang memiliki akses.
- Backup data secara rutin melalui menu pengaturan.
- Gunakan log aktivitas untuk melacak perubahan dan troubleshooting.

---

## Troubleshooting Umum

| Masalah | Solusi |
|---------|--------|
| **Lupa kata sandi** | Ketuk "Lupa kata sandi?" di layar login. Ikuti instruksi reset via email. |
| **Gagal login berkali-kali** | Tunggu 30 detik sebelum mencoba lagi. Hubungi Admin jika terus gagal. |
| **Notifikasi tidak masuk** | Periksa: (1) Izin notifikasi di pengaturan HP, (2) toggle notifikasi di Profil, (3) koneksi internet. |
| **Gagal upload foto** | Periksa izin kamera dan penyimpanan. Pastikan koneksi stabil. |
| **Data tidak muncul** | Tarik ke bawah (pull-to-refresh) untuk memuat ulang data. |
| **QR code tidak terdeteksi** | Pastikan pencahayaan cukup dan kamera fokus pada kode QR. |
| **Aplikasi lambat** | Tutup aplikasi dan buka kembali. Hapus cache jika perlu. |

---

## Kontak & Dukungan

- **Pusat Bantuan**: Profil → Pusat Bantuan
- **FAQ**: Profil → FAQ
- **Hubungi Admin**: Hubungi administrator sistem Anda untuk masalah akun.
- **Email Dukungan**: support@cmms-sigma.com

---

*Dokumen ini diperbarui: Juli 2026 | CMMS SIGMA v1.0.0*
