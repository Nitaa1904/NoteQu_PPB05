import 'package:flutter/material.dart';
import 'package:notequ/design_system/widget/bottomnav/bottom_nav.dart';
import 'package:notequ/pages/tugasku/tugasku.dart';
import 'package:notequ/pages/kategori/kategori.dart';
import 'package:notequ/pages/kalender/kalender.dart';
import 'package:notequ/pages/profil/profil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, String>> tasks = [];
  List<Map<String, dynamic>> completedTasks = [];
  final List<String> categories = [
    'Semua',
    'Tugas Kuliah',
    'Pribadi',
    'Kerja',
    'Hobi',
    'Esport',
    'Olahraga',
  ];

  Future<void> _fetchTasks() async {
    final response = await supabase.from('task').select().order('id').execute();
    if (response.status != 200 || response.data == null) {
      print('Error fetching tasks: Status ${response.status}');
    } else {
      final data = response.data as List<dynamic>;
      setState(() {
        tasks = data
            .where((task) => !task['is_completed'])
            .map((task) => {
                  'id': task['id'].toString(),
                  'title': task['title'].toString(),
                  'category': task['category']?.toString() ?? '',
                  'date': task['date']?.toString() ?? '',
                  'time': task['time']?.toString() ?? '',
                  'description': task['description']?.toString() ?? '',
                })
            .toList();
        completedTasks = data
            .where((task) => task['is_completed'])
            .map((task) => {
                  'id': task['id'].toString(),
                  'title': task['title'].toString(),
                  'category': task['category']?.toString() ?? '',
                  'date': task['date']?.toString() ?? '',
                  'time': task['time']?.toString() ?? '',
                  'description': task['description']?.toString() ?? '',
                })
            .toList();
      });
    }
  }

  Future<void> _addTask(Map<String, dynamic> newTask) async {
    final response = await supabase.from('task').insert(newTask).execute();
    if (response.status != 201 || response.data == null) {
      print('Error adding task: Status ${response.status}');
    } else {
      _fetchTasks(); // Refresh tasks
    }
  }

  Future<void> _updateTask(Map<String, dynamic> updatedTask) async {
    final response = await supabase
        .from('task')
        .update(updatedTask)
        .eq('id', updatedTask['id'])
        .execute();
    if (response.status != 200 || response.data == null) {
      print('Error updating task: Status ${response.status}');
    } else {
      _fetchTasks(); // Refresh tasks
    }
  }

  Future<void> _deleteTask(String? id) async {
    final int? taskId = int.tryParse(id ?? '');
    if (taskId == null) return;

    final response =
        await supabase.from('task').delete().eq('id', taskId).execute();
    if (response.status != 200 || response.data == null) {
      print('Error deleting task: Status ${response.status}');
    } else {
      _fetchTasks(); // Refresh tasks
    }
  }

  Future<void> _markAsCompleted(dynamic id) async {
    if (id is! int) {
      print('Invalid task ID: $id');
      return;
    }
    final response = await supabase
        .from('task')
        .update({'is_completed': true})
        .eq('id', id)
        .execute();
    if (response.status != 200 || response.data == null) {
      print('Error marking task as completed: Status ${response.status}');
    } else {
      await _fetchTasks(); // Refresh tasks
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BottomNavbar(
        tugasku: Tugasku(client: supabase),
        kategori: Kategori(
          tasks: tasks,
          categories: categories,
          addTask: _addTask,
          updateTask: _updateTask,
          deleteTask: (task) => _deleteTask(task['id']),
          completeTask: (task) => _markAsCompleted(task['id']),
        ),
        kalender: Kalender(tasks: tasks),
        profil: Profil(
          completedTasks: completedTasks.length,
          pendingTasks: tasks.length,
        ),
      ),
    );
  }
}
