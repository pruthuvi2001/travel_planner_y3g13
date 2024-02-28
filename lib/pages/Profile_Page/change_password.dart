
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:travel_planner_y3g13/pages/Profile_Page/profile_page.dart';

import 'edit_profile.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        leading: IconButton(
            onPressed: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProfilePage()))
                },
            icon: const Icon(LineAwesomeIcons.angle_left)),
        title: Text("Change Password",
            style: Theme.of(context).textTheme.headlineMedium),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30.0),
          child: Column(children: [
            const SizedBox(height: 50),
            Form(
                child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                      label: Text("Old Password"),
                      prefixIcon: Icon(LineAwesomeIcons.eye)),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(
                      label: Text("New Password"),
                      prefixIcon: Icon(LineAwesomeIcons.eye_slash)),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(
                      label: Text("Confirm New Password"),
                      prefixIcon: Icon(LineAwesomeIcons.eye_slash)),
                ),
                const SizedBox(height: 20),
              ],
            )),
            const SizedBox(height: 20),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () => {
                  Navigator.push(context,MaterialPageRoute(builder:(context) => const EditProfilePage()))
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    side: BorderSide.none,
                    shape: const StadiumBorder()),
                child: Text("Save New Password",
                    style: Theme.of(context).textTheme.bodyMedium),
              ),
            ),
          ]
          ),
        ),
      ),
    );
  }
}
