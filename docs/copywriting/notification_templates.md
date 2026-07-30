# CMMS SIGMA — FCM Notification Templates

## 1. WO Assigned (WO Ditugaskan)

| Elemen | Detail |
|--------|--------|
| **Judul** | Work Order Baru Ditugaskan 🔧 |
| **Badge** | WO Baru |
| **Body** | "WO #{nomor_wo} — {nama_mesin} telah ditugaskan kepada Anda. Prioritas: {prioritas}. Tenggat: {tenggat_waktu}." |
| **Channel ID** | wo_assigned |
| **Priority** | High |
| **Sound** | default |
| **Action** | Buka → WO Detail |

**Contoh:**
> **Work Order Baru Ditugaskan 🔧**
> WO #WO-2026-0842 — Mesin Press Hidrolik telah ditugaskan kepada Anda. Prioritas: Tinggi. Tenggat: 01/08/2026.

---

## 2. WO Due Today (WO Jatuh Tempo Hari Ini)

| Elemen | Detail |
|--------|--------|
| **Judul** | WO Jatuh Tempo Hari Ini ⏰ |
| **Badge** | Tenggat |
| **Body** | "WO #{nomor_wo} — {nama_mesin} jatuh tempo hari ini. Segera selesaikan pekerjaan." |
| **Channel ID** | wo_due_today |
| **Priority** | High |
| **Sound** | default |
| **Action** | Buka → WO List (filter: Berjalan) |

**Contoh:**
> **WO Jatuh Tempo Hari Ini ⏰**
> WO #WO-2026-0839 — Kompresor Udara jatuh tempo hari ini. Segera selesaikan pekerjaan.

---

## 3. WO Due Soon (WO Mendekati Tenggat — H-1)

| Elemen | Detail |
|--------|--------|
| **Judul** | Pengingat WO Mendekati Tenggat |
| **Badge** | Pengingat |
| **Body** | "WO #{nomor_wo} — {nama_mesin} akan jatuh tempo besok. Pastikan pekerjaan segera diselesaikan." |
| **Channel ID** | wo_due_soon |
| **Priority** | Normal |
| **Sound** | default |
| **Action** | Buka → WO Detail |

**Contoh:**
> **Pengingat WO Mendekati Tenggat**
> WO #WO-2026-0840 — Conveyor Belt akan jatuh tempo besok. Pastikan pekerjaan segera diselesaikan.

---

## 4. WO Overdue (WO Terlambat)

| Elemen | Detail |
|--------|--------|
| **Judul** | WO Terlambat! 🚨 |
| **Badge** | Terlambat |
| **Body** | "WO #{nomor_wo} — {nama_mesin} telah melewati tenggat waktu. Segera ambil tindakan." |
| **Channel ID** | wo_overdue |
| **Priority** | High |
| **Sound** | alarm |
| **Action** | Buka → WO List (filter: Terbuka) |

**Contoh:**
> **WO Terlambat! 🚨**
> WO #WO-2026-0835 — Mesin CNC terlambat {jumlah_hari} hari. Segera ambil tindakan.

---

## 5. WO Completed (WO Selesai — Menunggu Verifikasi)

| Elemen | Detail |
|--------|--------|
| **Judul** | WO Selesai — Menunggu Verifikasi ✅ |
| **Badge** | Selesai |
| **Body** | "WO #{nomor_wo} — {nama_mesin} telah diselesaikan oleh {nama_teknisi}. Silakan lakukan verifikasi." |
| **Channel ID** | wo_completed |
| **Priority** | High |
| **Sound** | default |
| **Action** | Buka → WO Detail (Verifikasi) |

**Contoh:**
> **WO Selesai — Menunggu Verifikasi ✅**
> WO #WO-2026-0838 — Pompa Sentrifugal telah diselesaikan oleh Budi Santoso. Silakan lakukan verifikasi.

---

## 6. WO Verified (WO Diverifikasi / Disetujui)

| Elemen | Detail |
|--------|--------|
| **Judul** | WO Telah Diverifikasi ✅ |
| **Badge** | Terverifikasi |
| **Body** | "WO #{nomor_wo} — {nama_mesin} telah diverifikasi dan disetujui oleh {nama_supervisor}." |
| **Channel ID** | wo_verified |
| **Priority** | Normal |
| **Sound** | default |
| **Action** | Buka → WO Detail |

