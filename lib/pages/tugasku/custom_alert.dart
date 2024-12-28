import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomAlert extends StatelessWidget {
  final Function(Map<String, String>) onAddTask;
  final List<String> categories;

  CustomAlert({required this.onAddTask, required this.categories});

  @override
  Widget build(BuildContext context) {
    final _taskController = TextEditingController();
    DateTime? selectedDate;
    TimeOfDay? selectedTime;

    String selectedCategory = categories.isNotEmpty ? categories[0] : 'General';

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      title: const Text(
        'Tambah Tugas Baru',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
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
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                ...categories.map((category) => ChoiceChip(
                      label: Text(category),
                      selected: selectedCategory == category,
                      onSelected: (isSelected) {
                        if (isSelected) {
                          selectedCategory = category;
                        }
                      },
                    )),
                ActionChip(
                  label: const Icon(Icons.add),
                  onPressed: () {
                    // Tambah kategori baru
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              readOnly: true,
              onTap: () async {
                selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
              },
              decoration: InputDecoration(
                hintText: 'Pilih tanggal buat tugas kamu',
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
                selectedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
              },
              decoration: InputDecoration(
                hintText: 'Pilih waktu buat tugas kamu',
                suffixIcon: const Icon(Icons.access_time),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                ...[5, 10, 15, 30].map((minute) => ChoiceChip(
                      label: Text('$minute menit sebelumnya'),
                      selected: false,
                      onSelected: (isSelected) {
                        // Atur pengingat
                      },
                    )),
                ActionChip(
                  label: const Icon(Icons.add),
                  onPressed: () {
                    // Tambah pengingat baru
                  },
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
              onAddTask({
                'title': _taskController.text,
                'category': selectedCategory,
                'date': selectedDate != null
                    ? DateFormat('yyyy-MM-dd').format(selectedDate!)
                    : 'No Date',
                'time': selectedTime != null
                    ? selectedTime!.format(context)
                    : 'No Time',
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
