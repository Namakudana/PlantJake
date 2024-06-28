import 'package:flutter/material.dart';
import 'package:plantjake/favoriteitempage.dart';
import 'package:plantjake/home.dart';
import 'package:plantjake/test.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _bottomNavCurrentIndex = 0;
  final List<Widget> _container = [
    const MyHomePage(
      title: 'PlantJake',
    ),
    const FavoriteItemPage(),
    const PlantList(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _container[_bottomNavCurrentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _bottomNavCurrentIndex = index;
          });
        },
        currentIndex: _bottomNavCurrentIndex,
        selectedItemColor: const Color(0xFF4F6F52),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(
          color: Color(0xFF4F6F52),
        ),
        unselectedLabelStyle: const TextStyle(
          color: Colors.grey,
        ),
        backgroundColor:
            const Color(0xFFFFFFFF), // Menambahkan warna latar belakang
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorit',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'Artikel',
          ),
        ],
      ),
    );
  }
}
