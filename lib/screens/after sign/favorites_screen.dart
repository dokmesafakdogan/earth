import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:earth/screens/after%20sign/place_detail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Favorites'),),
    
    body:
    
    
     StreamBuilder<List<String>>(
      stream: getUserFavorites(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('No favorite items.'),
          );
        }

        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              future: getPlaceDetails(snapshot.data![index]),
              builder: (context, placeSnapshot) {
                if (placeSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (placeSnapshot.hasError) {
                  return Center(
                    child: Text('Error: ${placeSnapshot.error}'),
                  );
                }

                if (!placeSnapshot.hasData || !placeSnapshot.data!.exists) {
                  return const SizedBox(); // Placeholder widget
                }

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(
                          place: placeSnapshot.data!,
                          placesID: snapshot.data![index],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: 149,
                    width: 200,
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: NetworkImage(placeSnapshot.data!['imageUrl']),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 23, left: 4, top: 8),
                      child: Text(
                        placeSnapshot.data!['place-name'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    )
    );
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getPlaceDetails(String placeId) async {
    return await FirebaseFirestore.instance.collection('places').doc(placeId).get();
  }

  Stream<List<String>> getUserFavorites() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      CollectionReference favoritesRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('favorites');

      return favoritesRef.snapshots().map(
            (snapshot) => snapshot.docs.map((doc) => doc.id).toList(),
          );
    } else {
      // Handle user not signed in
      return const Stream.empty();
    }
  }
}
