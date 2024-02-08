import 'package:flutter/material.dart';

class FavoritesScreen extends StatelessWidget{
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
   return Scaffold(
    appBar: AppBar(
      title: const Text(
        'Your Favorites',
        style: TextStyle(fontSize: 28),
      ),
    ),
   );
   
  }
}