# CMMS SIGMA — Template Standar SOP Perawatan Mesin

## 1. Header Dokumen

```
┌─────────────────────────────────────────────────────────┐
│                 STANDAR OPERASIONAL PROSEDUR              │
│                   (STANDARD OPERATING PROCEDURE)          │
│                      PERAWATAN MESIN                      │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  Kode SOP     : [KODE_SOP]                               │
│  Nama SOP     : [NAMA_SOP — misal: SOP Perawatan Harian  │
│                  Mesin Press Hidrolik HP-01]              │
│  Nomor Revisi : [REVISI — misal: R00, R01, ...]         │
│  Tanggal      : [DD/MM/YYYY]                             │
│  Halaman      : [HAL] dari [TOTAL_HAL]                   │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## 2. Lembar Pengesahan

| Jabatan | Nama | Tanda Tangan | Tanggal |
|---------|------|:------------:|:-------:|
| **Dibuat Oleh** (Teknisi / Staff Maintenance) | | | |
| **Diperiksa Oleh** (Supervisor Maintenance) | | | |
| **Disetujui Oleh** (Kepala Departemen / Manager) | | | |

---

## 3. Tujuan

*Tuliskan tujuan dari SOP ini. Contoh:*

> Tujuan dari prosedur ini adalah untuk memastikan bahwa perawatan harian Mesin Press Hidrolik HP-01 dilakukan secara konsisten, aman, dan sesuai standar pabrikan sehingga umur pakai mesin optimal dan risiko kerusakan diminimalkan.

---

## 4. Ruang Lingkup

*Jelaskan cakupan SOP. Contoh:*

- Berlaku untuk: **[NAMA_MESIN / TIPE_MESIN / LOKASI]**
- Periode perawatan: **[Harian / Mingguan / Bulanan / Triwulan / Semester / Tahunan]**
- Dilaksanakan oleh: **[Operator / Teknisi / Pihak Ketiga]**

---

## 5. Referensi

*Daftar dokumen atau standar yang menjadi acuan. Contoh:*

| No | Referensi | Keterangan |
|:--:|-----------|------------|
| 1 | Manual Book Mesin Press Hidrolik HP-01 | Dokumen pabrikan |
| 2 | ISO 14224:2016 | Klasifikasi dan terminologi perawatan |
| 3 | [KODE_SOP_TERKAIT] | SOP terkait (jika ada) |
| 4 | [NOK / DRAWING / SKEMA] | Gambar teknis mesin |

---

## 6. Definisi dan Istilah

| Istilah | Definisi |
|---------|----------|
| **CMMS** | Computerized Maintenance Management System — sistem manajemen perawatan terkomputerisasi |
| **WO** | Work Order — perintah kerja perawatan |
| **OEE** | Overall Equipment Effectiveness — ukuran efektivitas mesin secara menyeluruh |
| **MTBF** | Mean Time Between Failures — rata-rata waktu antar kerusakan |
| **MTTR** | Mean Time To Repair — rata-rata waktu perbaikan |
| **LOTO** | Lockout Tagout — prosedur penguncian dan pemberian label sumber energi |
| **APD** | Alat Pelindung Diri |
| **APP** | Aplikasi CMMS SIGMA |

---

## 7. Alat dan Bahan / Perlengkapan

*Daftar alat, bahan, dan perlengkapan yang dibutuhkan.*

### 7.1 Alat

| No | Nama Alat | Spesifikasi | Jumlah |
|:--:|-----------|-------------|:------:|
| 1 | Toolset kunci pas / sock / L | [Ukuran] | 1 set |
| 2 | Obeng (+) dan (-) | [Ukuran] | 1 set |
| 3 | Multimeter digital | [Tipe] | 1 |
| 4 | Infrared thermometer | Rentang -50°C s.d. 380°C | 1 |
| 5 | Grease gun | [Tipe grease] | 1 |
| 6 | Lap / kain majun | | secukupnya |
| 7 | Senter / headlamp | | 1 |

### 7.2 Bahan

| No | Nama Bahan | Spesifikasi | Jumlah |
|:--:|-----------|-------------|:------:|
| 1 | Grease / Oli | [Spesifikasi pabrikan] | [Jumlah] |
| 2 | Pelumas rantai | [Merk/Tipe] | [Jumlah] |
| 3 | Kain lap bersih | | secukupnya |
| 4 | Contact cleaner | | 1 kaleng |

### 7.3 APD

| No | APD | Keterangan |
|:--:|:---:|------------|
| 1 | 🪖 Helm safety | Wajib |
| 2 | 🥽 Safety glasses | Wajib |
| 3 | 🧤 Sarung tangan | Kain / karet sesuai kebutuhan |
| 4 | 👞 Safety shoes | Wajib |
| 5 | 🦺 Rompi / vest | Jika diperlukan |

---

## 8. Prosedur / Langkah Kerja

### 8.1 Persiapan

| Langkah | Uraian Kegiatan | PIC | Durasi | Dokumen Terkait |
|:-------:|----------------|:---:|:------:|:---------------:|
| 1 | Pastikan mesin dalam keadaan **OFF / mati** dan sumber energi terputus (LOTO) | Operator | 5 menit | Checklist LOTO |
| 2 | Pasang rambu "*Mesin Dalam Perawatan*" di area kerja | Operator | 2 menit | SOP K3 |
| 3 | Siapkan alat dan bahan sesuai daftar di bagian 7 | Teknisi | 5 menit | — |
| 4 | Buka aplikasi CMMS SIGMA → pilih WO → **MULAI CHECKLIST** | Teknisi | 2 menit | WO di SIGMA |
| 5 | Lakukan briefing keselamatan singkat dengan tim | Teknisi | 3 menit | — |

### 8.2 Pelaksanaan

| Langkah | Uraian Kegiatan | PIC | Durasi | Dokumen Terkait |
|:-------:|----------------|:---:|:------:|:---------------:|
| 1 | Bersihkan permukaan mesin dari debu dan kotoran menggunakan lap bersih | Teknisi | 10 menit | Checklist #1 |
| 2 | Periksa kondisi visual seluruh komponen (kabel, selang, baut, seal) | Teknisi | 10 menit | Checklist #2-6 |
| 3 | Periksa level pelumas/oli melalui sight glass. Isi ulang jika di bawah batas minimum | Teknisi | 5 menit | Checklist #5 |
| 4 | Periksa ketegangan sabuk/belt. Kencangkan atau ganti jika aus | Teknisi | 10 menit | Checklist — |
| 5 | Uji fungsi tombol darurat (emergency stop) | Teknisi | 2 menit | Checklist #9 |
| 6 | Nyalakan mesin dan biarkan berjalan tanpa beban selama 3 menit | Teknisi | 3 menit | — |
| 7 | Dengarkan suara operasi — pastikan tidak ada suara abnormal | Teknisi | 3 menit | Checklist #3 |
| 8 | Periksa suhu operasi menggunakan infrared thermometer | Teknisi | 2 menit | Checklist #4 |
| 9 | Periksa getaran mesin secara manual | Teknisi | 2 menit | Checklist — |
| 10 | Matikan mesin dan lakukan pengencangan baut jika diperlukan | Teknisi | 5 menit | Checklist #7 |

### 8.3 Penyelesaian

| Langkah | Uraian Kegiatan | PIC | Durasi | Dokumen Terkait |
|:-------:|----------------|:---:|:------:|:---------------:|
| 1 | Bersihkan area kerja dan kembalikan alat ke tempat semula | Teknisi | 5 menit | — |
| 2 | Lepas rambu peringatan dan rambu LOTO | Operator | 2 menit | SOP LOTO |
| 3 | Isi hasil checklist di aplikasi CMMS SIGMA | Teknisi | 5 menit | Checklist SIGMA |
| 4 | Ambil foto dokumentasi (jika ada temuan) | Teknisi | 3 menit | Foto di SIGMA |
| 5 | Catat spare part yang digunakan (jika ada) | Teknisi | 3 menit | Spare Part SIGMA |
| 6 | Tulis catatan temuan dan tindakan di aplikasi | Teknisi | 5 menit | Catatan SIGMA |
| 7 | Set **SELESAIKAN** WO di aplikasi CMMS SIGMA | Teknisi | 1 menit | WO di SIGMA |
| 8 | Laporkan ke Supervisor jika ada temuan serius | Teknisi | 5 menit | — |

### 8.4 Verifikasi

| Langkah | Uraian Kegiatan | PIC | Durasi | Dokumen Terkait |
|:-------:|----------------|:---:|:------:|:---------------:|
| 1 | Supervisor membuka WO yang sudah selesai di aplikasi SIGMA | Supervisor | 2 menit | WO di SIGMA |
| 2 | Periksa kelengkapan checklist, foto, spare part, dan catatan | Supervisor | 5 menit | Semua data WO |
| 3 | Jika semua sesuai → **SETUJUI** (WO → Terverifikasi) | Supervisor | 1 menit | Verifikasi SIGMA |
| 4 | Jika ada ketidaksesuaian → **TOLAK** dan beri catatan revisi | Supervisor | 2 menit | Verifikasi SIGMA |
| 5 | Jika ditolak, Teknisi melakukan perbaikan sesuai catatan revisi | Teknisi | — | — |

---

## 9. Diagram Alir (Flowchart)

```
                    ┌──────────┐
                    │  MULAI   │
                    └────┬─────┘
                         │
                    ┌────▼─────┐
                    │ Persiapan│
                    │ & LOTO   │
                    └────┬─────┘
                         │
                    ┌────▼─────┐
                    │  Buka WO │
                    │ di SIGMA │
                    └────┬─────┘
                         │
                    ┌────▼─────┐
                    │ Inspeksi │
                    │ Visual   │
                    └────┬─────┘
                         │
                    ┌────▼─────┐
                    │ Operasi  │
                    │ & Uji    │
                    └────┬─────┘
                         │
              ┌──────────┴──────────┐
              │                     │
         ┌────▼─────┐         ┌────▼─────┐
         │   Ada    │         │  Normal  │
         │ Masalah? │         │  & Baik  │
         └────┬─────┘         └────┬─────┘
              │ Ya                 │ Tidak
              ▼                    │
        ┌──────────┐               │
        │ Catat &  │               │
        │ Perbaiki │               │
        └────┬─────┘               │
             │                     │
             └──────────┬──────────┘
                        │
                   ┌────▼─────┐
                   │ Isi      │
                   │ Checklist│
                   │ di SIGMA │
                   └────┬─────┘
                        │
                   ┌────▼─────┐
                   │ Foto &   │
                   │ Catatan  │
                   └────┬─────┘
                        │
                   ┌────▼─────┐
                   │ Selesai- │
                   │ kan WO   │
                   └────┬─────┘
                        │
                   ┌────▼─────┐
                   │ Verifikasi│
                   │ Supervisor│
                   └────┬─────┘
                        │
              ┌─────────┴─────────┐
              │                   │
         ┌────▼─────┐       ┌────▼─────┐
         │ Ditolak  │       │ Disetujui│
         │ → Revisi │       │ → Selesai│
         └──────────┘       └──────────┘
                                     │
                              ┌──────▼──────┐
                              │   SELESAI   │
                              └─────────────┘
