# CMMS SIGMA — Application Copywriting (Bahasa Indonesia)

## 1. Login Screen

| Elemen | Teks |
|--------|------|
| Judul Layar | **Masuk ke SIGMA** |
| Label Email | **Email** |
| Placeholder Email | `Masukkan alamat email` |
| Label Kata Sandi | **Kata Sandi** |
| Placeholder Kata Sandi | `Masukkan kata sandi` |
| Tombol Masuk | **MASUK** |
| Lupa Kata Sandi | **Lupa kata sandi?** |
| Tautan Daftar | Belum punya akun? **Daftar** |
| Label Biometrik | **Gunakan sidik jari untuk masuk** |
| Checkbox Ingat Saya | **Ingat saya** |

**Validasi — Email:**
- Kosong: "Email wajib diisi"
- Format salah: "Format email tidak valid"

**Validasi — Kata Sandi:**
- Kosong: "Kata sandi wajib diisi"
- Minimal 6 karakter: "Kata sandi minimal 6 karakter"

**Error Messages:**
- Kredensial salah: "Email atau kata sandi salah"
- Akun tidak aktif: "Akun Anda telah dinonaktifkan. Hubungi administrator."
- Jaringan gagal: "Gagal terhubung ke server. Periksa koneksi internet Anda."
- Sesi kedaluwarsa: "Sesi Anda telah berakhir. Silakan masuk kembali."
- Terlalu banyak percobaan: "Terlalu banyak percobaan gagal. Coba lagi dalam 30 detik."

---

## 2. Dashboard

| Elemen | Teks |
|--------|------|
| **Kartu Ringkasan** | |
| Total Mesin | **Total Mesin** |
| WO Aktif | **WO Aktif** |
| WO Hari Ini | **WO Hari Ini** |
| WO Terlambat | **WO Terlambat** |
| Ketersediaan Mesin | **Ketersediaan Mesin** |
| **KPI Labels** | |
| KPI Efektivitas | **Overall Equipment Effectiveness (OEE)** |
| KPI MTBF | **Mean Time Between Failures (MTBF)** |
| KPI MTTR | **Mean Time To Repair (MTTR)** |
| KPI Kinerja | **Kinerja** — % |
| KPI Kualitas | **Kualitas** — % |
| KPI Availability | **Availability** — % |
| **Bottom Navigation** | |
| Nav Beranda | **Beranda** |
| Nav Mesin | **Mesin** |
| Nav WO | **WO** |
| Nav Riwayat | **Riwayat** |
| Nav Profil | **Profil** |

**Card Titles Lainnya:**
- Grafik WO per Minggu: **Grafik Work Order Mingguan**
- Breakdown Terbaru: **Kerusakan Terbaru**
- Jadwal Hari Ini: **Jadwal Perawatan Hari Ini**

---

## 3. Machine List

| Elemen | Teks |
|--------|------|
| Judul | **Daftar Mesin** |
| Search Hint | `Cari berdasarkan nama atau kode mesin...` |
| Tombol Filter | **Filter** |
| Tombol Scan QR | **Scan QR** |
| **Empty State** | |
| Ikon | (illustrasi mesin kosong) |
| Pesan | **Belum ada mesin** |
| Subpesan | Tambahkan mesin pertama Anda untuk memulai |
| Tombol Aksi | **+ Tambah Mesin** |
| **Status Labels** | |
| Aktif | **Aktif** — label hijau |
| Nonaktif | **Nonaktif** — label abu-abu/merah |
| **Sort Options** | |
| Urutkan: Nama | **Nama** |
| Urutkan: Terbaru | **Terbaru** |
| Urutkan: Status | **Status** |

---

## 4. Machine Detail

