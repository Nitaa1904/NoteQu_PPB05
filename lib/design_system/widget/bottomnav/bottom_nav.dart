import 'package:flutter/material.dart';
import 'package:notequ/design_system/styles/color.dart';

class BottomNavbar extends StatefulWidget {
  final Widget tugasku;
  final Widget kategori;
  final Widget kalender;
  final Widget profil;

  const BottomNavbar(
      {super.key,
      required this.tugasku,
      required this.kategori,
      required this.kalender,
      required this.profil});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int selectedIndex = 0;
  // static const TextStyle optionStyle =
  //     TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  List<Widget> get widgetOptions =>
      [widget.tugasku, widget.kategori, widget.kalender, widget.profil];

  void onTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: widgetOptions[selectedIndex],
        ),
      ),
      bottomNavigationBar: Container(
        height: 80,
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: ColorCollection.neutral400,
              blurRadius: 12.0,
              offset: Offset(0.0, 0.2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: onTapped,
          currentIndex: selectedIndex,
          selectedItemColor: ColorCollection.primary900,
          unselectedItemColor: ColorCollection.neutral500,
          backgroundColor: ColorCollection
              .primary100,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Tugasku'),
            BottomNavigationBarItem(
                icon: Icon(Icons.category), label: 'Kategori'),
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today), label: 'Kalender'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
          ],
        ),
      ),
    );
  }
}
