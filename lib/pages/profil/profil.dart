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
  String name = "Budiono Siregar";
  String email = "budi123@gmail.com";

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
              onPressed: () {
                setState(() {
                  name = nameController.text;
                  email = emailController.text;
                });
                Navigator.of(context).pop();
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
                          leftTitles: AxisTitles(),
                          rightTitles: AxisTitles(),
                          topTitles: AxisTitles(),
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
                      child: SizedBox(
                    width: double.infinity,
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
                  )),
                  const SizedBox(
                    height: 24,
                  ),
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
    // Distribute completed tasks over the last 7 days
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
                  color: Colors.blue,
                  width: 16,
                ),
              ],
            ))
        .toList();
  }

  Widget _buildSummaryCard(
      String title, String value, String subtitle, Color color) {
    return Expanded(
      child: Container(
        height: 130,
        decoration: BoxDecoration(
          color: ColorCollection.neutral200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            if (subtitle.isNotEmpty)
              Text(
                subtitle,
                style: const TextStyle(
                    fontSize: 14, color: ColorCollection.neutral600),
              ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
