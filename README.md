# NoteQu - To-Do List & Schedule Planner

**Pemrograman Perangkat Bergerak**  
**Universitas Telkom, Purwokerto**

---

## 🎯 **Deskripsi Proyek**

**NoteQu** adalah aplikasi digital yang dirancang untuk membantu pengguna mengelola tugas dan jadwal harian. Dengan antarmuka yang user-friendly, aplikasi ini mempermudah pengguna untuk:

- **Menambahkan, mengedit, dan menghapus tugas.**
- **Menetapkan tenggat waktu dan pengingat.**
- **Mengategorikan tugas berdasarkan tipe aktivitas.**
- **Meningkatkan produktivitas dan pengorganisasian.**

Aplikasi ini merupakan redesign dari alat perencana jadwal dan to-do list yang sudah ada, dengan fokus pada kesederhanaan, efisiensi, dan estetika.

---

## 🛠 **Fitur Utama**

1. **Kalender Tugas**  
   Menampilkan tugas berdasarkan tanggal dengan antarmuka kalender interaktif.

   - Tugas ditampilkan berdasarkan kategori dan waktu.
   - Notifikasi khusus untuk tenggat waktu.

2. **Kategori Tugas**  
   Filter tugas berdasarkan kategori seperti:

   - Tugas Kuliah
   - Pribadi
   - Kerja
   - Hobi, Esport, dan lainnya.

3. **Profil Pengguna**  
   Halaman profil sederhana untuk menampilkan informasi pengguna.

---

## 📂 **Struktur Proyek**

```plaintext
lib/
├── design_system/
│   ├── styles/
│   │   └── color.dart
│   └── widget/
│       ├── card/
│       │   └── task_card.dart
│       └── bottomnav/
│           └── bottom_nav.dart
├── pages/
│   ├── kalender/
│   │   └── kalender.dart
│   ├── kategori/
│   │   └── kategori.dart
│   ├── profil/
│   │   └── profil.dart
│   ├── tugasku/
│   │   ├── detail_tugas.dart
│   │   └── home.dart
└── main.dart
```

---

## 🚀 **Teknologi yang Digunakan**

- **Flutter**: Framework utama untuk pengembangan aplikasi.
- **Dart**: Bahasa pemrograman inti untuk Flutter.
- **TableCalendar**: Paket untuk menampilkan kalender.
- **Widget Custom**: Komponen seperti `TaskCard` untuk tampilan tugas.

---

## 🖌 **Proses Desain**

Aplikasi ini dirancang dengan pendekatan **user-centered design** melalui prototipe di Figma.  
📎 **Link Prototipe Figma**: [Klik di sini](https://www.figma.com/design/VMO0rkWHvzIzm1Dv4aFazc/PPB-05---NoteQu?node-id=356-2&t=0ffXqHHk9ImtoJYs-1)

---

## 👥 **Anggota Kelompok**

- **Nita Fitrotul Mar'ah** (2211104005)
- **Althafia Defiyandrea Laskanadya W** (2211104011)
- **Muhammad Agam Nasywaan** (2211104085)

---

## 📖 **Cara Menggunakan Aplikasi**

1. Clone proyek ini:
   ```bash
   git clone https://github.com/username/NoteQu.git
   ```
2. Masuk ke direktori proyek:
   ```bash
   cd NoteQu
   ```
3. Jalankan aplikasi:
   ```bash
   flutter run
   ```

---

## 📋 **Lisensi**

Aplikasi ini dibuat untuk keperluan akademik dalam mata kuliah **Pemrograman Perangkat Bergerak** dan tidak digunakan untuk tujuan komersial.

**© Kelompok 5, Universitas Telkom Purwokerto, 2024.**
