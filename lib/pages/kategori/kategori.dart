import 'package:flutter/material.dart';
import 'package:notequ/design_system/styles/color.dart';
import 'package:notequ/design_system/widget/card/task_card.dart';
import 'package:notequ/pages/tugasku/detail_tugas.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:notequ/pages/tugasku/custom_alert.dart';

class Kategori extends StatefulWidget {
  final List<Map<String, String>> tasks; // Daftar tugas
  final List<String> categories;
  final Function(Map<String, String>) addTask; // Fungsi untuk menambah tugas
  final Future<void> Function(Map<String, String>) updateTask;
  final Function(Map<String, String>) deleteTask;
  final Function(Map<String, String>) completeTask;

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
  List<Map<String, dynamic>> categories = [];
  String selectedCategory = 'Semua';
  late Future<List<Map<String, dynamic>>> futureTasks;
  final SupabaseClient client = Supabase.instance.client;
  final TextEditingController _categoryController = TextEditingController();

  Future<void> addCategory(String name) async {
    try {
      await client.from('categories').insert({'name': name}).execute();
      await fetchCategories();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menambahkan kategori: $error')),
      );
    }
  }

  Future<void> fetchCategories() async {
    final response = await client.from('categories').select().execute();
    if (response.status == 200 && response.data != null) {
      setState(() {
        categories = List<Map<String, dynamic>>.from(response.data);
      });
    }
  }

  Future<List<Map<String, dynamic>>> fetchTasksByCategory(
      String? categoryId) async {
    final query = client.from('tasks').select();
    if (categoryId != null && categoryId.isNotEmpty) {
      query.eq('category_id', categoryId);
    }
    final response = await query.execute();
    if (response.status == 200 && response.data != null) {
      return List<Map<String, dynamic>>.from(response.data);
    }
    return [];
  }

  void showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) => CustomAlert(
        categories: categories,
        onAddTask: (task) async {
          // Tambahkan logika untuk menambah tugas di sini
          await widget.addTask(
              task.map((key, value) => MapEntry(key, value.toString())));
          setState(() {
            futureTasks = fetchTasksByCategory(
                selectedCategory.isEmpty ? null : selectedCategory);
          });
        },
        onCategorySelected: (selectedId) {
          setState(() {
            selectedCategory = selectedId;
          });
        },
        onAddCategory: addCategory,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchCategories();
    futureTasks = fetchTasksByCategory(null);
  }

  void onCategorySelected(String categoryId) {
    setState(() {
      final selected = categories.firstWhere(
        (category) => category['id'] == categoryId,
        orElse: () => {'name': 'Semua'},
      );
      selectedCategory = selected['name'] as String? ?? 'Semua';
      futureTasks =
          fetchTasksByCategory(categoryId.isEmpty ? null : categoryId);
    });
  }

  void _showAddCategoryDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          title: const Text("Tambah Kategori Baru"),
          content: TextField(
            controller: _categoryController,
            decoration: const InputDecoration(
              hintText: "Masukkan nama kategori",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_categoryController.text.isNotEmpty) {
                  try {
                    await addCategory(_categoryController.text);
                    Navigator.pop(context);
                  } catch (error) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Gagal menambahkan kategori: $error')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Nama kategori tidak boleh kosong')),
                  );
                }
              },
              child: const Text("Tambah"),
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
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: RawChip(
                            label: Text(
                              category['name'] ?? 'Unknown',
                              style: TextStyle(
                                color: selectedCategory == category['id']
                                    ? ColorCollection
                                        .primary100 // Warna teks ketika dipilih
                                    : ColorCollection
                                        .primary900, // Warna teks default),
                              ),
                            ),
                            selected: selectedCategory == category['id'],
                            selectedColor: ColorCollection.primary900,
                            backgroundColor: ColorCollection.primary100,
                            onSelected: (isSelected) {
                              // onCategorySelected(
                              //     isSelected ? category['id'] : '');
                              setState(() {
                                selectedCategory =
                                    isSelected ? category['id'] : null;
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.add,
                    color: ColorCollection.primary900,
                  ),
                  onPressed: _showAddCategoryDialog,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: futureTasks,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
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
                              color: ColorCollection.primary900,
                            ),
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
                    );
                  }
                  final tasks = snapshot.data ?? [];
                  if (tasks.isEmpty) {
                    return const Center(child: Text('Belum ada tugas.'));
                  }
                  return ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index]
                          .map((key, value) => MapEntry(key, value.toString()));
                      return TugasCard(
                        task: task,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailTugas(
                                task: task,
                                onTaskUpdated: (updatedTask) =>
                                    widget.updateTask(updatedTask),
                                onTaskDeleted: () => widget.deleteTask(task),
                                onTaskCompleted: () =>
                                    widget.completeTask(task),
                              ),
                            ),
                          );
                        },
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
