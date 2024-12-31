import 'package:flutter/material.dart';
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
    TextEditingController titleController =
        TextEditingController(text: widget.task['title']);
    TextEditingController noteController =
        TextEditingController(text: widget.task['note']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Tugas'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Judul',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: noteController,
                  decoration: const InputDecoration(
                    labelText: 'Catatan',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
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
                widget.onTaskUpdated({
                  ...widget.task,
                  'title': titleController.text,
                  'note': noteController.text,
                });
                Navigator.of(context).pop();
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: ColorCollection.primary100,
          title: Column(
            children: [
              Image.asset(
                '../assets/images/hapus-tugas.png',
                width: 200,
                height: 200,
              ),
              const Text(
                'Hapus Tugas?',
                style: TextStyle(
                    color: ColorCollection.primary900,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: const Text(
            'Kamu yakin mau menghapus tugas ini?',
            style: TextStyle(
              color: ColorCollection.neutral600,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () {
                widget.onTaskDeleted();
                Navigator.of(context).pop(); // Tutup dialog
                Navigator.pop(context, true); // Kembali ke halaman sebelumnya
              },
              child: const Text(
                'Ya',
                style: TextStyle(
                    color: ColorCollection.accentRed,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ),
            const SizedBox(width: 2),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
              child: const Text(
                'Batal',
                style: TextStyle(
                    color: ColorCollection.neutral800,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }

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
                onPressed: _showDeleteConfirmationDialog,
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
                      borderRadius: BorderRadius.circular(12.0), // Border radius
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
