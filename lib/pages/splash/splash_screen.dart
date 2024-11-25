import 'package:flutter/material.dart';
import 'package:notequ/design_system/styles/color.dart';
import 'package:notequ/pages/tugasku/home.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:notequ/pages/tugasku/tugasku.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    redirect();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: ColorCollection.primary900,
      body: Center(
        child:
            // SvgPicture.asset(
            //   "assets/bubblesbg.svg",
            // ),
            Text(
          "NoteQu",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: ColorCollection.primary100,
          ),
        ),
      ),
    );
  }

  Future<void> redirect() async {
    await Future.delayed(const Duration(seconds: 3));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (BuildContext context) => const Homepage()),
    );
  }
}
