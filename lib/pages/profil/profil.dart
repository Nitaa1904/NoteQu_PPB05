import 'package:flutter/material.dart';
import 'package:notequ/design_system/styles/color.dart';
import 'package:notequ/pages/accountregist/signup.dart';

class Profil extends StatelessWidget {
  final int completedTasks;
  final int pendingTasks;

  const Profil({
    super.key,
    required this.completedTasks,
    required this.pendingTasks,
  });

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
            // Bagian header dengan background full width
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
                  const Text(
                    "Budiono Siregar",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: ColorCollection.primary100,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "budi123@gmail.com",
                    style: TextStyle(
                        fontSize: 14, color: ColorCollection.neutral500),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Tambahkan logika edit profil
                    },
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
                        completedTasks.toString(),
                        "dari ${(completedTasks + pendingTasks).toString()}",
                        ColorCollection.primary900,
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      _buildSummaryCard(
                        "Tugas Tertunda",
                        pendingTasks.toString(),
                        "",
                        ColorCollection.primary900,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Grafik Penyelesaian Tugas",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: ColorCollection.neutral200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: completedTasks > 0
                          ? Text(
                              "${((completedTasks / (completedTasks + pendingTasks)) * 100).toStringAsFixed(1)}% Tugas Selesai",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: ColorCollection.accentGreen,
                              ),
                            )
                          : const Text(
                              "Belum ada tugas selesai",
                              style: TextStyle(
                                  color: ColorCollection.neutral600,
                                  fontSize: 16),
                            ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Center(
                      child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Tambahkan logika logout
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
