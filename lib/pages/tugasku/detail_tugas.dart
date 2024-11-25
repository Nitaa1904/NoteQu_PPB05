import 'package:flutter/material.dart';
import 'package:notequ/design_system/styles/color.dart';

class DetailTugas extends StatelessWidget {
  final Map<String, String> task;

  const DetailTugas({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Detail Aktivitas',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            )),
      ),
      backgroundColor: ColorCollection.primary100,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${task['category']}',
              style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              task['title']!,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '${task['date']} ${task['time'] != '' ? '| ${task['time']}' : ''}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Catatan',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Detail tugas akan ditampilkan di sini. Tambahkan lebih banyak informasi sesuai kebutuhan.',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 48),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        'Tandai Selesai',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.black),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
