import 'package:flutter/material.dart';
import 'package:notequ/design_system/styles/color.dart';
import 'package:notequ/design_system/styles/spacing.dart';

class MyDbView extends StatefulWidget {
  @override
  _MyDbViewState createState() => _MyDbViewState();
}

class _MyDbViewState extends State<MyDbView> {
  final TextEditingController _taskTitleController = TextEditingController();
  final TextEditingController _taskDateController = TextEditingController();
  final TextEditingController _taskTimeController = TextEditingController();

  String selectedCategory = '';
  List<String> categories = ["Tugas Kuliah", "Pribadi", "Keluarga"];
  List<String> reminders = [
    "5 menit sebelumnya",
    "10 menit sebelumnya",
    "15 menit sebelumnya",
    "30 menit sebelumnya"
  ];
  String selectedReminder = '';

  void _showAddDialog() {
    _taskTitleController.clear();
    _taskDateController.clear();
    _taskTimeController.clear();
    setState(() {
      selectedCategory = '';
      selectedReminder = '';
    });

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(Spacing.md),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          title: const Text(
            'Tambah Tugas Baru',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: ColorCollection.primary900,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Input judul tugas
                TextField(
                  controller: _taskTitleController,
                  decoration: InputDecoration(
                    labelText: 'Judul Tugas',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(height: Spacing.md),
                // Pilihan kategori
                const Text(
                  'Kategori',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: ColorCollection.primary900,
                  ),
                ),
                const SizedBox(height: Spacing.sm),
                Wrap(
                  spacing: 8.0,
                  children: categories.map((category) {
                    return ChoiceChip(
                      label: Text(category),
                      selected: selectedCategory == category,
                      onSelected: (isSelected) {
                        setState(() {
                          selectedCategory = isSelected ? category : '';
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: Spacing.md),

                // Pilih tanggal
                TextField(
                  controller: _taskDateController,
                  decoration: InputDecoration(
                    labelText: 'Pilih Tanggal',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      _taskDateController.text =
                          '${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}';
                    }
                  },
                ),
                const SizedBox(height: Spacing.md),

                // Pilih waktu
                TextField(
                  controller: _taskTimeController,
                  decoration: InputDecoration(
                    labelText: 'Pilih Waktu',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onTap: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (pickedTime != null) {
                      _taskTimeController.text = pickedTime.format(context);
                    }
                  },
                ),
                const SizedBox(height: Spacing.md),

                // Pengingat
                const Text(
                  'Pengingat',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: ColorCollection.primary900,
                  ),
                ),
                const SizedBox(height: Spacing.sm),
                Wrap(
                  spacing: 8.0,
                  children: reminders.map((reminder) {
                    return ChoiceChip(
                      label: Text(reminder),
                      selected: selectedReminder == reminder,
                      onSelected: (isSelected) {
                        setState(() {
                          selectedReminder = isSelected ? reminder : '';
                        });
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal',
                  style: TextStyle(color: ColorCollection.primary900)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorCollection.primary900,
              ),
              onPressed: () {
                // Logika untuk menambahkan data
                Navigator.of(context).pop();
              },
              child: const Text('Selesai'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: _showAddDialog,
        backgroundColor: ColorCollection.primary900,
        child: const Icon(Icons.add, color: ColorCollection.primary100),
      ),
    );
  }
}
