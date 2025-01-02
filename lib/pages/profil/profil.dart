import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:notequ/design_system/styles/color.dart';
import 'package:notequ/pages/accountregist/signup.dart';

class Profil extends StatefulWidget {
  final int completedTasks;
  final int pendingTasks;

  const Profil({
    super.key,
    required this.completedTasks,
    required this.pendingTasks,
  });

  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  String name = "Nita Fitrotul Mar'ah";
  String email = "nita@gmail.com";
  Map<String, dynamic>? userProfile;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  // Fungsi untuk memuat data profil dari API
  Future<void> _loadUserProfile() async {
    try {
      const String userId = "your_user_id"; // Ganti dengan ID pengguna Anda
      final profile = await fetchUserProfile(userId);
      setState(() {
        userProfile = profile;
        name = profile['name'] ?? "Nama Tidak Diketahui";
        email = profile['email'] ?? "Email Tidak Diketahui";
      });
    } catch (e) {
      print("Error loading user profile: $e");
    }
  }

  // Fungsi untuk memperbarui profil
  Future<void> _updateUserProfile() async {
    try {
      const String userId = "your_user_id"; // Ganti dengan ID pengguna Anda
      final updates = {'name': name, 'email': email};
      await updateUserProfile(userId, updates);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profil berhasil diperbarui")),
      );
    } catch (e) {
      print("Error updating user profile: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal memperbarui profil")),
      );
    }
  }

  // Fungsi untuk menampilkan dialog Edit Profil
  void _editProfile() {
    final TextEditingController nameController =
        TextEditingController(text: name);
    final TextEditingController emailController =
        TextEditingController(text: email);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Profil"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Nama"),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.trim().isEmpty ||
                    emailController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Nama dan email tidak boleh kosong")),
                  );
                  return;
                }
                setState(() {
                  name = nameController.text;
                  email = emailController.text;
                });
                Navigator.of(context).pop();
                await _updateUserProfile();
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
    if (userProfile == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profilku",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: ColorCollection.primary900),
        ),
        elevation: 4.0,
        shadowColor: ColorCollection.primary900.withOpacity(0.3),
        backgroundColor: ColorCollection.primary100,
      ),
      backgroundColor: ColorCollection.primary100,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Bagian header
            Container(
              width: double.infinity,
              color: ColorCollection.primary900,
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/images/profile.jpeg'),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: ColorCollection.primary100,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    email,
                    style: const TextStyle(
                        fontSize: 14, color: ColorCollection.neutral500),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _editProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorCollection.primary100,
                      foregroundColor: ColorCollection.primary900,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text("Edit Profil"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Ringkasan tugas
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Ringkasan Tugas Kamu",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: ColorCollection.primary900),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSummaryCard(
                        "Tugas Selesai",
                        widget.completedTasks.toString(),
                        "dari ${(widget.completedTasks + widget.pendingTasks).toString()}",
                        ColorCollection.primary900,
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      _buildSummaryCard(
                        "Tugas Tertunda",
                        widget.pendingTasks.toString(),
                        "",
                        ColorCollection.primary900,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Grafik Penyelesaian Tugas (7 Hari Terakhir)",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 200,
                    color: Colors.grey[200],
                    child: BarChart(
                      BarChartData(
                        barGroups: _generateTaskCompletionData(),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                final days = [
                                  'Mon',
                                  'Tue',
                                  'Wed',
                                  'Thu',
                                  'Fri',
                                  'Sat',
                                  'Sun'
                                ];
                                return Text(
                                  days[value.toInt()],
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.black,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        gridData: FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                        barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              return BarTooltipItem(
                                "${rod.toY.toInt()} tasks completed",
                                const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpPage()));
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        backgroundColor: ColorCollection.accentRed,
                        foregroundColor: ColorCollection.primary100,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("Logout"),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Center(
                    child: Text(
                      'versi 1.0.0',
                      style: TextStyle(
                          fontSize: 14, color: ColorCollection.neutral600),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<BarChartGroupData> _generateTaskCompletionData() {
    List<int> dailyTasks = List.filled(7, 0);
    int remainingTasks = widget.completedTasks;

    for (int i = 0; i < 7 && remainingTasks > 0; i++) {
      dailyTasks[i] = (remainingTasks / (7 - i)).ceil();
      remainingTasks -= dailyTasks[i];
    }

    return dailyTasks
        .asMap()
        .entries
        .map((entry) => BarChartGroupData(
              x: entry.key,
              barRods: [
                BarChartRodData(
                  toY: entry.value.toDouble(),
                  color: ColorCollection.primary900,
                  width: 15,
                )
              ],
            ))
        .toList();
  }

  Widget _buildSummaryCard(
      String title, String value, String subtitle, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 14, color: color),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            if (subtitle.isNotEmpty)
              Text(
                subtitle,
                style: const TextStyle(
                    fontSize: 10, color: ColorCollection.neutral600),
              ),
          ],
        ),
      ),
    );
  }
}

// Ganti fungsi-fungsi ini dengan implementasi nyata untuk memanggil API Anda
Future<Map<String, dynamic>> fetchUserProfile(String userId) async {
  // Simulasi data. Ganti dengan API asli.
  return Future.delayed(
    const Duration(seconds: 1),
    () => {'name': 'Budiono Siregar', 'email': 'budi123@gmail.com'},
  );
}

Future<void> updateUserProfile(
    String userId, Map<String, dynamic> updates) async {
  // Simulasi pembaruan. Ganti dengan API asli.
  await Future.delayed(const Duration(seconds: 1));
}
