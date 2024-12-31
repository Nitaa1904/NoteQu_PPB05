import 'package:flutter/material.dart';
import 'package:notequ/design_system/styles/color.dart';
import 'package:notequ/design_system/widget/card/task_card.dart';
import 'package:notequ/pages/tugasku/detail_tugas.dart';

class Kategori extends StatefulWidget {
  final List<Map<String, String>> tasks; // Daftar tugas
  final List<String> categories; // Daftar kategori
  final Function(Map<String, String>) addTask; // Fungsi untuk menambah tugas
  final Function(Map<String, String>) updateTask; // Fungsi untuk mengedit tugas
  final Function(Map<String, String>)
      deleteTask; // Fungsi untuk menghapus tugas
  final Function(Map<String, String>)
      completeTask; // Fungsi untuk menyelesaikan tugas

  const Kategori({
    Key? key,
    required this.tasks,
    required this.categories,
    required this.addTask,
    required this.updateTask,
    required this.deleteTask,
    required this.completeTask,
  }) : super(key: key);

  @override
  _KategoriState createState() => _KategoriState();
}

class _KategoriState extends State<Kategori> {
  late List<String> categories; // Kategori lokal
  String selectedCategory = 'Semua'; // Kategori terpilih

  @override
  void initState() {
    super.initState();
    categories = List.from(widget.categories);
  }

  List<Map<String, String>> get filteredTasks {
    if (selectedCategory == 'Semua') {
      return widget.tasks;
    }
    return widget.tasks
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
              hintText: "Masukkan kategori baru",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () {
                final newCategory = categoryController.text.trim();
                if (newCategory.isNotEmpty &&
                    !categories.contains(newCategory)) {
                  setState(() {
                    categories.add(newCategory);
                  });
                  Navigator.pop(context);
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
            fontWeight: FontWeight.bold,
            color: ColorCollection.primary900,
          ),
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
                          child: RawChip(
                            label: Text(
                              categories[index],
                              style: TextStyle(
                                color: selectedCategory == categories[index]
                                    ? ColorCollection.primary100
                                    : ColorCollection.primary900,
                              ),
                            ),
                            showCheckmark: false,
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
              child: filteredTasks.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            '../assets/images/kategori.png',
                            width: 400,
                            height: 400,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Belum ada tugas nih',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: ColorCollection.primary900),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            selectedCategory == 'Semua'
                                ? "Belum ada tugas buat kamu sekarang"
                                : "Belum ada tugas buat kategori \"$selectedCategory\"",
                            style: const TextStyle(
                              fontSize: 16,
                              color: ColorCollection.neutral600,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredTasks.length,
                      itemBuilder: (context, index) {
                        final task = filteredTasks[index];
                        return TugasCard(
                          task: task,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailTugas(
                                  task: task,
                                  onTaskUpdated: widget.updateTask,
                                  onTaskDeleted: () => widget.deleteTask(task),
                                  onTaskCompleted: () =>
                                      widget.completeTask(task),
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
