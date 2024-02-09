// ignore_for_file: use_build_context_synchronously, unused_local_variable

import 'package:earth/main.dart';
import 'package:earth/screens/notifier/auth_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isPasswordVisible = false;

  final RegExp _emailRegExp = RegExp(
    r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
  );

  String? _validateEmail(String? email) {
    if (email == null || !_emailRegExp.hasMatch(email)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? password) {
    if (password == null || password.length < 6) {
      return 'Password should have at least 6 characters';
    }
    return null;
  }

  void validate() {
    _formKey.currentState!.validate();
  }


    void _login()async {
      try{
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text
          );
        //  print("User logged in with UID: ${userCredential.user!.uid}");
          AuthManager.instance.setUserUuid(userCredential.user!.uid);
           Navigator.of(context).pushNamedAndRemoveUntil(RouteEnums.customNavigationBar.name, (route) => false);
      } catch (e){
        
        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login failed. Please check your credentials.'),
          ),
        );
      }
    }
    Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
      Navigator.of(context).pushNamedAndRemoveUntil(RouteEnums.customNavigationBar.name, (route) => false);
    } catch (error) {
     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Something went wrong')));
    }
  }






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFC0C0C0),
      ),
      backgroundColor: const Color(0xFFC0C0C0),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 30, right: 264),
              child: Text(
                'Log in',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton(
                  style: const ButtonStyle(
                      fixedSize: MaterialStatePropertyAll(
                        Size(167, 50),
                      ),
                      elevation: MaterialStatePropertyAll(8),
                      backgroundColor: MaterialStatePropertyAll(Colors.white)),
                  onPressed: _handleSignIn,
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/images/google.svg',
                        width: 24,
                        height: 24,
                      ),
                      const SizedBox(
                        width: 23,
                      ),
                      const Text(
                        'Google',
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 23),
                FilledButton(
                    style: const ButtonStyle(
                        fixedSize: MaterialStatePropertyAll(
                          Size(167, 50),
                        ),
                        backgroundColor:
                            MaterialStatePropertyAll(Color(0xFF3498DB)),
                        elevation: MaterialStatePropertyAll(8)),
                    onPressed: () {},
                    child: const Row(children: [
                      Text(
                        'f',
                        style: TextStyle(fontSize: 28),
                      ),
                      SizedBox(
                        width: 28,
                      ),
                      Text(
                        'Facebook',
                        style: TextStyle(fontSize: 16),
                      )
                    ])),
              ],
            ),
            const SizedBox(
              height: 37,
            ),
            const Text('Or log in using'),
            const SizedBox(
              height: 36,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 30, left: 30),
              child: TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50)),
                  hintText: 'Mail',
                ),
                validator: _validateEmail,
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.only(right: 30, left: 30),
              child: TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50)),
                    hintText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  obscureText: !_isPasswordVisible,
                  keyboardType: TextInputType.text,
                  validator: _validatePassword),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 200),
              child: TextButton(
                  onPressed: () {}, child: const Text('Forgot your password?')),
            ),
            FilledButton(
              style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                    Color(0xFF00CEC9),
                  ),
                  fixedSize: MaterialStatePropertyAll(Size(354, 50))),
              onPressed: _login,
              child: const Text(
                'Log in',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 130),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Do not have a account yet?'),
                  TextButton(
                      onPressed: () => Navigator.of(context)
                          .pushReplacementNamed(RouteEnums.signUpScreen.name),
                      child: const Text('Sign up'))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
