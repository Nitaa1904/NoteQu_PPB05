import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notequ/design_system/styles/color.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:supabase_flutter/supabase_flutter.dart';

class CustomAlert extends StatefulWidget {
  final List<Map<String, dynamic>> categories; // Daftar kategori
  final Future<void> Function(Map<String, dynamic>) onAddTask;
  final Function(String) onCategorySelected; // Callback untuk klik kategori
  final Future<void> Function(String)
      onAddCategory; // Callback untuk tambah kategori

  const CustomAlert({
    Key? key,
    required this.categories,
    required this.onAddTask,
    required this.onCategorySelected,
    required this.onAddCategory,
  }) : super(key: key);

  @override
  _CustomAlertState createState() => _CustomAlertState();
}

class _CustomAlertState extends State<CustomAlert> {
  final TextEditingController _categoryController = TextEditingController();
  final _taskController = TextEditingController();
  final _noteController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String selectedCategory = '';
  int? selectedReminder;

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late SupabaseClient client;

  @override
  void initState() {
    super.initState();
    selectedCategory =
        widget.categories.isNotEmpty ? widget.categories[0]['id'] : 'General';
    client = Supabase.instance.client;
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _initializeNotifications();
  }

  @override
  void dispose() {
    _categoryController.dispose();
    _taskController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  // Inisialisasi notifikasi lokal
  void _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Jadwalkan notifikasi
  Future<void> scheduleNotification(
      String title, String body, DateTime scheduledDate) async {
    final tzScheduledDate = tz.TZDateTime.from(scheduledDate, tz.local);
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.high,
      priority: Priority.high,
    );
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      title,
      body,
      tzScheduledDate,
      notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // Tambahkan tugas ke database Supabase
  Future<void> addTask({
    required String title,
    required String category,
    required DateTime date,
    required String time,
    required String description,
  }) async {
    try {
      await client.from('tasks').insert({
        'title': title,
        'category': category,
        'date': date.toIso8601String(),
        'time': time,
        'description': description,
      });
    } catch (e) {
      debugPrint('Error adding task: $e');
    }
  }

  // Widget untuk input tanggal
  Widget _buildDatePicker() {
    return TextFormField(
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
    );
  }

  // Widget untuk input waktu
  Widget _buildTimePicker() {
    return TextFormField(
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
    );
  }

  void _showAddCategoryDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          title: const Text("Tambah Kategori Baru"),
          content: TextField(
            controller: _categoryController,
            decoration: const InputDecoration(
              hintText: "Masukkan nama kategori",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_categoryController.text.isNotEmpty) {
                  try {
                    await widget.onAddCategory(_categoryController.text);
                    Navigator.pop(context);
                  } catch (error) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Gagal menambahkan kategori: $error')),
                    );
                  }
                }
              },
              child: const Text("Tambah"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController categoryController = TextEditingController();
    String selectedCategory = '';

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
            const Text('Pilih Kategori',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              children: [
                SizedBox(
                  width: double.maxFinite,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.categories.length,
                    itemBuilder: (context, index) {
                      final category = widget.categories[index];
                      return ListTile(
                        title: Text(
                          category['name'] ?? 'Unknown',
                          style: TextStyle(
                            color: ColorCollection.primary900,
                          ),
                        ),
                        onTap: () {
                          widget.onCategorySelected(category['id'] as String);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildDatePicker(),
            const SizedBox(height: 16),
            _buildTimePicker(),
            const SizedBox(height: 16),
            const Text('Pengingat',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              children: [5, 10, 15, 30, 60].map((minute) {
                return ChoiceChip(
                  label: Text('$minute menit sebelumnya'),
                  selected: selectedReminder == minute,
                  onSelected: (isSelected) {
                    setState(() {
                      selectedReminder = isSelected ? minute : null;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
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
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Batal',
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        TextButton(
          onPressed: () async {
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
                  await scheduleNotification(
                    'Pengingat Tugas',
                    'Tugas: ${_taskController.text} akan segera dimulai!',
                    scheduledDate,
                  );
                }
              }

              // Data tugas baru yang akan dikirimkan ke callback
              final newTask = {
                'title': _taskController.text,
                'category': selectedCategory,
                'date': selectedDate?.toIso8601String() ??
                    DateTime.now().toIso8601String(),
                'time': selectedTime?.format(context) ?? 'No Time',
                'reminder': selectedReminder,
                'note': _noteController.text,
              };

              // Panggil callback onAddTask
              await widget.onAddTask(newTask);

              Navigator.of(context).pop();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Judul tugas tidak boleh kosong')),
              );
            }
          },
          child: const Text(
            'Selesai',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
