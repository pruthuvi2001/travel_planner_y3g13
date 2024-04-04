import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'log_in_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show loading indicator while waiting for authentication state
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            // If user is not logged in, navigate to login page
            return const LoginPage();

          } else {
            // If user is logged in, navigate to home page
            return const HomePage();
          }
        },
      ),
    );
  }
}
