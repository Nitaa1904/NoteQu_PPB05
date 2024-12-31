import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notequ/design_system/styles/color.dart';
import 'package:timezone/timezone.dart' as tz;

class CustomAlert extends StatefulWidget {
  final Function(Map<String, String>) onAddTask;
  final List<String> categories;

  CustomAlert({required this.onAddTask, required this.categories});

  @override
  _CustomAlertState createState() => _CustomAlertState();
}

class _CustomAlertState extends State<CustomAlert> {
  final _taskController = TextEditingController();
  final _noteController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String selectedCategory = '';
  int? selectedReminder;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    selectedCategory =
        widget.categories.isNotEmpty ? widget.categories[0] : 'General';
    _initializeNotifications();
  }

  void _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> scheduleNotification(
      String title, String body, DateTime scheduledDate) async {
    final tzScheduledDate = tz.TZDateTime.from(scheduledDate, tz.local);

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      title,
      body,
      tzScheduledDate,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ColorCollection.primary100,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      title: const Text(
        'Tambah Tugas Baru',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _taskController,
              decoration: InputDecoration(
                hintText: 'Masukkan judul tugas',
                focusColor: ColorCollection.primary900,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Pilih Kategori',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: widget.categories.map((category) {
                return RawChip(
                  label: Text(
                    category,
                    style: TextStyle(
                        color: selectedCategory == category
                            ? ColorCollection.primary100
                            : ColorCollection.primary900),
                  ),
                  selected: selectedCategory == category,
                  selectedColor: ColorCollection.primary900,
                  backgroundColor: ColorCollection.primary100,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  showCheckmark: false,
                  onSelected: (isSelected) {
                    if (isSelected) {
                      setState(() {
                        selectedCategory = category;
                      });
                    }
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            TextFormField(
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  setState(() {
                    selectedDate = pickedDate;
                  });
                }
              },
              decoration: InputDecoration(
                hintText: selectedDate != null
                    ? DateFormat('dd-MM-yyyy').format(selectedDate!)
                    : 'Pilih tanggal buat tugas kamu',
                suffixIcon: const Icon(Icons.calendar_today),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              readOnly: true,
              onTap: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (pickedTime != null) {
                  setState(() {
                    selectedTime = pickedTime;
                  });
                }
              },
              decoration: InputDecoration(
                hintText: selectedTime != null
                    ? selectedTime!.format(context)
                    : 'Pilih waktu buat tugas kamu',
                suffixIcon: const Icon(Icons.access_time),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Pengingat',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [5, 10, 15, 30, 60].map((minute) {
                return RawChip(
                  label: Text(
                    '$minute menit sebelumnya',
                    style: TextStyle(
                        color: selectedReminder == minute
                            ? ColorCollection.primary100
                            : ColorCollection.primary900),
                  ),
                  selected: selectedReminder == minute,
                  selectedColor: ColorCollection.primary900,
                  backgroundColor: ColorCollection.primary100,
                  showCheckmark: false,
                  onSelected: (isSelected) {
                    setState(() {
                      selectedReminder = isSelected ? minute : null;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Catatan',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _noteController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Tambahkan catatan untuk tugas ini',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'Batal',
            style: TextStyle(
                fontSize: 16,
                color: ColorCollection.neutral600,
                fontWeight: FontWeight.bold),
          ),
        ),
        TextButton(
          onPressed: () {
            if (_taskController.text.isNotEmpty) {
              final now = DateTime.now();

              if (selectedDate != null && selectedTime != null) {
                DateTime scheduledDate = DateTime(
                  selectedDate!.year,
                  selectedDate!.month,
                  selectedDate!.day,
                  selectedTime!.hour,
                  selectedTime!.minute,
                );

                if (selectedReminder != null) {
                  scheduledDate = scheduledDate
                      .subtract(Duration(minutes: selectedReminder!));
                }

                if (scheduledDate.isAfter(now)) {
                  scheduleNotification(
                    'Pengingat Tugas',
                    'Tugas: ${_taskController.text} akan segera dimulai!',
                    scheduledDate,
                  );
                } else {
                  print('Waktu pengingat tidak valid.');
                }
              }

              widget.onAddTask({
                'title': _taskController.text,
                'category': selectedCategory,
                'date': selectedDate != null
                    ? DateFormat('dd-MM-yyyy').format(selectedDate!)
                    : 'No Date',
                'time': selectedTime != null
                    ? selectedTime!.format(context)
                    : 'No Time',
                'reminder': selectedReminder != null
                    ? '$selectedReminder menit sebelumnya'
                    : 'No Reminder',
                'note': _noteController.text.isNotEmpty
                    ? _noteController.text
                    : 'Tidak ada catatan untuk tugas ini.',
              });
              Navigator.of(context).pop();
            }
          },
          child: const Text(
            'Selesai',
            style: TextStyle(
                fontSize: 16,
                color: ColorCollection.primary900,
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