| Elemen | Teks |
|--------|------|
| Judul | **Detail Mesin** |
| **Section Headers** | |
| Informasi Umum | **Informasi Umum** |
| Spesifikasi | **Spesifikasi Teknis** |
| Riwayat Perawatan | **Riwayat Perawatan** |
| Dokumen Terkait | **Dokumen Terkait** |
| **Fields** | |
| Kode Mesin | **Kode Mesin** |
| Nama Mesin | **Nama Mesin** |
| Lokasi | **Lokasi / Area** |
| Tipe | **Tipe / Model** |
| Tahun Pembuatan | **Tahun Pembuatan** |
| Produsen | **Produsen** |
| Status | **Status** |
| Departemen | **Departemen** |
| QR Code Label | **Pindai Kode QR** |
| Tombol Edit | **EDIT** |
| Tombol Hapus | **HAPUS** |
| Tombol Buat WO | **BUAT WORK ORDER** |
| Tombol Lapor Kerusakan | **LAPORKAN KERUSAKAN** |
| Tombol Lihat Riwayat | **LIHAT RIWAYAT** |
| Tombol Bagikan QR | **BAGIKAN QR** |

**QR Code Section:**
- Label: **Kode QR Mesin**
- Petunjuk: Pindai kode QR ini untuk mengakses detail mesin dengan cepat

---

## 5. Work Order List

| Elemen | Teks |
|--------|------|
| Judul | **Work Order** |
| **Filter Tabs** | |
| Tab Terbuka | **Terbuka** |
| Tab Berjalan | **Berjalan** |
| Tab Selesai | **Selesai** |
| Tab Semua | **Semua** |
| Tombol Tambah | **+ BUAT WO** |
| **Empty State** | |
| Ikon | (illustrasi clipboard kosong) |
| Pesan | **Tidak ada work order** |
| Subpesan | Work order baru akan muncul di sini |
| **Card Items** | |
| Label Prioritas Tinggi | **Tinggi** — label merah |
| Label Prioritas Sedang | **Sedang** — label kuning |
| Label Prioritas Rendah | **Rendah** — label biru |
| Label Deadline | **Tenggat:** dd/mm/yyyy |
| Label Tipe Preventif | **Preventif** |
| Label Tipe Korektif | **Korektif** |
| Label Tipe Breakdown | **Darurat** |

---

## 6. Work Order Detail

| Elemen | Teks |
|--------|------|
| Judul | **Detail Work Order** |
| **Section Headers** | |
| Informasi WO | **Informasi Work Order** |
| Checklist | **Checklist** |
| Foto & Dokumentasi | **Foto & Dokumentasi** |
| Spare Part | **Spare Part** |
| Catatan | **Catatan** |
| Verifikasi | **Verifikasi** |
| Riwayat Aktivitas | **Riwayat Aktivitas** |
| **Field Labels — Checklist** | |
| Tombol Mulai Checklist | **MULAI CHECKLIST** |
| Tombol Selesai Checklist | **SELESAIKAN CHECKLIST** |
| Label Progress | **Progress Checklist:** 0/5 |
| **Field Labels — Foto** | |
| Label Ambil Foto | **Ambil Foto** |
| Label Pilih Galeri | **Pilih dari Galeri** |
| Caption Foto | **Tambahkan keterangan foto** |
| Tombol Upload Foto | **UNGGAH FOTO** |
| Foto Sebelum | **Foto Sebelum** |
| Foto Sesudah | **Foto Sesudah** |
| **Field Labels — Spare Part** | |
| Header | **Spare Part yang Digunakan** |
| Label Nama Part | **Nama Spare Part** |
| Label Kode Part | **Kode Spare Part** |
| Label Jumlah | **Jumlah** |
| Label Satuan | **Satuan** |
| Label Stok Tersedia | **Stok tersedia:** 10 |
| Tombol Tambah Part | **+ TAMBAH SPARE PART** |
| Tombol Hapus Part | **HAPUS** |
| **Field Labels — Catatan** | |
| Label Catatan | **Catatan Teknisi** |
| Placeholder Catatan | `Tulis catatan pekerjaan di sini...` |
| Label Temuan | **Temuan / Hasil Inspeksi** |
| Placeholder Temuan | `Deskripsikan temuan selama inspeksi...` |
| Label Tindakan | **Tindakan yang Dilakukan** |
| Placeholder Tindakan | `Jelaskan tindakan perbaikan yang dilakukan...` |
| **Field Labels — Verifikasi** | |
| Header Verifikasi | **Verifikasi Pekerjaan** |
| Label Supervisor | **Disupervisi oleh** |
| Label Tgl Verifikasi | **Tanggal Verifikasi** |
| Label Status Verifikasi | **Status Verifikasi** |
| Status Lulus | **LULUS** |
| Status Ditolak | **DITOLAK** |
| Label Catatan Verifikasi | **Catatan Verifikasi** |
| Placeholder Catatan Verif | `Catatan dari supervisor...` |
| Tombol Setujui | **SETUJUI** |
| Tombol Tolak | **TOLAK** |
| **Status WO** | |
| Status Terbuka | **Terbuka** |
| Status Dijadwalkan | **Dijadwalkan** |
| Status Diproses | **Sedang Diproses** |
| Status Selesai | **Selesai** |
| Status Diverifikasi | **Terverifikasi** |
| **Tombol Aksi** | |
| Tombol Ambil WO | **AMBIL WO** |
| Tombol Mulai Pekerjaan | **MULAI BEKERJA** |
| Tombol Selesaikan | **SELESAIKAN** |
| Tombol Cetak WO | **CETAK WO** |

