import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController startingPointController;
  late TextEditingController endingPointController;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text.rich(
          TextSpan(
              text: 'Travel Planner',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 35,
                  fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                  text: ' App',
                  style: TextStyle(color: Colors.white),
                ),
              ]),
        ),
      ),
      body: Container(
        child: ListView(
          padding: EdgeInsets.only(
            top: 20.0,
            bottom: 20.0,
          ),
          children: [
// showing the logo as circle
            Center(
              child: ClipOval(
                // Clip to a circular shape
                child: Image.asset(
                  'assets/images/login_bg.jpg',
                  fit: BoxFit.cover,
                  height: 200.0,
                  width: 200.0,
                ),
              ),
            ),
            SizedBox(height: 30),
// Search for Places text
            Center(
              child: Text(
                'Search for Places',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 25),
// Starting point
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Text(
                'Starting Point',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                ),
              ),
            ),
            SizedBox(height: 7),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[200]?.withOpacity(0.8),
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0, top: 15.0),
                  child: TextField(
                    controller: startingPointController,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Starting Point',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
// Ending point
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Text(
                'Destination',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                ),
              ),
            ),
            SizedBox(height: 7),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[200]?.withOpacity(0.8),
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0, top: 15.0),
                  child: TextField(
                    controller: endingPointController,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Ending Point',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: ElevatedButton(
                onPressed: _searchPlace,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: Container(
                  height: 45,
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
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        iconSize: 20.0,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        selectedLabelStyle: TextStyle(color: Colors.black),
        unselectedLabelStyle: TextStyle(color: Colors.black),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

//logo need to be added
