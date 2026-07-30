# CMMS SIGMA 📱

**Computerized Maintenance Management System** — Aplikasi Android untuk penjadwalan & pelaksanaan perawatan mesin pabrik.

## 🎯 Fitur MVP

| Fitur | Status |
|-------|--------|
| Login & Auth (Supabase) | ✅ |
| Dashboard KPI | ✅ |
| Data Master Mesin | ✅ |
| Detail Mesin + QR Code | ✅ |
| Work Order Management | ✅ |
| Checklist Perawatan | ✅ |
| Foto Sebelum/Sesudah | ✅ |
| Laporan Kerusakan (Corrective) | ✅ |
| Riwayat Perawatan | ✅ |
| Profil & Pengaturan | ✅ |
| Mode Offline (SQLite) | ✅ |
| Sinkronisasi Data | ✅ |

## 🛠️ Tech Stack

- **Frontend**: Flutter (Dart) + Material Design 3
- **Backend**: Supabase (PostgreSQL + Auth + Storage)
- **Database Cloud**: PostgreSQL via Supabase
- **Database Lokal**: SQLite (sqflite)
- **State Management**: Provider
- **Notifikasi**: Firebase Cloud Messaging
- **QR Code**: qr_code_scanner

## 📁 Struktur Project

```
cmms-sigma/
├── lib/
│   ├── main.dart
│   ├── config/         # Theme, routes, constants, app config
│   ├── models/         # Dart model classes (10 files)
│   ├── providers/      # State management (6 providers)
│   ├── screens/        # UI screens (10 screens)
│   └── services/       # Supabase, SQLite, Sync, Auth, Notification
├── supabase/
│   └── migrations/     # SQL schema + RLS policies
└── pubspec.yaml
```

## 🚀 Cara Menjalankan

### Prasyarat
- Flutter SDK 3.x ([install](https://docs.flutter.dev/get-started/install))
- Android Studio / VS Code
- Akun Supabase ([supabase.com](https://supabase.com))
- Firebase project (untuk notifikasi)

### 1. Clone & Install
```bash
git clone https://github.com/ainulhakim/cmms-sigma.git
cd cmms-sigma
flutter pub get
```

### 2. Setup Supabase
1. Buat project baru di [Supabase](https://supabase.com)
2. Buka SQL Editor, jalankan isi `supabase/migrations/00001_initial_schema.sql`
3. Catat `Supabase URL` dan `anon key` dari Settings → API

### 3. Jalankan Aplikasi
```bash
flutter run --dart-define=SUPABASE_URL=https://xxx.supabase.co \
           --dart-define=SUPABASE_ANON_KEY=eyJxxx
```

## 👥 Hak Akses

| Role | Kemampuan |
|------|-----------|
| **Admin** | Kelola semua data, pengguna, konfigurasi |
| **Supervisor** | Buat jadwal, tugaskan teknisi, verifikasi |
| **Teknisi** | Lihat tugas, isi checklist, upload foto |
| **Operator** | Lapor kerusakan, lihat status |

## 📊 Tahap Pengembangan

- ✅ **Tahap 1 — MVP** (Selesai)
- ⏳ **Tahap 2 — Operasional** (Menyusul)
- ⏳ **Tahap 3 — Integrasi Mesin** (Menyusul)

## 📄 Lisensi

MIT
