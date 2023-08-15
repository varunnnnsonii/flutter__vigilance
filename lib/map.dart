import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' as math; // Import the math library

class MapWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final LatLng center = const LatLng(19.184818, 72.834495); // Initial map coordinates

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: center,
        zoom: 11,
      ),

      markers:
        _createMarkers(center), // Call the function to create markers

    );
  }
  Set<Marker> _createMarkers(LatLng center) {
    final Set<Marker> markers = {};

    // Generate a set number of blue (police) and green (CCTV) markers
    final int numMarkers = 30; // Increase the total number of markers for variety
    final math.Random random = math.Random();

    int policeStations = random.nextInt(3) + 1; // Random between 1 and 3
    int cctvs = random.nextInt(21) + 5; // Random between 5 and 25

    for (int i = 0; i < numMarkers; i++) {
      double lat = center.latitude + _randomInRange(-0.009, 0.009);
      double lng = center.longitude + _randomInRange(-0.009, 0.009);

      String markerTitle;
      BitmapDescriptor markerIcon;

      if (policeStations > 0) {
        markerTitle = 'Police Station';
        markerIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
        policeStations--;
      } else if (cctvs > 0) {
        markerTitle = 'CCTV';
        markerIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
        cctvs--;
      } else {
        break; // No more police stations or CCTVs to place
      }

      markers.add(
        Marker(
          markerId: MarkerId('markerId_$i'),
          position: LatLng(lat, lng),
          icon: markerIcon,
          infoWindow: InfoWindow(title: markerTitle),
        ),
      );
    }

    // Add central marker with red color
    markers.add(
      Marker(
        markerId: MarkerId('centerMarker'),
        position: center,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    );

    return markers;
  }

  double _randomInRange(double min, double max) {
    return min + math.Random().nextDouble() * (max - min);
  }
}
