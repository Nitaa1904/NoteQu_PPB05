import 'package:flutter/material.dart';
import 'package:notequ/design_system/styles/color.dart';
import 'package:notequ/design_system/styles/spacing.dart';
import 'package:notequ/design_system/widget/card/task_card.dart';
import 'package:notequ/pages/tugasku/detail_tugas.dart';

class Tugasku extends StatefulWidget {
  Tugasku({super.key});

  @override
  State<Tugasku> createState() => _TugaskuState();
}

class _TugaskuState extends State<Tugasku> {
  // Daftar tugas belum selesai
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

  // Daftar tugas sudah selesai
  final List<Map<String, String>> completedTasks = [];

  void _markAsCompleted(Map<String, String> task) {
    setState(() {
      tasks.remove(task);
      completedTasks.add(task);
    });
  }

  void _markAsIncomplete(Map<String, String> task) {
    setState(() {
      completedTasks.remove(task);
      tasks.add(task);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorCollection.primary100,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selamat Datang!',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: ColorCollection.primary900),
            ),
            const Text('Mau buat tugas apa hari ini?',
                style:
                    TextStyle(fontSize: 14, color: ColorCollection.neutral600)),
            const SizedBox(height: 32),
            Expanded(
              child: DefaultTabController(
                length: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TabBar(
                      labelColor: ColorCollection.primary900,
                      unselectedLabelColor: ColorCollection.neutral500,
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      unselectedLabelStyle:
                          TextStyle(fontWeight: FontWeight.normal),
                      indicator: UnderlineTabIndicator(
                        borderSide: BorderSide(
                          color: ColorCollection.primary900,
                          width: 3.0,
                        ),
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      tabs: [
                        Tab(
                          child: Text('Tugas Mendatang'),
                        ),
                        Tab(text: 'Sudah Selesai'),
                      ],
                    ),
                    const SizedBox(
                      height: Spacing.lg,
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          // Tab Tugas Mendatang
                          tasks.isEmpty
                              ? const Center(
                                  child: Text('Tidak ada tugas mendatang.'))
                              : ListView.builder(
                                  itemCount: tasks.length,
                                  itemBuilder: (context, index) {
                                    return TugasCard(
                                      task: tasks[index],
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DetailTugas(task: tasks[index]),
                                          ),
                                        );
                                      },
                                      trailing: IconButton(
                                        icon: const Icon(
                                            Icons.check_box_outline_blank,
                                            color: ColorCollection.neutral500),
                                        onPressed: () {
                                          _markAsCompleted(tasks[index]);
                                        },
                                      ),
                                    );
                                  },
                                ),
                          // Tab Sudah Selesai
                          completedTasks.isEmpty
                              ? const Center(
                                  child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image(
                                      image:
                                          AssetImage('assets/images/Empty.png'),
                                      width: 350,
                                      height: 350,
                                      fit: BoxFit.contain,
                                    ),
                                    SizedBox(height: Spacing.md),
                                    Text(
                                      'Belum ada tugas yang selesai',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: ColorCollection.primary900),
                                    ),
                                    SizedBox(height: Spacing.md),
                                    Text(
                                      'Checklist tugas kamu buat tandain \nkalau tugas kamu udah selesai',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: ColorCollection.neutral600),
                                    ),
                                  ],
                                ))
                              : ListView.builder(
                                  itemCount: completedTasks.length,
                                  itemBuilder: (context, index) {
                                    return TugasCard(
                                      task: completedTasks[index],
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => DetailTugas(
                                                task: completedTasks[index]),
                                          ),
                                        );
                                      },
                                      trailing: IconButton(
                                        icon: const Icon(Icons.check_box,
                                            color: ColorCollection.accentGreen),
                                        onPressed: () {
                                          _markAsIncomplete(
                                              completedTasks[index]);
                                        },
                                      ),
                                    );
                                  },
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {},
        backgroundColor: ColorCollection.primary900,
        child: const Icon(Icons.add, color: ColorCollection.primary100),
      ),
    );
  }
}
