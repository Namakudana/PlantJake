import 'package:flutter/material.dart';
// import 'package:plantjake/detailscreen.dart';
// import 'package:plantjake/favoritedetail.dart';
// import 'package:plantjake/home.dart';
import 'package:plantjake/splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Splash(),
      //home: MyHomePage(title: '',),
      //home: DetailScreen(label: '',  description: '', confidence: 0.0,),
      //home: FavoriteDetail(favoriteItem: '',),
    );
  }
}
