import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:travel_planner_y3g13/pages/Profile_Page/profile_page.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

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
        title: Text("Edit Page",
            style: Theme.of(context).textTheme.headlineMedium),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: const Image(
                            image: AssetImage(
                                "assets/images/profile_page/profile_photo.jpg"))),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.amber),
                      child: const Icon(
                        LineAwesomeIcons.camera,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 50),
              Form(
                  child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                        label: Text("Full Name"),
                        prefixIcon: Icon(LineAwesomeIcons.user)),
                  ),
                  const SizedBox(height: -20),
                  TextFormField(
                    decoration: const InputDecoration(
                        label: Text("E Mail"),
                        prefixIcon: Icon(LineAwesomeIcons.envelope_1)),
                  ),
                  const SizedBox(height: -20),
                  TextFormField(
                    decoration: const InputDecoration(
                        label: Text("Password"),
                        prefixIcon: Icon(LineAwesomeIcons.fingerprint)),
                  ),
                  const SizedBox(height: -20),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }
}
