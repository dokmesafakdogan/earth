import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.place});

  final QueryDocumentSnapshot<Map<String, dynamic>> place;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {


  
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
            onPressed: (){
               
            }, 
          icon: const Icon(Icons.favorite)
          )
        ],
      ),
      body: Center(
        
        child: Column(
          children: [
            Image.network(
              widget.place['imageUrl'], // Accessing imageUrl from place snapshot
              width: double.infinity, // Set width as needed
              height: 200, // Set height as needed
              fit: BoxFit.cover, // Adjust the image fit as needed
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

