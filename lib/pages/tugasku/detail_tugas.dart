import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notequ/design_system/styles/color.dart';

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
    final taskController =
        TextEditingController(text: widget.task['title'] ?? '');
    final noteController =
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
                      controller: taskController,
                      decoration: InputDecoration(
                        hintText: 'Masukkan judul tugas',
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
                      controller: noteController,
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
                      'title': taskController.text,
                      'category': selectedCategory,
                      'date': selectedDate != null
                          ? DateFormat('dd-MM-yyyy').format(selectedDate!)
                          : '',
                      'description': noteController.text,
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

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text('Detail Tugasku'),
  //     ),
  //     body: Column(
  //       crossAxisAlignment: CrossAxisAlignment.stretch,
  //       children: [
  //         ElevatedButton(onPressed: _editTask, child: const Text('Edit')),
  //         ElevatedButton(onPressed: _deleteTask, child: const Text('Hapus')),
  //         ElevatedButton(
  //             onPressed: _completeTask, child: const Text('Tandai Selesai')),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Detail Tugasku',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: ColorCollection.primary900,
              ),
            ),
            IconButton(
                onPressed: _deleteTask,
                icon: const Icon(
                  Icons.delete,
                  color: ColorCollection.accentRed,
                ))
          ],
        ),
        backgroundColor: ColorCollection.primary100,
        foregroundColor: ColorCollection.primary900,
        elevation: 4.0,
        shadowColor: ColorCollection.primary900.withOpacity(0.3),
      ),
      backgroundColor: ColorCollection.primary100,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kotak 1: Kategori, Judul, Tanggal
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ColorCollection.primary100,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: ColorCollection.primary900.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: ColorCollection.neutral200, // Warna latar belakang
                      borderRadius:
                          BorderRadius.circular(12.0), // Border radius
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, // Padding kiri dan kanan
                      vertical: 4.0, // Padding atas dan bawah
                    ),
                    child: Text(
                      widget.task['category']?.isNotEmpty == true
                          ? widget.task['category']!
                          : 'Tidak Ada Kategori',
                      style: const TextStyle(
                        fontSize: 14,
                        color: ColorCollection.neutral600,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.task['title'] ?? 'Judul tidak tersedia',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${widget.task['date'] ?? ''} ${widget.task['time'] != null && widget.task['time']!.isNotEmpty ? '| ${widget.task['time']}' : ''}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: ColorCollection.neutral600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Kotak 2: Catatan
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ColorCollection.primary100,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: ColorCollection.primary900.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Catatan',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: ColorCollection.primary900),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.task['note'] ?? 'Tidak ada catatan untuk tugas ini.',
                    style: const TextStyle(
                        fontSize: 16, color: ColorCollection.neutral700),
                  ),
                ],
              ),
            ),
            const Spacer(),
            // Tombol Aksi
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: OutlinedButton(
                      onPressed: _editTask,
                      style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                              color: ColorCollection.primary900, width: 2),
                          foregroundColor: ColorCollection.primary900,
                          backgroundColor: ColorCollection.primary100,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          )),
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
                        widget.onTaskCompleted();
                        Navigator.pop(context, true);
                      },
                      style: ElevatedButton.styleFrom(
                          foregroundColor: ColorCollection.primary100,
                          backgroundColor: ColorCollection.primary900,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          )),
                      child: const Text(
                        'Tandai Selesai',
                        textAlign: TextAlign.center,
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
