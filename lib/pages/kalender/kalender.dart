import 'package:flutter/material.dart';
import 'package:notequ/design_system/styles/color.dart';
import 'package:notequ/design_system/widget/card/task_card.dart';
import 'package:table_calendar/table_calendar.dart';

class Kalender extends StatefulWidget {
  const Kalender({super.key});

  @override
  State<Kalender> createState() => _KalenderState();
}

class _KalenderState extends State<Kalender> {
  late Map<DateTime, List<Map<String, String>>> selectedEvents;
  late DateTime selectedDay;
  late DateTime focusedDay;

  @override
  void initState() {
    super.initState();
    selectedDay = DateTime.now();
    focusedDay = DateTime.now();
    selectedEvents = _getTasksForSelectedDate();
  }

  // Contoh data tugas
  List<Map<String, String>> tasks = [
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
      'date': '25-10',
      'time': '23:59'
    },
    {
      'category': 'Tugas Kuliah',
      'title': 'Quiz Pengalaman Pengguna',
      'date': '12-10',
      'time': '22:00'
    },
  ];

  // Fungsi untuk memfilter tugas berdasarkan tanggal
  Map<DateTime, List<Map<String, String>>> _getTasksForSelectedDate() {
    Map<DateTime, List<Map<String, String>>> tasksForDate = {};
    for (var task in tasks) {
      final taskDate = DateTime.parse(
          '2024-${task['date']!.split('-')[0]}-${task['date']!.split('-')[1]}');
      if (tasksForDate[taskDate] == null) {
        tasksForDate[taskDate] = [];
      }
      tasksForDate[taskDate]?.add(task);
    }
    return tasksForDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Kalender Tugas",
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: ColorCollection.primary900),
        ),
        backgroundColor: ColorCollection.primary100,
        elevation: 4.0,
      ),
      backgroundColor: ColorCollection.primary100,
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: focusedDay,
            selectedDayPredicate: (day) => isSameDay(selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                this.selectedDay = selectedDay;
                this.focusedDay = focusedDay;
                selectedEvents =
                    _getTasksForSelectedDate(); // Update events berdasarkan tanggal yang dipilih
              });
            },
            eventLoader: (day) {
              return selectedEvents[day] ?? [];
            },
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                color: ColorCollection.primary900,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: ColorCollection.primary900,
                shape: BoxShape.circle,
              ),
              todayTextStyle: TextStyle(color: ColorCollection.primary100),
            ),
          ),
          const SizedBox(height: 16),
          if (selectedEvents[selectedDay] != null &&
              selectedEvents[selectedDay]!.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: selectedEvents[selectedDay]!.length,
                itemBuilder: (context, index) {
                  return TugasCard(
                    task: selectedEvents[selectedDay]![index],
                    onTap: () {
                      // Aksi saat card ditekan
                      // print(
                      //     'Tugas "${selectedEvents[selectedDay]![index]['title']}" di-tap.');
                    },
                  );
                },
              ),
            )
          else
            const Expanded(
              child: Center(
                child: Text(
                  'Tidak ada tugas pada tanggal ini',
                  style: TextStyle(
                      fontSize: 14, color: ColorCollection.neutral600),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
