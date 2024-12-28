import 'package:flutter/material.dart';
import 'package:notequ/design_system/styles/color.dart';
import 'package:notequ/design_system/styles/spacing.dart';
import 'package:notequ/design_system/widget/card/task_card.dart';
import 'package:notequ/pages/tugasku/detail_tugas.dart';
import 'package:notequ/pages/tugasku/custom_alert.dart';

class Tugasku extends StatefulWidget {
  // Tugasku({super.key});

  @override
  _TugaskuState createState() => _TugaskuState();
}

class _TugaskuState extends State<Tugasku> {
  final List<Map<String, String>> tasks = [];
  final List<Map<String, String>> completedTasks = [];

  void _addTask(Map<String, String> newTask) {
    setState(() {
      tasks.add(newTask);
    });
  }

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

  Widget _buildTaskList(List<Map<String, String>> taskList,
      {bool isCompleted = false}) {
    if (taskList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
              image: AssetImage('assets/images/Empty.png'),
              width: 170,
              height: 170,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: Spacing.md),
            Text(
              isCompleted
                  ? 'Belum ada tugas yang selesai'
                  : 'Tidak ada tugas mendatang.',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: ColorCollection.primary900,
              ),
            ),
            if (isCompleted) ...[
              const SizedBox(height: Spacing.md),
              const Text(
                'Checklist tugas kamu buat tandain \nkalau tugas kamu udah selesai',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: ColorCollection.neutral600,
                ),
              ),
            ]
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: taskList.length,
      itemBuilder: (context, index) {
        final task = taskList[index];
        return TugasCard(
          task: {
            'category': task['category'] ?? 'Kategori Tidak Diketahui',
            'title': task['title'] ?? 'Judul Tidak Diketahui',
            'date': task['date'] ?? 'Tanggal Tidak Diketahui',
            'time': task['time'] ?? 'Waktu Tidak Diketahui',
          },
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailTugas(task: task),
              ),
            );
          },
          trailing: IconButton(
            icon: Icon(
              isCompleted ? Icons.check_box : Icons.check_box_outline_blank,
              color: isCompleted ? Colors.green : ColorCollection.neutral500,
            ),
            onPressed: () {
              isCompleted ? _markAsIncomplete(task) : _markAsCompleted(task);
            },
          ),
        );
      },
    );
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
                                      width: 170,
                                      height: 170,
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
                                            color: Colors.green),
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
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return CustomAlert(
                onAddTask: (task) {
                  // Lakukan sesuatu dengan task yang ditambahkan
                  print(task);
                },
                categories: [
                  'Semua',
                  'Tugas Kuliah',
                  'Pribadi',
                  'Kerja',
                  'Hobi',
                  'Esport',
                  'Olahraga'
                ],
              );
            },
          );
        },
        backgroundColor: ColorCollection.primary900,
        child: const Icon(Icons.add, color: ColorCollection.primary100),
      ),
    );
  }
}
