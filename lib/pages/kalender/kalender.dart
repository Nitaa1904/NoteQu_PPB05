import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:notequ/design_system/styles/color.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class Kalender extends StatefulWidget {
  final List<Map<String, String>> tasks;

  const Kalender({Key? key, required this.tasks}) : super(key: key);

  @override
  _KalenderState createState() => _KalenderState();
}

class _KalenderState extends State<Kalender> {
  final SupabaseClient client = Supabase.instance.client;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<Map<String, dynamic>> _selectedTasks = [];

  Future<List<Map<String, dynamic>>> fetchTasksByDate(DateTime date) async {
    final response = await client
        .from('tasks')
        .select()
        .eq('date', DateFormat('yyyy-MM-dd').format(date))
        .execute();

    if (response.status == 200 && response.data != null) {
      return List<Map<String, dynamic>>.from(response.data);
    } else {
      throw Exception('Failed to fetch tasks: ${response.status}');
    }
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });

    // Fetch tasks for the selected day
    fetchTasksByDate(selectedDay).then((tasks) {
      setState(() {
        _selectedTasks = tasks;
      });
    }).catchError((error) {
      // Handle error here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching tasks: $error')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Kalender',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: ColorCollection.primary900),
        ),
        elevation: 4.0,
        shadowColor: ColorCollection.primary900.withOpacity(0.3),
        backgroundColor: ColorCollection.primary100,
      ),
      backgroundColor: ColorCollection.primary100,
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: _onDaySelected,
            calendarStyle: const CalendarStyle(
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
            child: _selectedTasks.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          '../assets/images/kalender.png',
                          width: 300,
                          height: 300,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        const Text(
                          'Belum ada tugas di tanggal ini',
                          style: TextStyle(
                              fontSize: 16, color: ColorCollection.neutral600),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _selectedTasks.length,
                    itemBuilder: (context, index) {
                      final task = _selectedTasks[index];
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
