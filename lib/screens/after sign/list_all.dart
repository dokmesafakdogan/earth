import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:earth/screens/after%20sign/place_detail.dart';
import 'package:flutter/material.dart';

class AllScreen extends StatelessWidget {
  const AllScreen({super.key});

 
  Future<QuerySnapshot<Map<String, dynamic>>> abc() async {
    final FirebaseFirestore firestoree = FirebaseFirestore.instance;
    return await firestoree.collection('places').get();
  }
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ALl DESTINATIONS',
          style: TextStyle(fontSize: 28),
        ),
        
      ),
      body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
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
        
      );
    
  }
}