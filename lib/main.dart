// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notequ/pages/splash/splash_screen.dart';
// import 'package:notequ/pages/tugasku/home.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();

  tz.initializeTimeZones();

  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://ghvhnzmuhazipuiehckv.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imdodmhuem11aGF6aXB1aWVoY2t2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzU3MTExNjgsImV4cCI6MjA1MTI4NzE2OH0.1MNF_GxLE4hufUc5CO2sssvgE3nXJ5TpsY89iEiBx5o',
  );

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
