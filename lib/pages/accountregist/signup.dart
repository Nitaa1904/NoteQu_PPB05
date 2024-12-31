// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notequ/design_system/styles/color.dart';
import 'package:notequ/design_system/widget/field/input_field.dart';
import 'package:notequ/pages/accountregist/login.dart';
import 'package:notequ/pages/tugasku/home.dart';
// import 'package:notequ/services/auth_service.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // final AuthService _authService = AuthService();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorCollection.primary900,
        title: const Text('NoteQu',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: ColorCollection.primary100)),
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
                "Sign Up",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: ColorCollection.primary100,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Selamat datang! Buat akun dulu ya!",
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
                      hintText: "Masukkan Nama",
                      controller: _nameController,
                    ),
                    const SizedBox(height: 12),
                    InputField(
                      hintText: "Masukkan Email",
                      controller: _emailController,
                    ),
                    const SizedBox(height: 12),
                    InputField(
                      obscureText: true,
                      hintText: "Buat Password",
                      controller: _passwordController,
                    ),
                    const SizedBox(height: 24),
                    // Tombol utama
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 24),
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
                                  builder: (context) => const Homepage()));
                        },
                        child: const Text(
                          "Buat Akun",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Divider dengan teks "atau"
              const Row(
                children: [
                  Expanded(
                    child: Divider(color: ColorCollection.neutral400),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.0),
                    child: Text(
                      "atau",
                      style: TextStyle(color: ColorCollection.neutral500),
                    ),
                  ),
                  Expanded(
                    child: Divider(color: ColorCollection.neutral400),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Tombol Google Sign-In
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: Image.asset(
                    '../assets/images/icon-google.png',
                    width: 24,
                    height: 24,
                  ),
                  label: const Text(
                    "Masuk dengan Google",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 24),
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
                    "Sudah punya akun?",
                    style: TextStyle(color: ColorCollection.neutral500),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                      );
                    },
                    child: const Text(
                      "Masuk Akun",
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

  // void _SignUp() async {
  //   String name = _nameController.text;
  //   String email = _emailController.text;
  //   String password = _passwordController.text;

  //   User? user = await _authService.signUpWithEmailAndPassword(email, password);

  //   if (user != null) {
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => Homepage(),
  //       ),
  //     );
  //   } else {
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text('Gagal Membuat Akun')));
  //   }
  // }
}
