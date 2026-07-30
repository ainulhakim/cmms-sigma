# CMMS SIGMA — Panduan Deploy & Setup

## 📱 Persiapan Lingkungan Development

### 1. Install Flutter SDK
```bash
# Download Flutter SDK
cd ~
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.22.2-stable.tar.xz
tar xf flutter_linux_3.22.2-stable.tar.xz

# Tambahkan ke PATH (tambahkan ke ~/.bashrc)
echo 'export PATH="$PATH:$HOME/flutter/bin"' >> ~/.bashrc
source ~/.bashrc

# Verifikasi
flutter doctor
```

### 2. Install Android Studio
- Download dari https://developer.android.com/studio
- Install Android SDK (min SDK 21 untuk kompatibilitas luas)
- Setup emulator Android atau sambungkan device fisik via USB debugging

### 3. Clone Project
```bash
git clone https://github.com/ainulhakim/cmms-sigma.git
cd cmms-sigma
flutter pub get
```

---

## ☁️ Setup Supabase

### 1. Buat Project Supabase
1. Buka https://supabase.com → sign up / login
2. Klik **New Project**
3. Isi:
   - **Name:** cmms-sigma
   - **Database Password:** (simpan aman)
   - **Region:** Southeast Asia (Singapore) — biar cepet
4. Tunggu provisioning selesai (~2 menit)

### 2. Jalankan SQL Migration
1. Buka Supabase dashboard → **SQL Editor**
2. Copy paste isi file `supabase/migrations/00001_initial_schema.sql`
3. Klik **Run**
4. Verifikasi: cek tabel2 sudah muncul di **Table Editor**

### 3. Setup Auth
1. **Authentication → Settings**
2. Pastikan email/password auth diaktifkan (default)
3. **Settings → API**
4. Catat:
   - **Project URL** (https://xxx.supabase.co)
   - **anon public key** (eyJxxx...)

### 4. Setup Storage (untuk foto)
1. **Storage** → **Create bucket**
   - **Name:** `work_order_photos`
   - **Public bucket:** ✅ centang
   - **Allowed MIME types:** image/jpeg, image/png, image/webp
2. **Create bucket** — `machine_photos` (public)
3. **Create bucket** — `profile_photos` (public)

### 5. Setup RLS Policy untuk Storage
Buka SQL Editor dan jalankan:
```sql
-- Bucket work_order_photos
CREATE POLICY "Public Access" ON storage.objects
  FOR ALL USING (bucket_id = 'work_order_photos')
  WITH CHECK (bucket_id = 'work_order_photos');

CREATE POLICY "Public Access" ON storage.objects
  FOR ALL USING (bucket_id = 'machine_photos')
  WITH CHECK (bucket_id = 'machine_photos');

CREATE POLICY "Public Access" ON storage.objects
  FOR ALL USING (bucket_id = 'profile_photos')
  WITH CHECK (bucket_id = 'profile_photos');
```

---

## 🔥 Setup Firebase (Notifikasi)

### 1. Buat Firebase Project
1. Buka https://console.firebase.google.com
2. **Add project** → pilih project Supabase atau buat baru
3. **Add app** → Android
4. Isi package name: `com.sigma.cmms`
5. Download `google-services.json`

### 2. Konfigurasi Android
```bash
# Letakkan google-services.json di:
cp ~/Downloads/google-services.json /tmp/cmms-sigma/android/app/
```

### 3. Firebase Cloud Messaging
1. Di Firebase console → **Cloud Messaging**
2. Dapatkan **Server key** untuk kirim notifikasi dari backend
3. Di Supabase dashboard → **Project Settings** → **API** → tambahkan FCM Server key untuk notifikasi

---

## 🚀 Menjalankan Aplikasi

### Mode Development
```bash
cd /tmp/cmms-sigma

flutter run --dart-define=SUPABASE_URL=https://YOUR_PROJECT.supabase.co \
           --dart-define=SUPABASE_ANON_KEY=eyJYOUR_ANON_KEY
```

### Build APK
```bash
# Build APK release
flutter build apk --release \
  --dart-define=SUPABASE_URL=https://YOUR_PROJECT.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=eyJYOUR_ANON_KEY

# APK ada di: build/app/outputs/flutter-apk/app-release.apk
```

### Build App Bundle (Play Store)
```bash
flutter build appbundle --release \
  --dart-define=SUPABASE_URL=https://YOUR_PROJECT.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=eyJYOUR_ANON_KEY
```

---

## 👤 User Awal (Seed)

Setelah migration dijalankan, daftarkan user awal via aplikasi:
1. Buka aplikasi → klik **Daftar**
2. Buat akun **Admin** pertama
3. Di Supabase **Table Editor** → `profiles` → ubah role user jadi `admin`

Atau via SQL:
```sql
-- Daftar user via aplikasi dulu, lalu:
UPDATE profiles SET role = 'admin'
WHERE id = (SELECT id FROM auth.users WHERE email = 'admin@sigma.com');
```

---

## 📊 Struktur File Lengkap

```
cmms-sigma/
├── lib/
│   ├── main.dart                     # Entry point + routes
│   ├── config/
│   │   ├── app_config.dart           # Supabase URL, keys
│   │   ├── theme.dart                # Material Design 3 theme
│   │   ├── routes.dart               # Route paths
│   │   └── constants.dart            # Enums, status, format
│   ├── models/                       # 10 model files
│   ├── providers/                    # 6 provider files
│   ├── screens/                      # 10 screen files
│   └── services/                     # 5 service files
├── supabase/
│   └── migrations/
│       └── 00001_initial_schema.sql  # Full PostgreSQL schema
├── docs/
│   ├── copywriting/                  # Copy, notif, panduan
│   └── ux/                           # Design specs + wireframe
├── pubspec.yaml
└── README.md
```

---

## ⚡ Troubleshooting

| Masalah | Solusi |
|---------|--------|
| `flutter pub get` error | Jalankan `flutter clean` lalu `flutter pub get` ulang |
| Login gagal | Pastikan SUPABASE_URL dan SUPABASE_ANON_KEY benar |
| Foto tidak muncul | Cek storage bucket sudah public |
| Notifikasi tidak datang | Pastikan google-services.json benar, rebuild |
| Sync offline error | Cek koneksi internet, cek sync_queue di SQLite |
| APK crash | Jalankan `flutter build apk --debug` dulu untuk lihat log |
