import 'package:flutter/material.dart';
import 'package:notequ/design_system/styles/color.dart';
import 'package:notequ/design_system/widget/field/input_field.dart';
import 'package:notequ/pages/accountregist/signup.dart';
import 'package:notequ/pages/tugasku/home.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorCollection.primary900,
        title: const Text(
          'NoteQu',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: ColorCollection.primary100,
          ),
        ),
      ),
      backgroundColor: ColorCollection.primary900, // Warna latar belakang
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              const Text(
                "Login",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: ColorCollection.primary100,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Selamat datang kembali! Silakan masuk akunmu!",
                style: TextStyle(color: ColorCollection.neutral500),
              ),
              const SizedBox(height: 40),
              // Form input
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: ColorCollection.primary100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    InputField(
                      hintText: "Masukkan Email",
                      controller: emailController,
                    ),
                    const SizedBox(height: 12),
                    InputField(
                      obscureText: true,
                      hintText: "Masukkan Password",
                      controller: passwordController,
                    ),
                    const SizedBox(height: 24),
                    // Tombol utama
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          backgroundColor: ColorCollection.primary900,
                          foregroundColor: ColorCollection.primary100,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Homepage(),
                            ),
                          );
                        },
                        child: const Text(
                          "Masuk Akun",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Divider dengan teks "atau"
              const Row(
                children: [
                  Expanded(
                    child: Divider(color: ColorCollection.neutral500),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.0),
                    child: Text(
                      "atau",
                      style: TextStyle(color: ColorCollection.neutral500),
                    ),
                  ),
                  Expanded(
                    child: Divider(color: ColorCollection.neutral500),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Tombol media sosial
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Tambahkan logika login Google
                  },
                  // icon: Image.asset('assets/images/icon_google.png'),
                  label: const Text(
                    "Masuk dengan Google",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    backgroundColor: ColorCollection.primary100,
                    foregroundColor: ColorCollection.primary900,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Footer dengan link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Belum punya akun?",
                    style: TextStyle(color: ColorCollection.neutral500),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  SignUpPage())); // Kembali ke halaman SignUp
                    },
                    child: const Text(
                      "Daftar Akun",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
