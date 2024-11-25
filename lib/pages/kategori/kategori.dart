import 'package:flutter/material.dart';
import 'package:notequ/design_system/styles/color.dart';
import 'package:notequ/design_system/widget/card/task_card.dart';
import 'package:notequ/pages/tugasku/detail_tugas.dart';

class Kategori extends StatelessWidget {
  final List<String> categories = [
    'Semua',
    'Tugas Kuliah',
    'Pribadi',
    'Kerja',
    'Hobi',
    'Esport',
    'Olahraga',
  ];

  final List<Map<String, String>> tasks = [
    {
      'category': 'Tugas Kuliah',
      'title': 'Tugas Logika Matematika',
      'date': '10-10',
      'time': '23:59'
    },
    {
      'category': 'Pribadi',
      'title': 'Jalan-jalan ke Rita Mall',
      'date': '10-10',
      'time': '13:00'
    },
    {
      'category': 'Tugas Kuliah',
      'title': 'Quiz PMPL',
      'date': '11-10',
      'time': '23:59'
    },
    {
      'category': 'Tugas Kuliah',
      'title': 'Quiz Pengalaman Pengguna',
      'date': '12-10',
      'time': '22:00'
    },
  ];

  Kategori({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Kategori",
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: ColorCollection.primary900),
        ),
        elevation: 4.0,
        shadowColor: ColorCollection.primary900.withOpacity(0.3),
        backgroundColor: ColorCollection.primary100,
      ),
      backgroundColor: ColorCollection.primary100,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              height: 32,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Chip(
                      label: Text(
                        categories[index],
                        style:
                            const TextStyle(color: ColorCollection.primary100),
                      ),
                      backgroundColor: ColorCollection.primary900,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return TugasCard(
                    task: tasks[index],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailTugas(
                            task: tasks[index],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
