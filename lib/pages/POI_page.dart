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
    // Initialize selectedLocations with widget.placesList
    selectedLocations = List<Map<String, dynamic>>.from(widget.placesList);
  }

  bool isSelected(Map<String, dynamic> location) {
    return selectedLocations.contains(location);
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
                    setState(() {
                      if (isSelected(location)) {
                        selectedLocations.remove(location);
                      } else {
                        selectedLocations.add(location);
                      }
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      isSelected(location) ? Colors.amber : Colors.white,
                    ),
                  ),
                  child: Text(
                    isSelected(location) ? 'Add' : 'Remove',
                    style: TextStyle(
                      color: isSelected(location)
                          ? Colors.white
                          : Color(0xFFFF8C00),
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
                // Navigator.push(context, MaterialPageRoute(builder: (context) => MapsPage()));
                // Replace the above line with actual navigation code when the Maps page is available.
                print('View in Maps button clicked!');
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
              ),
              child: Text('View in Maps'),
            ),
          ),
          Positioned(
            bottom: 16.0,
            left: 16.0,
            child: ElevatedButton(
              onPressed: () {
                // Go back to the previous page
                // Navigator.pop(context);
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ));
                // Replace the above line with actual navigation code to go back when available.
                print('Go Back button clicked!');
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Color(0xFFFF8C00),
                ),
              ),
              child: Text(
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