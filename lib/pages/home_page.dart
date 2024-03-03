import 'package:flutter/material.dart';
import 'app_bottom_navigation_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController startingPointController;
  late TextEditingController endingPointController;
  final int _selectedIndex = 0; // Index for the home page

  @override
  void initState() {
    super.initState();
    startingPointController = TextEditingController();
    endingPointController = TextEditingController();
  }

  void _searchPlace() {
    String startingPoint = startingPointController.text;
    String endingPoint = endingPointController.text;
    // Add your search place logic here
    print('Search Places button clicked..');
    print('starting point: $startingPoint');
    print('ending point: $endingPoint');
    // Perform search actions
    // ...

    // Clear text fields
    startingPointController.clear();
    endingPointController.clear();
  }

  void _navigatePage(int pageIndex){
    if(pageIndex==1) {
      //navigation to the profile page
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text.rich(
          TextSpan(
            text: 'Travel',
            style: TextStyle(
              color: Colors.black,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(
                text: ' Planner',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: ListView(
          padding: const EdgeInsets.only(
            top: 25.0,
            bottom: 20.0,
          ),
          children: [
            const SizedBox(height: 20),
// showing the logo as circle
            _buildLogo(),
            const SizedBox(height: 45),
// Search for Places
            Container(
              height: 370.0,
              decoration: BoxDecoration(
                color: Colors.grey[200]?.withOpacity(0.8),
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListView(
                padding: const EdgeInsets.only(top: 20.0),
                children: [
// Search for Places text
                  const Center(
                    child: Text(
                      'Search for Places',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 27.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
// Starting point
                  _buildLabel( 'Starting Point'),
                  const SizedBox(height: 5),
                  _buildTextField('Starting Point', startingPointController),
                  const SizedBox(height: 30),
// Ending point
                  _buildLabel('Destination'),
                  const SizedBox(height: 5),
                  _buildTextField('Ending Point', endingPointController),
                  const SizedBox(height: 30),
// Search button
                  _buildSearchButton(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _navigatePage,
      ),
    );
  }

// showing the logo as circle
  Widget _buildLogo(){
    return Center(
      child: ClipOval(
        // Clip to a circular shape
        child: Image.asset(
          'assets/images/login_bg.jpg',
          fit: BoxFit.cover,
          height: 170.0,
          width: 170.0,
        ),
      ),
    );
  }
// build label
  Widget _buildLabel(String labelText){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Text(
        labelText,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
// build text field
  Widget _buildTextField(String hintText, TextEditingController controller){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey[200]?.withOpacity(0.8),
          border: const Border(
              bottom: BorderSide(color: Colors.grey)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 15.0),
          child: TextField(
            controller: controller,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 17.0,
            ),
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
// build search button
  Widget _buildSearchButton(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: ElevatedButton(
        onPressed: _searchPlace,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        child: const SizedBox(
          height: 45.0,
          child: Center(
            child: Text(
              'Search Places',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//logo need to be added
