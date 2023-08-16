import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';

class MapWidget extends StatefulWidget {


  // Define a GlobalKey to access the MapWidget's state
  static final GlobalKey<_MapWidgetState> mapKey = GlobalKey<_MapWidgetState>();

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  GoogleMapController? _mapController;
  LatLng? _currentPosition;
  List<Marker> _policeStationMarkers = [];
  List<Marker> _hiddenMarkers = []; // List for hidden markers

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
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            infoWindow: InfoWindow(title: result.name!),
          ),
        );
      }
      setState(() {});
    } else {
      print('Error searching for police stations: ${response.errorMessage}');
    }
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
        centerMapToLocation(19.174472, 72.866);
      },
      markers:<Marker>{
    // Center marker
    Marker(
        markerId: MarkerId('centerMarker'),
    position: _currentPosition!,
    icon: BitmapDescriptor.defaultMarker,
    ),
    }, // Include only the center marker
    );
  }

  void centerMapToLocation(double lat, double long) {
    if (_mapController != null) {
      Future.delayed(Duration(milliseconds: 5), () {
        print("1");
        _mapController!.animateCamera(
          CameraUpdate.newLatLng(LatLng(lat, long)),
        );
        print("2");
      });
    }
    print('Lat: $lat, Long: $long');
  }
}
