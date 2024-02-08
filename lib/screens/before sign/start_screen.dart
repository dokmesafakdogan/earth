import 'package:earth/main.dart';

import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/img.png"),
            fit: BoxFit.fill,
          ),
        ),
        alignment: Alignment.center,
        child: Column(
          children: [
            const SizedBox(height: 139),
            Image.asset('assets/images/building 1.png'),
            const Text(
              'Peshot',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 44,
                  fontWeight: FontWeight.bold),
            ),
            const Text('Welcome to peshot'),
            const Text('Book easy and cheap hotels only on peshot'),
            const SizedBox(height: 470),
            FilledButton(
              style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                    Color(0xFF00CEC9),
                  ),
                  fixedSize: MaterialStatePropertyAll(Size(354, 52))),
              onPressed: ()=>Navigator.of(context).pushNamedAndRemoveUntil(RouteEnums.introScreen.name,(context)=>false),
              child: const Text('Lets Start'),
            )
          ],
        ),
      ),
    );
  }
}