```

---

## 10. Kriteria Kelulusan

| Item | Standar Kelulusan | Metode Pemeriksaan |
|------|------------------|:------------------:|
| Kebersihan mesin | Tidak ada debu/kotoran menempel | Visual |
| Suara operasi | Tidak ada suara berisik abnormal | Pendengaran |
| Suhu operasi | ≤ [TEMP_MAX] °C | Infrared thermometer |
| Getaran | Tidak terasa getaran berlebih | Manual / Vibration meter |
| Level oli/ pelumas | Di antara min dan max mark | Sight glass / dipstick |
| Kebocoran | Tidak ada kebocoran sama sekali | Visual |
| Tombol emergency stop | Berfungsi 100% | Uji fungsi |
| Baut dan pengikat | Kencang (sesuai torsi) | Kunci torsi |

> **Catatan**: Jika salah satu item *Tidak* memenuhi standar, item tersebut harus dicatat dan ditindaklanjuti sebelum WO diselesaikan.

---

## 11. Dokumen Terkait

| No | Kode Dokumen | Nama Dokumen |
|:--:|:------------:|--------------|
| 1 | FRM-SOP-001 | Form Checklist Perawatan Harian |
| 2 | FRM-SOP-002 | Form Laporan Kerusakan Mesin |
| 3 | FRM-SOP-003 | Logbook Mesin |
| 4 | SOP-K3-001 | SOP Lockout Tagout (LOTO) |
| 5 | SOP-K3-002 | SOP Tanggap Darurat |
| 6 | CAT-MESIN-001 | Katalog Spare Part Mesin Press Hidrolik |

---

## 12. Riwayat Perubahan

| Revisi | Tanggal | Deskripsi Perubahan | Disetujui Oleh |
|:------:|:-------:|--------------------|:--------------:|
| R00 | DD/MM/YYYY | Dokumen awal | [Nama] |
| R01 | DD/MM/YYYY | [Deskripsi perubahan] | [Nama] |
| R02 | DD/MM/YYYY | [Deskripsi perubahan] | [Nama] |

---

## 13. Catatan Tambahan

- Setiap penyimpangan dari prosedur ini harus dilaporkan dan dicatat.
- SOP ini akan ditinjau secara berkala setiap **[Frekuensi — misal: 1 tahun sekali]** atau ketika ada perubahan pada mesin / standar.
- Untuk kondisi darurat (breakdown), ikuti prosedur darurat terpisah: SOP-K3-002.
- Pastikan setiap langkah didokumentasikan di aplikasi CMMS SIGMA secara *real-time*.

---

*— Dokumen ini dikelola melalui CMMS SIGMA —*
*Untuk pertanyaan lebih lanjut, hubungi Departemen Maintenance.*
