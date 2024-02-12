import 'package:earth/screens/after%20sign/favorites_screen.dart';
import 'package:earth/screens/after%20sign/home_screen.dart';
import 'package:earth/screens/profile/profile_screen.dart';
import 'package:earth/screens/before%20sign/intro_screen.dart';
import 'package:earth/screens/before%20sign/login_screen.dart';
import 'package:earth/screens/before%20sign/sign_screen.dart';
import 'package:earth/screens/before%20sign/start_screen.dart';
import 'package:earth/widgets/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});
  final GoogleSignIn googleSignIn = GoogleSignIn(
    clientId:
        '79314296769-oja2kkim1sm3nj7uub56saubie12u5pi.apps.googleusercontent.com',
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const StartScreen(),
      routes: {
        RouteEnums.startScreen.name:(context) => const StartScreen(),
        RouteEnums.loginScreen.name: (context) => const LoginScreen(),
        RouteEnums.signUpScreen.name: (context) => const SignupScreen(),
        RouteEnums.introScreen.name: (context) => const IntroScreen(),
        RouteEnums.homeScreen.name: (context) => const HomeScreen(),
        RouteEnums.favoritesScreen.name: (context) => const FavoritesScreen(),
        RouteEnums.profileScreenWrapper.name: (context) => const ProfileScreen(),
        RouteEnums.customNavigationBar.name: (context) =>
            const CustomNavigationBar(
              destinations: [
                HomeScreen(),
                FavoritesScreen(),
                ProfileScreen(),
              ],
            ),
      },
    );
  }
}

enum RouteEnums {
  loginScreen,
  signUpScreen,
  homeScreen,
  introScreen,
  favoritesScreen,
  profileScreenWrapper,
  customNavigationBar,
  startScreen,
}