---

## 7. Checklist Form

| Elemen | Teks |
|--------|------|
| Header | **Checklist Perawatan** |
| Subheader | **Lengkapi item checklist di bawah ini** |
| **Progress Text** | |
| Progress | **Progress:** 3 dari 8 item selesai |
| Progress Bar | [████████░░░░░░░░░░] 38% |
| Label Selesai | **Selesai** |
| Label Belum | **Belum** |
| **Item Checklist** | |
| Label Ya | **Ya ✓** |
| Label Tidak | **Tidak ✗** |
| Label N/A | **N/A** |
| Label Catatan per Item | **Catatan** |
| Placeholder Catatan Item | `Tambahkan catatan untuk item ini...` |
| **Tombol** | |
| Tombol Simpan | **SIMPAN** |
| Tombol Simpan & Lanjut | **SIMPAN & LANJUTKAN** |
| Tombol Batal | **BATAL** |
| Tombol Reset | **RESET** |
| **Dialog Konfirmasi** | |
| Judul Konfirmasi Simpan | **Simpan Checklist?** |
| Pesan Konfirmasi Simpan | "Apakah Anda yakin ingin menyimpan hasil checklist?" |
| Tombol Ya Simpan | **YA, SIMPAN** |
| Tombol Tidak | **TIDAK** |

---

## 8. Breakdown Report

| Elemen | Teks |
|--------|------|
| Judul | **Laporan Kerusakan** |
| Subjudul | **Laporkan kerusakan mesin** |
| **Field Labels** | |
| Label Mesin | **Mesin** |
| Placeholder Mesin | `Pilih mesin yang mengalami kerusakan...` |
| Label Deskripsi | **Deskripsi Kerusakan** |
| Placeholder Deskripsi | `Jelaskan gejala kerusakan yang terjadi...` |
| Label Foto | **Foto Kerusakan** |
| Hint Foto | **Ambil foto untuk dokumentasi kerusakan** |
| Tombol Ambil Foto | **AMBIL FOTO** |
| Label Prioritas | **Prioritas** |
| Opsi Prioritas — Darurat | **Darurat** — label merah |
| Opsi Prioritas — Tinggi | **Tinggi** — label oranye |
| Opsi Prioritas — Sedang | **Sedang** — label kuning |
| Opsi Prioritas — Rendah | **Rendah** — label biru |
| Label Stop Produksi | **Stop Produksi** |
| Opsi Stop Produksi — Ya | **Ya, mesin berhenti berproduksi** |
| Opsi Stop Produksi — Tidak | **Tidak, mesin masih bisa beroperasi** |
| Label Waktu Henti | **Waktu Henti Mulai** |
| Label Penyebab Awal | **Penyebab Awal (Praduga)** |
| Placeholder Penyebab | `Perkiraan penyebab kerusakan...` |
| Label Pelapor | **Dilaporkan Oleh** |
| **Tombol** | |
| Tombol Kirim | **KIRIM LAPORAN** |
| Tombol Simpan Draft | **SIMPAN DRAFT** |
| Tombol Batal | **BATAL** |
| **Dialog Konfirmasi Kirim** | |
| Pesan | "Laporan kerusakan akan segera diproses. Lanjutkan?" |
| Tombol Konfirmasi | **YA, KIRIM** |

