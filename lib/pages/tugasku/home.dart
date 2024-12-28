import 'package:flutter/material.dart';
import 'package:notequ/design_system/widget/bottomnav/bottom_nav.dart';
import 'package:notequ/pages/tugasku/tugasku.dart';
import 'package:notequ/pages/kategori/kategori.dart';
import 'package:notequ/pages/kalender/kalender.dart';
import 'package:notequ/pages/profil/profil.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final List<Map<String, String>> tasks = [];
  final List<Map<String, String>> completedTasks = [];
  final List<String> categories = [
    'Semua',
    'Tugas Kuliah',
    'Pribadi',
    'Kerja',
    'Hobi',
    'Esport',
    'Olahraga',
  ];

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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BottomNavbar(
        tugasku: Tugasku(
          tasks: tasks,
          completedTasks: completedTasks,
          addTask: _addTask,
          markAsCompleted: _markAsCompleted,
          markAsIncomplete: _markAsIncomplete,
        ),
        kategori: Kategori(
          tasks: tasks,
          categories: categories,
          addTask: _addTask,
        ),
        kalender: Kalender(),
        profil: Profil(),
      ),
    );
  }
}
