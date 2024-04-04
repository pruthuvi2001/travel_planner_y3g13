import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../app_bottom_navigation_bar.dart';
import '../home_page.dart';
import '../log_in_page.dart';
import 'change_password.dart';
import 'edit_profile.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);
  final int _selectedIndex=1;

  @override
  Widget build(BuildContext context) {
    void _navigatePage(int pageIndex){
      if(pageIndex==0) {
        //navigation to the profile page
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
        );
      }
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        // leading: IconButton(
        //     onPressed: () {}, icon: const Icon(LineAwesomeIcons.angle_left)),
        title:const Text("Profile",
          style: TextStyle(
          color: Colors.black,
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
        ),
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
                        LineAwesomeIcons.alternate_pencil,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Text("User_Name",
                  style: Theme.of(context).textTheme.headlineMedium),
              Text("travelpanner@gmail.com",
                  style: Theme.of(context).textTheme.bodyMedium),
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
                  child: Text("Edit Profile",
                      style: Theme.of(context).textTheme.bodyMedium),
                ),
              ),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 10),

              //menu
              ProfileMenuWidget(
                  title: "Change Password",
                  icon: LineAwesomeIcons.cog,
                  onPress: () => {
                    Navigator.push(context,MaterialPageRoute(builder:(context) => const ChangePasswordPage()))
                  }),
              ProfileMenuWidget(
                  title: "Activate Alarm", icon: Icons.alarm, onPress: () {}),
              const Divider(),
              const SizedBox(height: 10),
              ProfileMenuWidget(
                  title: "logout",
                  icon: LineAwesomeIcons.alternate_sign_out,
                  textColor: Colors.red,
                  endIcon: false,
                  onPress: () => {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginPage(),
                  ),
                  ),
                  }),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _navigatePage,
      ),
    );
  }
}

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({
    Key? key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.grey.withOpacity(0.1),
        ),
        child: Icon(icon, color: Colors.grey),
      ),
      title: Text(title,
          style:
          Theme.of(context).textTheme.bodyLarge?.apply(color: textColor)),
      trailing: endIcon
          ? Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.grey.withOpacity(0.1),
          ),
          child: const Icon(LineAwesomeIcons.angle_right,
              size: 18.0, color: Colors.grey))
          : null,
    );
  }
}