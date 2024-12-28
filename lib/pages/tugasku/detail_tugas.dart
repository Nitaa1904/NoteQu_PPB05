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
        title: const Text(
          'Detail Aktivitas',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: ColorCollection.primary900,
        foregroundColor: Colors.white,
      ),
      backgroundColor: ColorCollection.primary100,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kategori
            Text(
              task['category']?.isNotEmpty == true
                  ? task['category']!
                  : 'Tidak Ada Kategori',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // Judul Tugas
            Text(
              task['title']?.isNotEmpty == true
                  ? task['title']!
                  : 'Judul tidak tersedia',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // Tanggal dan Waktu
            Text(
              '${task['date'] ?? ''} ${task['time'] != null && task['time']!.isNotEmpty ? '| ${task['time']}' : ''}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),

            // Catatan Tugas
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Catatan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  task['note']?.isNotEmpty == true
                      ? task['note']!
                      : 'Tidak ada catatan untuk tugas ini.',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const Spacer(),

            // Tombol Tandai Selesai
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, true); // Kirim status selesai
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black,
                      ),
                      child: const Text(
                        'Tandai Selesai',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
