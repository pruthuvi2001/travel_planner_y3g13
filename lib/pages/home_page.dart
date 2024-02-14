import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_planner_y3g13/Pages/log_in_page.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  // Retrieve the current user
  final user = FirebaseAuth.instance.currentUser;

  // sign out user method
  void signOutUser(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          IconButton(
            onPressed: () => signOutUser(context),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Text(
          "Logged In successfully AS ${user != null ? user!.email! : 'Unknown'}",
        ),
      ),
    );
  }
}
