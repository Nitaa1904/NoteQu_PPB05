import 'package:flutter/material.dart';
import 'package:notequ/design_system/styles/color.dart';
import 'package:notequ/design_system/styles/spacing.dart';
import 'package:notequ/design_system/widget/card/task_card.dart';
import 'package:notequ/pages/tugasku/custom_alert.dart';
import 'package:notequ/pages/tugasku/detail_tugas.dart';

class Tugasku extends StatefulWidget {
  final List<Map<String, String>> tasks;
  final List<Map<String, String>> completedTasks;
  final void Function(Map<String, String>) addTask;
  final void Function(Map<String, String>) markAsCompleted;
  final void Function(Map<String, String>) markAsIncomplete;

  const Tugasku({
    Key? key,
    required this.tasks,
    required this.completedTasks,
    required this.addTask,
    required this.markAsCompleted,
    required this.markAsIncomplete,
  }) : super(key: key);

  @override
  _TugaskuState createState() => _TugaskuState();
}

class _TugaskuState extends State<Tugasku> {
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
                color: ColorCollection.primary900,
              ),
            ),
            const Text(
              'Mau buat tugas apa hari ini?',
              style: TextStyle(fontSize: 14, color: ColorCollection.neutral600),
            ),
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
                      indicator: UnderlineTabIndicator(
                        borderSide: BorderSide(
                          color: ColorCollection.primary900,
                          width: 3.0,
                        ),
                      ),
                      tabs: [
                        Tab(text: 'Tugas Mendatang'),
                        Tab(text: 'Sudah Selesai'),
                      ],
                    ),
                    const SizedBox(height: Spacing.lg),
                    Expanded(
                      child: TabBarView(
                        children: [
                          _buildTaskList(widget.tasks, isCompleted: false),
                          _buildTaskList(widget.completedTasks,
                              isCompleted: true),
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
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return CustomAlert(
                onAddTask: widget.addTask,
                categories: [
                  'Semua',
                  'Tugas Kuliah',
                  'Pribadi',
                  'Kerja',
                  'Hobi',
                  'Esport',
                  'Olahraga',
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

  Widget _buildTaskList(List<Map<String, String>> taskList,
      {required bool isCompleted}) {
    if (taskList.isEmpty) {
      return Center(
        child: Text(
          isCompleted
              ? 'Belum ada tugas yang selesai.'
              : 'Tidak ada tugas mendatang.',
          style:
              const TextStyle(fontSize: 16, color: ColorCollection.neutral600),
        ),
      );
    }
    return ListView.builder(
      itemCount: taskList.length,
      itemBuilder: (context, index) {
        final task = taskList[index];
        return TugasCard(
          task: task,
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
              isCompleted
                  ? widget.markAsIncomplete(task)
                  : widget.markAsCompleted(task);
            },
          ),
        );
      },
    );
  }
}
