

// ignore_for_file: use_build_context_synchronously

import 'package:earth/screens/notifier/auth_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:earth/main.dart';


final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isPasswordVisible = false;

  String? _validateEmail(String? email) {
    if (email == null || !RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$').hasMatch(email)) {
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

  Future<void> _signUp() async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

     
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': _nameController.text,
        'surname': _surnameController.text,
        'email': _emailController.text,
        'imageUrl': '',
      });

      AuthManager.instance.setUserUuid(userCredential.user!.uid);

      Navigator.of(context).pushNamedAndRemoveUntil(RouteEnums.customNavigationBar.name, (route) => false);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Login failed. Please check your credentials.'),
        ));
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('The account already exists for that email.'),
        ));
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential authResult = await _auth.signInWithCredential(credential);
      // ignore: unused_local_variable
      final User? user = authResult.user;
      

      await _firestore.collection('users').doc(user!.uid).set(
            UserRequestModel(
              email: user.email ?? '',
              name: user.displayName ?? '',
              surname: user.displayName ?? '',
              imageUrl: user.photoURL ?? '',
            ).toJson(),
          );
      AuthManager.instance.setUserUuid(user.uid);
     // print("User Name: ${user!.displayName}");
      Navigator.of(context).pushNamedAndRemoveUntil(RouteEnums.customNavigationBar.name, (route) => false);
    } catch (error) {
    //  print(error);
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
            const Padding(
              padding: EdgeInsets.only(top: 20, right: 264),
              child: Text(
                'Sign in',
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
                  onPressed:() async {
                   await _handleGoogleSignIn();
                  },
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
            const Text('Or sign up using'),
            const SizedBox(
              height: 36,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: TextFormField(
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    hintText: 'Name'),
                controller: _nameController,
                //onSaved: (value) {
                  //_enteredName = value!;
             //   },
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: TextFormField(
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    hintText: 'Surname'),
                controller: _surnameController,
                // onSaved: (value) {
                //   _enteredSurname =value!;
                // },
              ),
            ),
            const SizedBox(height: 15),
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
                // onSaved: (value) {
                //   _enteredEmail = value!;
                // },
                validator: _validateEmail,
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            const SizedBox(height: 15),
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
                // onSaved: (value) {
                //   _enteredPassword = value!;
                // },
                keyboardType: TextInputType.text,
                validator: _validatePassword,
                obscureText: !_isPasswordVisible,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            FilledButton(
              style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                    Color(0xFF00CEC9),
                  ),
                  fixedSize: MaterialStatePropertyAll(Size(354, 50))),
              onPressed: _signUp,
              child: const Text(
                'Sign up',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 23,
            ),
            const Text('Already have an account?'),
            TextButton(
                onPressed: () => Navigator.of(context)
                          .pushReplacementNamed(RouteEnums.loginScreen.name),
                child: const Text(
                  'Sign in',
                  style: TextStyle(
                    color: Color(0xFF00CEC9),
                  ),
                ),
                ),
          ],
        ),
      ),
    );
  }
} 




class UserRequestModel {
    String name;
    String surname;
    String email;
    String imageUrl;
    UserRequestModel({
        required this.name,
        required this.surname,
        required this.email,
        required this.imageUrl,
    });


    Map<String, dynamic> toJson() => {
        "name": name,
        "surname": surname,
        "email": email,
        "imageUrl": imageUrl,
    };
}

class UserResponseModel {
    String? name;
    String? surname;
    String? email;
    String? photoURL;
    UserResponseModel({
        this.name,
        this.surname,
        this.email,
        this.photoURL
    });

    factory UserResponseModel.fromJson(Map<String, dynamic> json) => UserResponseModel(
        name: json["name"],
        surname: json["surname"],
        email: json["email"],       
        photoURL: json['photURL']
    );

}