---

## 9. Maintenance History

| Elemen | Teks |
|--------|------|
| Judul | **Riwayat Perawatan** |
| **Statistik Summary** | |
| Total Perawatan | **Total Perawatan:** 124 |
| Rata-rata per Bulan | **Rata-rata/Bulan:** 10 |
| Total WO Preventif | **WO Preventif:** 85 |
| Total WO Korektif | **WO Korektif:** 39 |
| Total Biaya | **Total Biaya:** Rp 45.750.000 |
| Rata-rata MTBF | **Rata-rata MTBF:** 320 jam |
| Rata-rata MTTR | **Rata-rata MTTR:** 4,5 jam |
| Downtime Total | **Total Downtime:** 48 jam |
| **Filter** | |
| Label Rentang Tanggal | **Rentang Tanggal** |
| Tombol Pilih Tanggal | **PILIH TANGGAL** |
| Label Filter Mesin | **Filter Mesin** |
| Placeholder Filter Mesin | `Semua mesin` |
| Label Filter Tipe | **Tipe Perawatan** |
| Opsi Filter Tipe — Semua | **Semua** |
| Opsi Filter Tipe — Preventif | **Preventif** |
| Opsi Filter Tipe — Korektif | **Korektif** |
| Opsi Filter Tipe — Breakdown | **Breakdown** |
| Label Filter Status | **Status** |
| Label Terapkan Filter | **TERAPKAN** |
| Label Reset Filter | **RESET** |
| **Empty State** | |
| Pesan | **Belum ada riwayat perawatan** |
| **Export** | |
| Tombol Export CSV | **EXPORT CSV** |
| Tombol Export PDF | **EXPORT PDF** |

---

## 10. Profile

| Elemen | Teks |
|--------|------|
| Judul | **Profil** |
| **Menu Items** | |
| Informasi Akun | **Informasi Akun** |
| Edit Profil | **Edit Profil** |
| Pengaturan Notifikasi | **Pengaturan Notifikasi** |
| Pengaturan Aplikasi | **Pengaturan Aplikasi** |
| Pusat Bantuan | **Pusat Bantuan** |
| FAQ | **FAQ** |
| Laporan & Statistik | **Laporan & Statistik** |
| Manajemen Pengguna | **Manajemen Pengguna** *(hanya Admin)* |
| Log Aktivitas | **Log Aktivitas** |
| Tentang Aplikasi | **Tentang Aplikasi** |
| Kebijakan Privasi | **Kebijakan Privasi** |
| Syarat & Ketentuan | **Syarat & Ketentuan** |
| **Toggle Labels** | |
| Notifikasi WO Baru | **Notifikasi WO Baru** |
| Notifikasi WO Deadline | **Pengingat Tenggat WO** |
| Notifikasi WO Selesai | **Notifikasi WO Selesai** |
| Notifikasi Laporan Baru | **Notifikasi Laporan Baru** |
| Notifikasi Email | **Notifikasi Email** |
| Notifikasi WhatsApp | **Notifikasi WhatsApp** |
| Mode Gelap | **Mode Gelap** |
| Getaran Notifikasi | **Getaran Notifikasi** |
| Suara Notifikasi | **Suara Notifikasi** |
| Biometrik Masuk | **Masuk dengan Sidik Jari** |
| **Logout Confirmation Dialog** | |
| Judul Dialog | **Keluar Akun** |
| Pesan Dialog | "Apakah Anda yakin ingin keluar dari akun SIGMA?" |
| Tombol Ya | **YA, KELUAR** |
| Tombol Batal | **BATAL** |
| **Versi** | |
| Label Versi | **Versi Aplikasi** |
| Nilai Versi | v1.0.0 |
| **Logout Button** | |
| Tombol Logout | **KELUAR** |