**Contoh:**
> **WO Telah Diverifikasi ✅**
> WO #WO-2026-0838 — Pompa Sentrifugal telah diverifikasi dan disetujui oleh Suparman.

---

## 7. WO Rejected (WO Ditolak)

| Elemen | Detail |
|--------|--------|
| **Judul** | WO Ditolak ❌ |
| **Badge** | Ditolak |
| **Body** | "WO #{nomor_wo} — {nama_mesin} ditolak saat verifikasi. Alasan: {alasan_penolakan}. Segera lakukan perbaikan." |
| **Channel ID** | wo_rejected |
| **Priority** | High |
| **Sound** | default |
| **Action** | Buka → WO Detail |

**Contoh:**
> **WO Ditolak ❌**
> WO #WO-2026-0838 — Pompa Sentrifugal ditolak saat verifikasi. Alasan: Kebocoran masih terdeteksi. Segera lakukan perbaikan.

---

## 8. Breakdown Reported (Laporan Kerusakan Baru)

| Elemen | Detail |
|--------|--------|
| **Judul** | Laporan Kerusakan Baru 🚨 |
| **Badge** | Darurat |
| **Body** | "{nama_mesin} — {deskripsi_singkat}. Prioritas: {prioritas}. Stop Produksi: {stop_produksi}." |
| **Channel ID** | breakdown_reported |
| **Priority** | High |
| **Sound** | alarm |
| **Action** | Buka → Breakdown Detail |

**Contoh:**
> **Laporan Kerusakan Baru 🚨**
> Mesin Press Hidrolik — Mesin tidak mau menyala. Prioritas: Darurat. Stop Produksi: Ya.

---

## 9. Spare Part Low Stock (Stok Spare Part Menipis)

| Elemen | Detail |
|--------|--------|
| **Judul** | Stok Spare Part Menipis ⚠️ |
| **Badge** | Stok |
| **Body** | "{nama_part} (Kode: {kode_part}) tersisa {jumlah} {satuan}. Segera lakukan pengadaan." |
| **Channel ID** | stock_warning |
| **Priority** | Normal |
| **Sound** | default |
| **Action** | Buka → Inventory |

**Contoh:**
> **Stok Spare Part Menipis ⚠️**
> Bearing SKF-6205 (Kode: BRG-6205) tersisa 2 pcs. Segera lakukan pengadaan.

---

## 10. Schedule Reminder (Pengingat Jadwal — H-7 / H-1 / H-0)

| Elemen | Detail |
|--------|--------|
| **Judul** | Pengingat Jadwal Perawatan 📅 |
| **Badge** | Jadwal |
| **Body** | "Perawatan {tipe_perawatan} untuk {nama_mesin} dijadwalkan pada {tanggal_jadwal}. WO akan segera dibuat." |
| **Channel ID** | schedule_reminder |
| **Priority** | Normal |
| **Sound** | default |
| **Action** | Buka → Dashboard |

**Contoh (H-1):**
> **Pengingat Jadwal Perawatan 📅**
> Perawatan Preventif untuk Chiller Unit dijadwalkan besok, 31/07/2026. WO akan segera dibuat.

---

## Ringkasan Channel ID & Sound

| Channel ID | Deskripsi | Priority | Sound |
|-----------|-----------|----------|-------|
| `wo_assigned` | WO baru ditugaskan | High | default |
| `wo_due_today` | WO jatuh tempo hari ini | High | default |
| `wo_due_soon` | WO mendekati tenggat | Normal | default |
| `wo_overdue` | WO terlambat | High | alarm |
| `wo_completed` | WO selesai, tunggu verifikasi | High | default |
| `wo_verified` | WO diverifikasi | Normal | default |
| `wo_rejected` | WO ditolak | High | default |
| `breakdown_reported` | Laporan kerusakan baru | High | alarm |
| `stock_warning` | Stok spare part menipis | Normal | default |
| `schedule_reminder` | Pengingat jadwal | Normal | default |

## Ikon Notifikasi

| Tipe | Nama Ikon (Android) |
|------|-------------------|
| WO Assigned | `ic_notif_wo_new` |
| Overdue / Breakdown | `ic_notif_emergency` |
| Completed / Verified | `ic_notif_success` |
| Reminder | `ic_notif_reminder` |
| Stock | `ic_notif_stock` |
