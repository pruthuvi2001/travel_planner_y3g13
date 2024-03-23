import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'log_in_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){

          //if user logged in perform
          if(snapshot.hasData){
            return HomePage();
          }

          //if user not logged in perform
          else{
            return const HomePage();
          }



        }
      ),
    );
  }


}
