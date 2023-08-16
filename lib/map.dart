import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';

class MapWidget extends StatefulWidget {
  final void Function(String roadName) onSearchByRoadName;

  MapWidget({required this.onSearchByRoadName});

  // Define a GlobalKey to access the MapWidget's state
  static final GlobalKey<_MapWidgetState> mapKey = GlobalKey<_MapWidgetState>();

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  GoogleMapController? _mapController;
  LatLng? _currentPosition;
  List<Marker> _policeStationMarkers = [];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });
      _searchNearbyPoliceStations();
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  Future<void> _searchNearbyPoliceStations() async {
    if (_currentPosition == null) return;

    final places = GoogleMapsPlaces(apiKey: 'YOUR_GOOGLE_PLACES_API_KEY');
    final response = await places.searchNearbyWithRadius(
      Location(
        lat: _currentPosition!.latitude,
        lng: _currentPosition!.longitude,
      ),
      1000, // Radius in meters (adjust as needed)
      type: 'police', // Search for police stations
    );

    if (response.isOkay) {
      _policeStationMarkers.clear();
      for (var result in response.results) {
        _policeStationMarkers.add(
          Marker(
            markerId: MarkerId(result.id!),
            position: LatLng(
                result.geometry!.location.lat, result.geometry!.location.lng),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            infoWindow: InfoWindow(title: result.name!),
          ),
        );
      }
      setState(() {});
    } else {
      print('Error searching for police stations: ${response.errorMessage}');
    }
  }

  // Function to search by road name
  void searchByRoadName(String roadName) {
    // Implement your search logic here
    // Update the map location and add markers based on the road name
    widget.onSearchByRoadName(roadName);
  }

  @override
  Widget build(BuildContext context) {
    if (_currentPosition == null) {
      return const Center(child: Text("loading map"));
    }

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: _currentPosition!,
        zoom: 15,
      ),
      onMapCreated: (controller) {
        setState(() {
          _mapController = controller;
        });
      },
      markers: Set<Marker>.from(_policeStationMarkers),
    );
  }
}
