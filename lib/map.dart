import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final LatLng center = const LatLng(19.184818, 72.834495); // Initial map coordinates

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: center,
        zoom: 11,
      ),
      markers: {
        Marker(
          markerId: MarkerId('markerId'),
          position: center,
          infoWindow: InfoWindow(title: 'Pritesh Gay'),
        ),
      },
    );
  }
}
