// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_webservice/places.dart';
//
// class MapWidget extends StatefulWidget {
//
//
//   // Define a GlobalKey to access the MapWidget's state
//   static final GlobalKey<_MapWidgetState> mapKey = GlobalKey<_MapWidgetState>();
//
//   @override
//   _MapWidgetState createState() => _MapWidgetState();
// }
//
// class _MapWidgetState extends State<MapWidget> {
//   GoogleMapController? _mapController;
//   LatLng? _currentPosition;
//   List<Marker> _policeStationMarkers = [];
//   List<Marker> _hiddenMarkers = []; // List for hidden markers
//
//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//   }
//   void centerMapToLocation(double lat, double long) {
//     if (_mapController != null) {
//
//       print("1");
//       _mapController!.animateCamera(
//         CameraUpdate.newLatLng(LatLng(lat, long)),
//       );
//       print("2");
//
//     }
//     print('Lat: $lat, Long: $long');
//   }
//
//   Future<void> _getCurrentLocation() async {
//     try {
//       final position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);
//       setState(() {
//         _currentPosition = LatLng(position.latitude, position.longitude);
//       });
//     } catch (e) {
//       print('Error getting location: $e');
//     }
//   }
//
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     if (_currentPosition == null) {
//       return const Center(child: Text("loading map"));
//     }
//
//     return GoogleMap(
//       initialCameraPosition: CameraPosition(
//         target: _currentPosition!,
//         zoom: 15,
//       ),
//       onMapCreated: (controller) {
//         setState(() {
//           _mapController = controller;
//         });
//         // centerMapToLocation(19.174472, 72.866);
//       },
//       markers:<Marker>{
//     // Center marker
//     Marker(
//         markerId: MarkerId('centerMarker'),
//     position: _currentPosition!,
//     icon: BitmapDescriptor.defaultMarker,
//     ),
//     }, // Include only the center marker
//     );
//   }
//
//
// }
