import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  @override
  void initState() {
    super.initState();
    selectedCategory =
        widget.categories.isNotEmpty ? widget.categories[0] : 'General';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Pilih Kategori',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: widget.categories.map((category) {
                return ChoiceChip(
                  label: Text(category),
                  selected: selectedCategory == category,
                  selectedColor: Colors.blue.shade100,
                  backgroundColor: Colors.grey.shade200,
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
                    ? DateFormat('yyyy-MM-dd').format(selectedDate!)
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
            Text(
              'Pengingat',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [5, 10, 15, 30].map((minute) {
                return ChoiceChip(
                  label: Text('$minute menit sebelumnya'),
                  selected: selectedReminder == minute,
                  selectedColor: Colors.blue.shade100,
                  backgroundColor: Colors.grey.shade200,
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
                    fontSize: 18,
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
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_taskController.text.isNotEmpty) {
              widget.onAddTask({
                'title': _taskController.text,
                'category': selectedCategory,
                'date': selectedDate != null
                    ? DateFormat('yyyy-MM-dd').format(selectedDate!)
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
          child: const Text('Selesai'),
        ),
      ],
    );
  }
}
