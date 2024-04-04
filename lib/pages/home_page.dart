import 'package:flutter/material.dart';
import 'POI_page.dart';
import 'Profile_Page/profile_page.dart';
import 'app_bottom_navigation_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const String _apiKey = 'BG52qlOwM5RN8bpA3AVHatJ5gr7ZCwlA';
  static const String _gApiKey = "api key";
  final String country = 'Sri Lanka';
  late TextEditingController startingPointController;
  late TextEditingController endingPointController;
  final int _selectedIndex = 0; // Index for the home page
  late List<Map<String, dynamic>> poiList;
  late String startingPoint;
  late String endingPoint;

  @override
  void initState() {
    super.initState();
    startingPointController = TextEditingController();
    endingPointController = TextEditingController();
  }


//to navigate through pages
  void _navigatePage(int pageIndex){
    if(pageIndex==1) {
      //navigation to the profile page
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const ProfilePage(),
      ),
      );
    }
  }

//to search places
  Future<void> _searchPlace() async {
    startingPoint = startingPointController.text;
    endingPoint = endingPointController.text;
// loading page
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.7),
      barrierDismissible: false,
      builder: (context){
        return const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                color: Colors.white,
                backgroundColor: Colors.amber,
              ),
              SizedBox(height: 5,),
              Text(
                "Searching for attractions...",
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        );
      },
    );
    await getCoordinates(startingPoint, endingPoint);
  }

//to get the coordinates using tomtom api
  Future<void> getCoordinates(String startingPoint, String endPoint) async {
    // TomTom API endpoint for geocoding
    const String baseUrl = 'https://api.tomtom.com/search/2/geocode';
    final String startingUrl = '$baseUrl/$startingPoint.json?key=$_apiKey&countrySet=LK';
    final String endingUrl = '$baseUrl/$endPoint.json?key=$_apiKey&countrySet=LK';
    try {
      final responseStarting = await http.get(Uri.parse(startingUrl));
      final responseEnding = await http.get(Uri.parse(endingUrl));

      // Check if API request was successful
      if (responseStarting.statusCode == 200 && responseEnding.statusCode == 200) {
        // Parse the response to extract latitude and longitude
        final startingData = json.decode(responseStarting.body);
        final endingData = json.decode(responseEnding.body);

        final startingCoordinates = _extractCoordinates(startingData,0);
        final endingCoordinates = _extractCoordinates(endingData,1);

        await generateRoute(startingCoordinates['lat'], startingCoordinates['lon'], endingCoordinates['lat'], endingCoordinates['lon']);

      } else {
        throw Exception('Failed to fetch coordinates. Status codes: ${responseStarting.statusCode}, ${responseEnding.statusCode}');
      }
    } catch (e) {
      Navigator.of(context).pop();
      if(e.toString()=="Exception: 0"){
        showErrorDialog(" Invalid Starting point");
      }else if(e.toString()=="Exception: 1"){
        showErrorDialog(" Invalid Ending point");
      }
    }
  }

//to extract lon and lat from generated coordinates
  Map<String, dynamic> _extractCoordinates(Map<String, dynamic> data,int id) {
    final results = data['results'];
    if (results != null && results.isNotEmpty) {
      final firstResult = results[0];
      final position = firstResult['position'];
      if (position != null) {
        return {
          'lat': position['lat'],
          'lon': position['lon'],
        };
      }
    }//id is used to find which point is invalid
    throw Exception(id);
  }

//to generate the route using tomtom api
  Future<void> generateRoute(double startingLatitude, double startingLongitude, double endingLatitude, double endingLongitude) async {
    // TomTom API endpoint for routing
    const String baseUrl = 'https://api.tomtom.com/routing/1/calculateRoute';
    final String url = '$baseUrl/$startingLatitude,$startingLongitude:$endingLatitude,$endingLongitude/json?key=$_apiKey';

    try {
      final response = await http.get(Uri.parse(url));

      // Check if API request was successful
      if (response.statusCode == 200) {
        // Parse the response to extract route information
        Map<String, dynamic> parsedResponse = jsonDecode(response.body);
        List<dynamic> points = parsedResponse['routes'][0]['legs'][0]['points'];
        List<Map<String, dynamic>> convertedPoints = [];

        for (var point in points) {
          convertedPoints.add({
            'lat': point['latitude'],
            'lon': point['longitude'],
          });
        }

        Map<String, dynamic> result = {
          'route': {'points': convertedPoints}
        };

        poiList = await fetchTouristAttractionsAlongRoute(result, _gApiKey);
        // Clear text fields
        startingPointController.clear();
        endingPointController.clear();
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => LocationList(placesList: poiList, startingPoint: startingPoint, endingPoint: endingPoint,),
        ),
        );

      } else {
        throw Exception('Failed to fetch route. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch route: $e');
    }
  }

//to fetch the places using google api
  Future<List<Map<String, dynamic>>> fetchTouristAttractionsAlongRoute(Map<String, dynamic> result, String apiKey) async {
    List<Map<String, dynamic>> routePoints = result['route']['points']; // Extract route points from the result

    List<Map<String, dynamic>> placesList = [];
    double rLat = routePoints.first['lat'];
    double rLng = routePoints.first['lat'];

    for (var point in routePoints) {
      double waypointLat = point['lat']!;
      double waypointLng = point['lon']!;

      if(((rLat+0.1)<waypointLat || (rLng+0.1)<waypointLng) || ((rLat-0.1)>waypointLat || (rLng-0.1)>waypointLng)){
        rLat = waypointLat;
        rLng = waypointLng;
        String url =
            'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$waypointLat,$waypointLng&radius=5000&types=tourist_attraction&key=$apiKey';
        var response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);

          if (data['results'] != null) {
            for (var place in data['results']) {
              if(place['rating']!=null){
                double rating = place['rating']+0.0;
                if(rating>4.2){
                  String name = place['name'];
                  double latitude = place['geometry']['location']['lat'];
                  double longitude = place['geometry']['location']['lng'];
                  placesList.add({
                    'name': name,
                    'latitude': latitude,
                    'longitude': longitude,
                  });
                }
              }

            }
          }
        } else {
          throw Exception('Failed to load data: ${response.statusCode}');
        }
      }
    }
    print(placesList.length);
    return placesList;
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
          'assets/images/fox_logo.png',
          fit: BoxFit.contain,
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
//to show error messages
  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.zero,
              child: Icon(
                Icons.error,
                color: Color(0xFFFF8C00), // Set icon color to FF4907FF
                size: 35,
              ),
            ),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 12),
        actions: [
          TextButton(
            onPressed: (){
              Navigator.of(context).pop();
            },
            child: const Text(
              'Close',
              style: TextStyle(
                color: Color(0xFFFF8C00),
                fontSize:20,
              ),),
          ),
        ],
      ),
    );
  }



}