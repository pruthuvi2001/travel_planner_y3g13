
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:location/location.dart';

import '../const.dart';

class MapPage extends StatefulWidget {
  final List<Map<String, dynamic>> placesList;
  final String startingPoint;
  final String endingPoint;

  const MapPage({
    Key? key,
    required this.placesList,
    required this.startingPoint,
    required this.endingPoint,
  }) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Location _locationController = Location();
  final Completer<GoogleMapController> _mapController =
  Completer<GoogleMapController>();
  static const LatLng _initialPosition =LatLng(6.9136764758581375, 79.86160127549243);
  LatLng? _currentP;
  List<LatLng> _locations = [];
  late String _startingPoint;
  late String _endingPoint;

  Map<PolylineId, Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    _locations = _getLocationsFromPlacesList(widget.placesList);
    _startingPoint = widget.startingPoint;
    _endingPoint = widget.endingPoint;
    getLocationUpdates();
    getPolylinePoints();
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
      body: _currentP == null
          ? const Center(
        child: Text('Loading...'),
      )
          : GoogleMap(
        onMapCreated: (GoogleMapController controller) =>
            _mapController.complete(controller),
        mapType: MapType.normal,
        initialCameraPosition: const CameraPosition(
          target: _initialPosition,
          zoom: 15,
        ),
        markers: _buildMarkers(),
        polylines: Set<Polyline>.of(polylines.values),
      ),
    );
  }

  Set<Marker> _buildMarkers() {
    Set<Marker> markers = {};
    markers.add(
      Marker(
        markerId: const MarkerId('CurrentLocation'),
        icon: BitmapDescriptor.defaultMarker,
        position: _currentP!,
      ),
    );
    for (int i = 0; i < _locations.length; i++) {
      markers.add(
        Marker(
          markerId: MarkerId(_locations[i].toString()),
          icon: BitmapDescriptor.defaultMarker,
          position: _locations[i],
        ),
      );
    }
    return markers;
  }

  Future<void> getLocationUpdates() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _locationController.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
    }
    if (!_serviceEnabled) {
      return;
    }

    _permissionGranted = await _locationController.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationController.onLocationChanged
        .listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          _currentP =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
          _cameraToPosition(_currentP!);
        });
      }
    });
  }
/**
  Future<void> getPolylinePoints() async {
    List<LatLng> polylineCoordinates = [];

    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      GOOGLE_MAPS_API_KEY,
      PointLatLng(_locations.first.latitude, _locations.first.longitude),
      PointLatLng(_locations.last.latitude, _locations.last.longitude),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    generatePolyLineFromPoints(polylineCoordinates);
  }
**/

  Future<void> getPolylinePoints() async {
    List<LatLng> polylineCoordinates = [];

    // Add starting point to polyline coordinates
    polylineCoordinates.add(_locations.first);

    // Iterate through each location in placesList and add it to polyline coordinates
    for (int i = 1; i < _locations.length; i++) {
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        GOOGLE_MAPS_API_KEY,
        PointLatLng(_locations[i - 1].latitude, _locations[i - 1].longitude),
        PointLatLng(_locations[i].latitude, _locations[i].longitude),
        travelMode: TravelMode.driving,
      );

      if (result.points.isNotEmpty) {
        result.points.forEach((PointLatLng point) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        });
      } else {
        print(result.errorMessage);
      }
    }

    // Add ending point to polyline coordinates
    polylineCoordinates.add(_locations.last);

    generatePolyLineFromPoints(polylineCoordinates);
  }



  Future<void> _cameraToPosition(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition _newCameraPosition = CameraPosition(
      target: pos,
      zoom: 13,
    );
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(_newCameraPosition),
    );
  }

  void generatePolyLineFromPoints(List<LatLng> polylineCoordinates) async {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.amber,
      points: polylineCoordinates,
      width: 8,
    );
    setState(() {
      polylines[id] = polyline;
    });
  }

  List<LatLng> _getLocationsFromPlacesList(List<Map<String, dynamic>> placesList) {
    List<LatLng> locations = [];
    for (int i = 0; i < placesList.length; i++) {
      double lat = placesList[i]['latitude'];
      double lng = placesList[i]['longitude'];
      locations.add(LatLng(lat, lng));
    }
    return locations;
  }
}