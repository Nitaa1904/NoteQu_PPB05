import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailTugas extends StatefulWidget {
  final Map<String, String> task;
  final Future<void> Function(Map<String, String> updatedTask) onTaskUpdated;
  final Future<void> Function() onTaskDeleted;
  final Future<void> Function() onTaskCompleted;

  const DetailTugas({
    Key? key,
    required this.task,
    required this.onTaskUpdated,
    required this.onTaskDeleted,
    required this.onTaskCompleted,
  }) : super(key: key);

  @override
  _DetailTugasState createState() => _DetailTugasState();
}

class _DetailTugasState extends State<DetailTugas> {
  void _editTask() {
    final _taskController =
        TextEditingController(text: widget.task['title'] ?? '');
    final _noteController =
        TextEditingController(text: widget.task['description'] ?? '');
    DateTime? selectedDate = widget.task['date'] != null
        ? DateFormat('yyyy-MM-dd').parse(widget.task['date']!)
        : null;
    TimeOfDay? selectedTime = widget.task['time'] != null
        ? TimeOfDay(
            hour: int.parse(widget.task['time']!.split(":")[0]),
            minute: int.parse(widget.task['time']!.split(":")[1]))
        : null;
    String selectedCategory = widget.task['category'] ?? '';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              title: const Text('Edit Tugas',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min, // Pastikan ukuran minimal
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
                    Text('Pilih Kategori',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children:
                          ['Pribadi', 'Pekerjaan', 'Belajar'].map((category) {
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
                          initialDate: selectedDate ?? DateTime.now(),
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
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final updates = {
                      'title': _taskController.text,
                      'category': selectedCategory,
                      'date': selectedDate != null
                          ? DateFormat('yyyy-MM-dd').format(selectedDate!)
                          : '',
                      'description': _noteController.text,
                    };

                    await widget.onTaskUpdated({
                      ...widget.task,
                      ...updates,
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _deleteTask() async {
    await widget.onTaskDeleted();
    Navigator.pop(context, true);
  }

  void _completeTask() async {
    await widget.onTaskCompleted();
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Tugasku'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(onPressed: _editTask, child: const Text('Edit')),
          ElevatedButton(onPressed: _deleteTask, child: const Text('Hapus')),
          ElevatedButton(
              onPressed: _completeTask, child: const Text('Tandai Selesai')),
        ],
      ),
    );
  }
}
