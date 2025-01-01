import 'package:flutter/material.dart';
import 'package:notequ/design_system/styles/color.dart';
import 'package:notequ/design_system/styles/spacing.dart';
import 'package:notequ/design_system/widget/card/task_card.dart';
import 'package:notequ/pages/tugasku/custom_alert.dart';
import 'package:notequ/pages/tugasku/detail_tugas.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Tugasku extends StatefulWidget {
  final SupabaseClient client;

  const Tugasku({Key? key, required this.client}) : super(key: key);

  @override
  _TugaskuState createState() => _TugaskuState();
}

class _TugaskuState extends State<Tugasku> {
  List<Map<String, String>> tasks = [];
  List<Map<String, String>> completedTasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final fetchedTasks = await fetchTasks(status: 'pending');
    final fetchedCompletedTasks = await fetchTasks(status: 'completed');

    setState(() {
      tasks = fetchedTasks;
      completedTasks = fetchedCompletedTasks;
    });
  }

  Future<List<Map<String, String>>> fetchTasks({String? status}) async {
    final response = await widget.client
        .from('tasks')
        .select()
        .eq('status', status ?? 'pending')
        .order('date', ascending: true)
        .execute();

    if (response.status != 200 || response.data == null) {
      print('Error fetching tasks: Status ${response.status}');
      return [];
    }

    return (response.data as List<dynamic>).map((task) {
      return {
        'id': task['id'].toString(),
        'title': task['title'].toString(),
        'category': task['category'].toString(),
        'date': task['date'].toString(),
        'time': task['time'].toString(),
        'description': task['description'].toString(),
      };
    }).toList();
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
                color: ColorCollection.primary900,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            const Text(
              'Mau buat tugas apa hari ini?',
              style: TextStyle(fontSize: 16, color: ColorCollection.neutral600),
            ),
            const SizedBox(height: 24),
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
                        Tab(
                          text: 'Tugas Mendatang',
                        ),
                        Tab(text: 'Sudah Selesai'),
                      ],
                    ),
                    const SizedBox(height: Spacing.lg),
                    Expanded(
                      child: TabBarView(
                        children: [
                          _buildTaskList(tasks, isCompleted: false),
                          _buildTaskList(completedTasks, isCompleted: true),
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
                onAddTask: (newTask) async {
                  await widget.client.from('tasks').insert(newTask).execute();
                  _loadTasks();
                },
                categories: [
                  'Semua',
                  'Tugas Kuliah',
                  'Pribadi',
                  'Kerja',
                  'Hobi',
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              './assets/images/Empty.png',
              width: 300,
              height: 300,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 16),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  isCompleted
                      ? 'Belum ada tugas yang selesai'
                      : 'Buat yuk! Masih kosong nih',
                  style: const TextStyle(
                      fontSize: 16,
                      color: ColorCollection.primary900,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 8,
                ),
                Flexible(
                  child: Text(
                    isCompleted
                        ? 'Checklist tugas kamu buat tandain kalau tugas kamu sudah selesai'
                        : 'Belum ada tugas buat kamu sekarang',
                    style: const TextStyle(
                      fontSize: 16,
                      color: ColorCollection.neutral600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: taskList.length,
      itemBuilder: (context, index) {
        final task = taskList[index];
        return TugasCard(
          task: task,
          onTap: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailTugas(
                  task: task,
                  onTaskUpdated: (updatedTask) async {
                    final response = await widget.client
                        .from('tasks')
                        .update(updatedTask)
                        .eq('id', task['id'])
                        .execute();

                    if (response.status == 200) {
                      _loadTasks();
                    } else {
                      print('Error updating tasks: ${response.status}');
                    }
                  },
                  onTaskDeleted: () async {
                    final response = await widget.client
                        .from('tasks')
                        .delete()
                        .eq('id', task['id'])
                        .execute();

                    if (response.status == 200) {
                      _loadTasks();
                    } else {
                      print('Deleting tasks: Status ${response.status}');
                    }
                  },
                  onTaskCompleted: () async {
                    await widget.client
                        .from('tasks')
                        .update({'status': 'completed'})
                        .eq('id', task['id'])
                        .execute();
                    _loadTasks();
                  },
                ),
              ),
            );

            if (result is bool && result) {
              setState(() {}); // Refresh state
            }
          },
          trailing: IconButton(
            icon: Icon(
              isCompleted ? Icons.check_box : Icons.check_box_outline_blank,
              color: isCompleted ? Colors.green : ColorCollection.neutral500,
            ),
            onPressed: () async {
              if (isCompleted) {
                await widget.client
                    .from('tasks')
                    .update({'status': 'pending'})
                    .eq('id', task['id'])
                    .execute();
              } else {
                await widget.client
                    .from('tasks')
                    .update({'status': 'completed'})
                    .eq('id', task['id'])
                    .execute();
              }
              _loadTasks();
            },
          ),
        );
      },
    );
  }
}
