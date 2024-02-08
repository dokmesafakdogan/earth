import 'package:earth/main.dart';

import 'package:flutter/material.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(
            height: 72,
          ),
          Center(
            child: Image.asset('assets/images/Frame 1.png'),
          ),
          const SizedBox(height: 113),
          const Text(
            'Plan your trip',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 33),
          const Text('Costum and fast planning'),
          const Text('with a low price'),
          const SizedBox(height: 110),
          FilledButton(
            style: const ButtonStyle(
              elevation: MaterialStatePropertyAll(3),
              fixedSize: MaterialStatePropertyAll(Size(354, 52)),
              backgroundColor: MaterialStatePropertyAll(
                Color(0xFF00CEC9),
              ),
            ),
            onPressed: ()=>Navigator.of(context).pushNamed(RouteEnums.loginScreen.name),
            child: const Text(
              'Log in',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 18),
          FilledButton(
            style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.white),
                fixedSize: MaterialStatePropertyAll(Size(354, 52)),
                elevation: MaterialStatePropertyAll(3)),
            onPressed: ()=>Navigator.of(context).pushNamed(RouteEnums.signUpScreen.name),
            child: const Text(
              'Create account',
              style: TextStyle(fontSize: 22, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
