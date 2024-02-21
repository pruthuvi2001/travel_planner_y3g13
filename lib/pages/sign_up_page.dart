import 'package:flutter/material.dart';
import 'log_in_page.dart';
import 'ui_background_design.dart';
import 'package:firebase_auth/firebase_auth.dart';



class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController reEnterPasswordController;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    reEnterPasswordController = TextEditingController();
  }

  void _handleSignUp() async{
    // Add your sign-up logic here
    String username = usernameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String reEnterPassword = reEnterPasswordController.text;

    // Perform sign-up actions

    // Function to create a new user account
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // User created successfully
      print('User signed up successfully');
      // Navigate to the next screen or perform other actions
    } catch (e) {
      // Handle sign-up errors
      print('Sign up failed: $e');
      // You can show an error message to the user
    }
    // ...

    // Clear text fields
    usernameController.clear();
    emailController.clear();
    passwordController.clear();
    reEnterPasswordController.clear();
  }

  void _navigateToSignIn() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 300),
        pageBuilder: (context, animation, secondaryAnimation) => LoginPage(),
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: OvalBackground(color: Colors.amber.shade400),
          ),
          SafeArea(
            child: ListView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                      buildTextField(passwordController, "Enter your password", isObscure: true),
                      const SizedBox(height: 12),
                      buildTextField(reEnterPasswordController, "Re-enter your password", isObscure: true),
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: ElevatedButton(
                          onPressed: _handleSignUp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFFF8C00),
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
                              child: Text(
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
        ],
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String hintText, {bool isObscure = false}) {
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








