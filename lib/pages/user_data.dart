import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserData {
  final String uid;
  final String email;
  final String name;


  UserData({
    required this.uid,
    required this.email,
    required this.name,
  });

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'email': email,
    'name': name,
  };

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    uid: json['uid'],
    email: json['email'],
    name: json['name'],
  );
}



Future<void> saveUserData(UserData userData) async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
      await docRef.set(userData.toJson());
      print('User data saved successfully!');
    } else {
      print('No user currently signed in.');
    }
  } on FirebaseException catch (e) {
    print('Error saving user data: ${e.message}');
  }
}
