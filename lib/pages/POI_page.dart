import 'package:flutter/material.dart';
import 'package:travel_planner_y3g13/pages/home_page.dart';

class LocationList extends StatefulWidget {
  final List<Map<String, dynamic>> placesList;
  final String startingPoint;
  final String endingPoint;

  const LocationList({Key? key, required this.placesList, required this.startingPoint, required this.endingPoint}) : super(key: key);

  @override
  State<LocationList> createState() => _LocationListState();
}

class _LocationListState extends State<LocationList> {
  List<Map<String, dynamic>> selectedLocations = [];

  @override
  void initState() {
    super.initState();
    // Initialize selectedLocations with an empty list
    selectedLocations = [];
  }

  bool isSelected(Map<String, dynamic> location) {
    return selectedLocations.contains(location);
  }

  void addOrRemoveLocation(Map<String, dynamic> location) {
    setState(() {
      if (isSelected(location)) {
        selectedLocations.removeWhere((element) => element['name'] == location['name']); // Remove the location from selectedLocations based on its name
      } else {
        selectedLocations.add(location); // Add the location's data to selectedLocations
      }
    });
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
      body: Stack(
        children: [
          ListView.builder(
            key: UniqueKey(), // Add a key to ensure proper widget rebuilding
            itemCount: widget.placesList.length,
            itemBuilder: (context, index) {
              final location = widget.placesList[index];
              return ListTile(
                title: Text(location['name'] ?? ''),
                trailing: ElevatedButton(
                  onPressed: () {
                    addOrRemoveLocation(location);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      isSelected(location) ? Colors.amber : Colors.white,
                    ),
                  ),
                  child: Text(
                    isSelected(location) ? 'Remove' : 'Add',
                    style: TextStyle(
                      color: isSelected(location)
                          ? Colors.white
                          : const Color(0xFFFF8C00),
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: ElevatedButton(
              onPressed: () {
                // Navigate to the Maps page
                print('View in Map button clicked!');
                print(selectedLocations.toString());
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.amber),
              ),
              child: const Text(
                'View in Map',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 16.0,
            left: 16.0,
            child: ElevatedButton(
              onPressed: () {
                // Go back to the previous page
                print('Go Back button clicked!');
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ));
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Colors.amber,
                ),
              ),
              child: const Text(
                'Go Back',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}