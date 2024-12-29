import 'package:flutter/material.dart';
import 'package:notequ/pages/splash/splash_screen.dart';
// import 'package:notequ/pages/tugasku/home.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() {
  tz.initializeTimeZones();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NoteQu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: const SplashScreen(),
    );
  }
}

// class SplashScreen extends StatelessWidget {
//   const SplashScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Stack(
//         children: [
//           // Background circles
//           Positioned(
//             top: 50,
//             left: 30,
//             child: CircleAvatar(
//               radius: 70,
//               backgroundColor: Colors.white.withOpacity(0.1),
//             ),
//           ),
//           Positioned(
//             top: 200,
//             right: 20,
//             child: CircleAvatar(
//               radius: 90,
//               backgroundColor: Colors.white.withOpacity(0.1),
//             ),
//           ),
//           Positioned(
//             bottom: 100,
//             left: 50,
//             child: CircleAvatar(
//               radius: 120,
//               backgroundColor: Colors.white.withOpacity(0.1),
//             ),
//           ),
//           Positioned(
//             bottom: 200,
//             right: 80,
//             child: CircleAvatar(
//               radius: 60,
//               backgroundColor: Colors.white.withOpacity(0.1),
//             ),
//           ),
//           // Centered app name with GestureDetector
//           Center(
//             child: GestureDetector(
//               onTap: () {
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (context) => TaskListScreen()),
//                 );
//               },
//               child: Text(
//                 'NoteQu',
//                 style: TextStyle(
//                   fontSize: 60,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Kode halaman TaskListScreen tetap sama
// class TaskListScreen extends StatelessWidget {
//   final List<Map<String, String>> tasks = [
//     {
//       'category': 'Tugas Kuliah',
//       'title': 'Tugas Logika Matematika',
//       'date': '10-10',
//       'time': ''
//     },
//     {
//       'category': 'Pribadi',
//       'title': 'Jalan-jalan ke Rita Mall',
//       'date': '10-10',
//       'time': '13:00'
//     },
//     {
//       'category': 'Tugas Kuliah',
//       'title': 'Quiz PMPL',
//       'date': '11-10',
//       'time': '23:59'
//     },
//     {
//       'category': 'Tugas Kuliah',
//       'title': 'Quiz Pengalaman Pengguna',
//       'date': '12-10',
//       'time': '22:00'
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[200],
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         title: const Text('Tugasku'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Selamat pagi!\nBudiono Siregar 👋',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             const Text('Mau buat tugas apa hari ini?',
//                 style: TextStyle(fontSize: 16)),
//             const SizedBox(height: 16),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: tasks.length,
//                 itemBuilder: (context, index) {
//                   return GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) =>
//                               TaskDetailScreen(task: tasks[index]),
//                         ),
//                       );
//                     },
//                     child: Card(
//                       margin: const EdgeInsets.symmetric(vertical: 8),
//                       child: Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Row(
//                           children: [
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     tasks[index]['category']!,
//                                     style: const TextStyle(
//                                       fontSize: 12,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.grey,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 4),
//                                   Text(
//                                     tasks[index]['title']!,
//                                     style: const TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                   const SizedBox(height: 4),
//                                   Text(
//                                     '${tasks[index]['date']} | ${tasks[index]['time']}',
//                                     style: const TextStyle(color: Colors.grey),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             const Icon(Icons.check_box_outline_blank,
//                                 color: Colors.grey),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Tugasku'),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.category), label: 'Kategori'),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.calendar_today), label: 'Kalender'),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {},
//         backgroundColor: Colors.black,
//         child: const Icon(Icons.add, color: Colors.white),
//       ),
//     );
//   }
// }

// class TaskDetailScreen extends StatelessWidget {
//   final Map<String, String> task;

//   const TaskDetailScreen({super.key, required this.task});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         title: const Text('Detail Tugas'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               task['title']!,
//               style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Kategori: ${task['category']}',
//               style: const TextStyle(fontSize: 16, color: Colors.grey),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Tanggal: ${task['date']} ${task['time'] != '' ? '| ${task['time']}' : ''}',
//               style: const TextStyle(fontSize: 16, color: Colors.grey),
//             ),
//             const SizedBox(height: 16),
//             const Text(
//               'Deskripsi tugas:',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             const Text(
//               'Detail tugas akan ditampilkan di sini. Tambahkan lebih banyak informasi sesuai kebutuhan.',
//               style: TextStyle(fontSize: 16),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
