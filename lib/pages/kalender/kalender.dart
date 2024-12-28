import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:notequ/design_system/styles/color.dart';

class Kalender extends StatefulWidget {
  final List<Map<String, String>> tasks;

  const Kalender({Key? key, required this.tasks}) : super(key: key);

  @override
  _KalenderState createState() => _KalenderState();
}

class _KalenderState extends State<Kalender> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Map<String, String>>> _tasksForDates = {};

  @override
  void initState() {
    super.initState();
    _tasksForDates = _groupTasksByDate(widget.tasks);
  }

  // Fungsi untuk mengelompokkan tugas berdasarkan tanggal
  Map<DateTime, List<Map<String, String>>> _groupTasksByDate(
      List<Map<String, String>> tasks) {
    final Map<DateTime, List<Map<String, String>>> groupedTasks = {};
    for (var task in tasks) {
      final taskDate = DateTime.tryParse(task['date'] ?? '');
      if (taskDate != null) {
        final normalizedDate =
            DateTime(taskDate.year, taskDate.month, taskDate.day);
        groupedTasks.putIfAbsent(normalizedDate, () => []).add(task);
      }
    }
    return groupedTasks;
  }

  @override
  Widget build(BuildContext context) {
    // Mendapatkan tugas untuk tanggal yang dipilih
    final selectedTasks =
        _selectedDay != null ? _tasksForDates[_selectedDay] ?? [] : [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalender'),
        backgroundColor: ColorCollection.primary900,
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: ColorCollection.primary900,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: ColorCollection.primary900,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: selectedTasks.isEmpty
                ? const Center(
                    child: Text(
                      'Tidak ada tugas pada tanggal ini.',
                      style: TextStyle(
                          fontSize: 16, color: ColorCollection.neutral600),
                    ),
                  )
                : ListView.builder(
                    itemCount: selectedTasks.length,
                    itemBuilder: (context, index) {
                      final task = selectedTasks[index];
                      return ListTile(
                        title: Text(task['title'] ?? ''),
                        subtitle: Text(
                            '${task['category'] ?? ''} - ${task['time'] ?? ''}'),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
