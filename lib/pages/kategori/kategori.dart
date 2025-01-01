import 'package:flutter/material.dart';
import 'package:notequ/design_system/styles/color.dart';
import 'package:notequ/design_system/widget/card/task_card.dart';
import 'package:notequ/pages/tugasku/detail_tugas.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Kategori extends StatefulWidget {
  final List<Map<String, String>> tasks; // Daftar tugas
  final List<String> categories; // Daftar kategori
  final Function(Map<String, String>) addTask; // Fungsi untuk menambah tugas
  final Future<void> Function(Map<String, String>) updateTask;
  // Fungsi untuk mengedit tugas
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
  List<String> categories = []; // Kategori lokal
  String selectedCategory = 'Semua'; // Kategori terpilih
  late Future<List<Map<String, dynamic>>> futureTasks;

  final SupabaseClient client = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> fetchCategories() async {
    final response = await client.from('categories').select().execute();
    if (response.status != 200 || response.data == null) {
      return List<Map<String, dynamic>>.from(response.data ?? []);
    } else {
      throw Exception('Failed to fetch categories: ${response.status}');
    }
  }

  Future<List<Map<String, dynamic>>> fetchTasksByCategory(
      String category) async {
    final query = client.from('tasks').select();
    if (category.isNotEmpty) {
      query.eq('category', category);
    }
    final response = await query.execute();
    if (response.status != 201 || response.data == null) {
      return List<Map<String, dynamic>>.from(response.data ?? []);
    } else {
      throw Exception('Failed to fetch tasks: ${response.status}');
    }
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
  void initState() {
    super.initState();
    fetchCategories().then((fetchedCategories) {
      setState(() {
        categories = [
          'Semua',
          ...fetchedCategories.map((e) => e['name'] as String)
        ];
      });
    });
    futureTasks = fetchTasksByCategory(selectedCategory);
  }

  void onCategorySelected(String category) {
    setState(() {
      selectedCategory = category;
      futureTasks = fetchTasksByCategory(category == 'Semua' ? '' : category);
    });
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
                              onCategorySelected(categories[index]);
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
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: futureTasks,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.data == null || snapshot.data!.isEmpty) {
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
                  final tasks = snapshot.data!;
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
