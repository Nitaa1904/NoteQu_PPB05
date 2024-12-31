import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notequ/design_system/styles/color.dart';

class DetailTugas extends StatefulWidget {
  final Map<String, String> task;
  final void Function(Map<String, String>) onTaskUpdated;
  final void Function() onTaskDeleted;
  final void Function() onTaskCompleted;

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
    final _taskController = TextEditingController(text: widget.task['title']);
    final _noteController = TextEditingController(text: widget.task['note']);
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
              title: const Text(
                'Edit Tugas',
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
                      readOnly: true,
                      onTap: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: selectedTime ?? TimeOfDay.now(),
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
                    // Pastikan waktu valid sebelum diolah
                    if (selectedTime != null) {
                      final formattedTime = TimeOfDay(
                          hour: selectedTime!.hour,
                          minute: selectedTime!.minute);

                      widget.onTaskUpdated({
                        'title': _taskController.text,
                        'category': selectedCategory,
                        'date': selectedDate != null
                            ? DateFormat('yyyy-MM-dd').format(selectedDate!)
                            : 'Tanggal belum dipilih',
                        'time':
                            '${formattedTime.hour}:${formattedTime.minute.toString().padLeft(2, '0')}',
                        'note': _noteController.text.isNotEmpty
                            ? _noteController.text
                            : 'Tidak ada catatan',
                      });
                      Navigator.of(context).pop();
                    } else {
                      print(
                          "Waktu pengingat tidak valid."); // Tambahkan log jika waktu tidak valid
                    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Detail Aktivitas',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: ColorCollection.primary900,
        foregroundColor: Colors.white,
      ),
      backgroundColor: ColorCollection.primary100,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.task['category']?.isNotEmpty == true
                  ? widget.task['category']!
                  : 'Tidak Ada Kategori',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.task['title'] ?? 'Judul tidak tersedia',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${widget.task['date'] ?? ''} ${widget.task['time'] != null && widget.task['time']!.isNotEmpty ? '| ${widget.task['time']}' : ''}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
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
                Text(
                  widget.task['note'] ?? 'Tidak ada catatan untuk tugas ini.',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        widget.onTaskCompleted();
                        Navigator.pop(context, true);
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black,
                      ),
                      child: const Text(
                        'Tandai Selesai',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _editTask,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue,
                      ),
                      child: const Text(
                        'Edit',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        widget.onTaskDeleted();
                        Navigator.pop(context, true);
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.red,
                      ),
                      child: const Text(
                        'Hapus',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
