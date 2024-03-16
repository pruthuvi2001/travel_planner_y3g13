import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'log_in_page.dart';
import 'ui_background_design.dart';

// Define the UserData class to represent user data
class UserData {
  final String uid;
  final String email;
  final String name;

  UserData({
    required this.uid,
    required this.email,
    required this.name,
  });

  // Convert UserData to a map for storing in Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
    };
  }
}

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with TickerProviderStateMixin {
  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController reEnterPasswordController;
  bool passwordsMatch = true;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    reEnterPasswordController = TextEditingController();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> saveUserData(UserData userData) async {
    try {
      // Get a reference to the users collection in Firestore
      CollectionReference users = FirebaseFirestore.instance.collection('users');

      // Add the user data to Firestore
      await users.doc(userData.uid).set(userData.toMap());
    } catch (e) {
      print('Error saving user data: $e');
      // Handle the error as needed
    }
  }

  void _handleSignUp() async {
    String username = usernameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String reEnterPassword = reEnterPasswordController.text.trim();

    // Validate minimum password length
    if (password.length < 6) {
      _showErrorDialog('Password should be at least 6 characters long.');
      return;
    }

    // Validate password match only if both passwords are entered
    if (password.isNotEmpty && reEnterPassword.isNotEmpty && password != reEnterPassword) {
      _showErrorDialog('Passwords do not match.');
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        final userData = UserData(
          uid: user.uid,
          email: email,
          name: username,
        );

        await saveUserData(userData);
        _showRegistrationSuccessDialog(); // Show registration success dialog
      } else {
        print('Error: User is null');
      }
    } catch (e) {
      print('Sign up failed: $e');
      // Handle sign-up errors
      _showErrorDialog('Sign up failed. Please try again.');
    }

    // Clear text fields
    usernameController.clear();
    emailController.clear();
    passwordController.clear();
    reEnterPasswordController.clear();
  }

  void _navigateToSignIn() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, animation, secondaryAnimation) => const LoginPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(-1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform.scale(
              scale: _animation.value,
              child: Opacity(
                opacity: _animation.value,
                child: AlertDialog(
                  title: const Text('Error'),
                  content: Text(message),
                  actions: [
                    TextButton(
                      onPressed: () {
                        _controller.reverse();
                        passwordController.clear();
                        reEnterPasswordController.clear();
                        Navigator.of(context).pop();
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
    _controller.forward();
  }

  void _showRegistrationSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform.scale(
              scale: _animation.value,
              child: Opacity(
                opacity: _animation.value,
                child: Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(
                          top: 50,
                          bottom: 20,
                          left: 20,
                          right: 20,
                        ),
                        margin: const EdgeInsets.only(top: 50),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            const BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10.0,
                              offset: Offset(0.0, 10.0),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const Text(
                              'Congratulations!',
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            const Text(
                              'You have successfully registered.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 24.0),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                                _navigateToSignIn();
                              },
                              child: Container(
                                alignment: Alignment.center,
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: Colors.lightGreen[600],
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: const Text(
                                  'Login',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 0,
                        child: CircleAvatar(
                          backgroundColor: Colors.lightGreen[800],
                          radius: 50,
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 50,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Positioned.fill(
              child: OvalBackground(color: Colors.amber.shade400),
            ),
            SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  const Text(
                    "Create Account",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Image.asset(
                    'assets/images/fox_logo.png',
                    width: 150,
                    height: 150,
                  ),
                  const SizedBox(height: 50),
                  buildTextField(usernameController, "Enter your username"),
                  const SizedBox(height: 12),
                  buildTextField(emailController, "Enter your email"),
                  const SizedBox(height: 40),
                  buildTextField(passwordController, "Enter your password", isObscure: true, isPassword: true),
                  const SizedBox(height: 12),
                  buildTextField(reEnterPasswordController, "Re-enter your password", isObscure: true, isPassword: true),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: ElevatedButton(
                      onPressed: _handleSignUp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF8C00),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: const SizedBox(
                        height: 45,
                        child: Center(
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already a member?',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF333333),
                          ),
                        ),
                        TextButton(
                          onPressed: _navigateToSignIn,
                          child: const Text(
                            'Sign In.',
                            style: TextStyle(
                              color: Color(0xFFFF8C00),
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String hintText, {bool isObscure = false, bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey[200]?.withOpacity(0.8),
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 22.0),
          child: TextField(
            controller: controller,
            obscureText: isObscure,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: const TextStyle(color: Colors.grey),
            ),
          ),
        ),
      ),
    );
  }
}
