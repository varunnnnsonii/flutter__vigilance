import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;

class CustomMapWidget extends StatefulWidget {
  @override
  _CustomMapWidgetState createState() => _CustomMapWidgetState();
}

class _CustomMapWidgetState extends State<CustomMapWidget> {
  GoogleMapController? _mapController;
  List<Marker> _markers = [];
  List<List<dynamic>> csvTable = [];

  @override
  void initState() {
    super.initState();
    _loadMarkers();
  }

  Future<void> _loadMarkers() async {
    final data = await rootBundle.loadString('assets/anaums.csv');
    csvTable = const CsvToListConverter().convert(data);

    _markers.clear();
    for (var row in csvTable) {
      _markers.add(
        Marker(
          markerId: MarkerId(row[0].toString()),
          position: LatLng(row[3], row[4]),
          infoWindow: InfoWindow(title: row[1].toString()),
        ),
      );
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(19.174472, 72.866), // Default initial position
        zoom: 15,
      ),
      onMapCreated: (controller) {
        setState(() {
          _mapController = controller;
        });
      },
      markers: _markers.toSet(),
    );
  }
}
