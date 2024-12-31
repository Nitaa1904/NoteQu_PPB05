// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notequ/pages/splash/splash_screen.dart';
// import 'package:notequ/pages/tugasku/home.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();

  tz.initializeTimeZones();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NoteQu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: const SplashScreen(),
    );
  }
}
