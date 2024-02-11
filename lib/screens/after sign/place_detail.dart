import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.place, required this.placesID});

  final DocumentSnapshot<Map<String, dynamic>> place;
  final String placesID;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    checkFavoriteStatus();
  }

  void checkFavoriteStatus() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot favoriteSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('favorites')
          .doc(widget.placesID)
          .get();

      setState(() {
        isFavorite = favoriteSnapshot.exists;
      });
    }
  }

  void addToFavorites() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('favorites')
          .doc(widget.placesID)
          .set({
        'added_at': DateTime.now(),
      });

      setState(() {
        isFavorite = true;
      });
    }
  }

  void removeFromFavorites() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('favorites')
          .doc(widget.placesID)
          .delete();

      setState(() {
        isFavorite = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.place['place-name'],
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : null,
            ),
            onPressed: () {
              if (isFavorite) {
                removeFromFavorites();
              } else {
                addToFavorites();
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Image.network(
              widget.place['imageUrl'],
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 12,),
            const Text(
              'Country information',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 12,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 23),
              child: Text(widget.place['info']),
            )
          ],
        ),
      ),
    );
  }
}
