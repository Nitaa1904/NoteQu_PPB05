import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:notequ/design_system/styles/color.dart';
import 'package:notequ/design_system/widget/field/input_field.dart';
import 'package:notequ/pages/accountregist/login.dart';
import 'package:notequ/pages/tugasku/home.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Fungsi untuk login dengan Google
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await FirebaseAuth.instance.signInWithCredential(credential);

        // Navigasi ke Homepage setelah login berhasil
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Homepage()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login dengan Google gagal: $e")),
      );
    }
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
                      controller: nameController,
                    ),
                    const SizedBox(height: 12),
                    InputField(
                      hintText: "Masukkan Email",
                      controller: emailController,
                    ),
                    const SizedBox(height: 12),
                    InputField(
                      obscureText: true,
                      hintText: "Buat Password",
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
                  onPressed: () => signInWithGoogle(context),
                  // icon: Image.asset(
                  //   'assets/images/icon_google.png',
                  // ),
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
}
