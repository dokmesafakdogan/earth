import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:earth/screens/after%20sign/place_detail.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

 
  Future<QuerySnapshot<Map<String, dynamic>>> abc() async {
    final FirebaseFirestore firestoree = FirebaseFirestore.instance;
    return await firestoree.collection('places').get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> dfg() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    return await firestore
        .collection('places')
        .where('isPopular', isEqualTo: true)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Popular Destination',
          style: TextStyle(fontSize: 28),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Show All'),
          )
        ],
      ),
      body: Column(
        children: [
          FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
            future: dfg(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final items = snapshot.data!.docs;
                return SizedBox(
                  height: 220,
                  child: ListView.builder(
                    itemCount: items.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailScreen(
                                place: items[index],
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
                              image: NetworkImage(items[index]['imageUrl']),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                bottom: 23, left: 4, top: 8),
                            child: Text(
                              items[index]['place-name'],
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
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'All Destinations',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(
                width: 125,
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Show All',
                  style: TextStyle(color: Colors.blueGrey),
                ),
              )
            ],
          ),
          FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
            future: abc(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final items = snapshot.data!.docs;
                return Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                         Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailScreen(
                                place: items[index],),),);
                        },
                        child: Container(
                          height: 149,
                          width: 200,
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: NetworkImage(items[index]['imageUrl']),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                bottom: 23, left: 4, top: 8),
                            child: Text(
                              items[index]['place-name'],
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
                  ),
                );
              }
              return const CircularProgressIndicator.adaptive();
            },
          ),
        ],
      ),
    );
  }
}