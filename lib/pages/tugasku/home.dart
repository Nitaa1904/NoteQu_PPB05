import 'package:flutter/material.dart';
import 'package:notequ/design_system/widget/bottomnav/bottom_nav.dart';
import 'package:notequ/pages/tugasku/tugasku.dart';
import 'package:notequ/pages/kategori/kategori.dart';
import 'package:notequ/pages/kalender/kalender.dart';
import 'package:notequ/pages/profil/profil.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BottomNavbar(
        tugasku: Tugasku(),
        kategori: Kategori(),
        kalender: Kalender(),
        profil: Profil(),
      ),
    );
  }
}
