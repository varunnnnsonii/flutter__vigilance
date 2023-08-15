import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapWidget extends StatefulWidget {
  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  GoogleMapController? _mapController;
  Position? _currentPosition;

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
        _currentPosition = position;
      });
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentPosition == null) {
      return Center(child: CircularProgressIndicator());
    }

    final LatLng center =
    LatLng(_currentPosition!.latitude, _currentPosition!.longitude);

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: center,
        zoom: 11,
      ),
      onMapCreated: (controller) {
        setState(() {
          _mapController = controller;
        });
      },
      markers: Set<Marker>.from([
        Marker(
          markerId: MarkerId('centerMarker'),
          position: center,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      ]),
    );
  }
}
