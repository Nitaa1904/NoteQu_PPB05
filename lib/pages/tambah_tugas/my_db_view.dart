import 'package:flutter/material.dart';
import 'package:notequ/pages/tambah_tugas/db_helper.dart';

class MyDbView extends StatefulWidget {
  @override
  _MyDbViewState createState() => _MyDbViewState();
}

class _MyDbViewState extends State<MyDbView> {
  final DbHelper dbHelper = DbHelper();
  final TextEditingController _taskTitleController = TextEditingController();
  final TextEditingController _taskDateController = TextEditingController();
  final TextEditingController _taskTimeController = TextEditingController();

  List<Map<String, dynamic>> _dbData = [];
  String selectedCategory = '';
  List<String> categories = ["Tugas Kuliah", "Pribadi", "Keluarga"];
  List<String> reminders = [
    "5 menit sebelumnya",
    "10 menit sebelumnya",
    "15 menit sebelumnya",
    "30 menit sebelumnya"
  ];
  String selectedReminder = '';

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  Future<void> _refreshData() async {
    final data = await dbHelper.queryAllRows();
    setState(() {
      _dbData = data;
    });
  }

  Future<void> _addData() async {
    await dbHelper.insert({
      'title': _taskTitleController.text,
      'category': selectedCategory,
      'date': _taskDateController.text,
      'time': _taskTimeController.text,
      'reminder': selectedReminder,
    });
    _taskTitleController.clear();
    _taskDateController.clear();
    _taskTimeController.clear();
    setState(() {
      selectedCategory = '';
      selectedReminder = '';
    });
    await _refreshData();
  }

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
          contentPadding: EdgeInsets.all(16.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          title: Text(
            'Tambah Tugas Baru',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Input judul tugas
                TextField(
                  controller: _taskTitleController,
                  decoration: InputDecoration(
                    labelText: 'Judul Tugas',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                  ),
                ),
                SizedBox(height: 12.0),
                // Pilihan kategori
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Wrap(
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
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {},
                    ),
                  ],
                ),
                SizedBox(height: 12.0),

                TextField(
                  controller: _taskDateController,
                  decoration: InputDecoration(
                    labelText: 'Pilih Tanggal',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
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
                SizedBox(height: 12.0),
                TextField(
                  controller: _taskTimeController,
                  decoration: InputDecoration(
                    labelText: 'Pilih Waktu',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
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
                SizedBox(height: 12.0),

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
              child: Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                _addData();
                Navigator.of(context).pop();
              },
              child: Text('Selesai'),
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
        title: Text('Task Manager'),
      ),
      body: _dbData.isEmpty
          ? Center(child: Text('Belum ada tugas.'))
          : ListView.builder(
              itemCount: _dbData.length,
              itemBuilder: (context, index) {
                final item = _dbData[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(item['title'] ?? 'No Title'),
                    subtitle: Text(
                      'Kategori: ${item['category'] ?? ''}\nTanggal: ${item['date'] ?? ''}\nWaktu: ${item['time'] ?? ''}\nPengingat: ${item['reminder'] ?? ''}',
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
