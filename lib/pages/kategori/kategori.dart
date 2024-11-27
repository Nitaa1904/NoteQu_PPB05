import 'package:flutter/material.dart';
import 'package:notequ/design_system/styles/color.dart';
import 'package:notequ/design_system/widget/card/task_card.dart';
import 'package:notequ/pages/tugasku/detail_tugas.dart';

class Kategori extends StatefulWidget {
  const Kategori({super.key});

  @override
  _KategoriState createState() => _KategoriState();
}

class _KategoriState extends State<Kategori> {
  final List<String> categories = [
    'Semua',
    'Tugas Kuliah',
    'Pribadi',
    'Kerja',
    'Hobi',
    'Esport',
    'Olahraga',
  ];

  final List<Map<String, String>> allTasks = [
    {
      'category': 'Tugas Kuliah',
      'title': 'Tugas Logika Matematika',
      'date': '10-10',
      'time': '23:59'
    },
    {
      'category': 'Pribadi',
      'title': 'Jalan-jalan ke Rita Mall',
      'date': '10-10',
      'time': '13:00'
    },
    {
      'category': 'Tugas Kuliah',
      'title': 'Quiz PMPL',
      'date': '11-10',
      'time': '23:59'
    },
    {
      'category': 'Tugas Kuliah',
      'title': 'Quiz Pengalaman Pengguna',
      'date': '12-10',
      'time': '22:00'
    },
  ];

  String selectedCategory = 'Semua';

  List<Map<String, String>> get filteredTasks {
    if (selectedCategory == 'Semua') {
      return allTasks;
    }
    return allTasks
        .where((task) => task['category'] == selectedCategory)
        .toList();
  }

  void showAddCategoryDialog() {
    final TextEditingController categoryController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          title: const Text("Tambah Kategori Baru"),
          content: TextField(
            controller: categoryController,
            decoration: const InputDecoration(
              hintText: "Masukkan disini",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Tutup dialog
              },
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () {
                final newCategory = categoryController.text.trim();
                if (newCategory.isNotEmpty) {
                  setState(() {
                    categories.add(newCategory);
                  });
                  Navigator.pop(context); // Tutup dialog
                }
              },
              child: const Text("Simpan"),
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
        title: const Text(
          "Kategori",
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: ColorCollection.primary900),
        ),
        elevation: 4.0,
        shadowColor: ColorCollection.primary900.withOpacity(0.3),
        backgroundColor: ColorCollection.primary100,
      ),
      backgroundColor: ColorCollection.primary100,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 32,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: ChoiceChip(
                            label: Text(
                              categories[index],
                              style: TextStyle(
                                color: selectedCategory == categories[index]
                                    ? ColorCollection.primary100
                                    : ColorCollection.primary900,
                              ),
                            ),
                            selected: selectedCategory == categories[index],
                            onSelected: (isSelected) {
                              setState(() {
                                selectedCategory = categories[index];
                              });
                            },
                            backgroundColor: ColorCollection.primary100,
                            selectedColor: ColorCollection.primary900,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                IconButton(
                  icon:
                      const Icon(Icons.add, color: ColorCollection.primary900),
                  onPressed: showAddCategoryDialog,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: filteredTasks.length,
                itemBuilder: (context, index) {
                  return TugasCard(
                    task: filteredTasks[index],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailTugas(
                            task: filteredTasks[index],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
