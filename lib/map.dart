import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';

const String kGoogleApiKey = 'AIzaSyComx15z_rWtMJMHhg3oGTwQHOW5Jv_eqU';

class MapWidget extends StatefulWidget {
  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  CameraPosition? _initialCameraPosition;
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
  Marker? _policeMarker;

  Future<void> _getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    if (position != null) {
      final placesResponse = await _places.searchNearbyWithRadius(
        Location(lat: position.latitude, lng: position.longitude),
        1000,
        type: 'police',
      );

      if (placesResponse.status == 'OK' && placesResponse.results.isNotEmpty) {
        final place = placesResponse.results.first;
        final LatLng policeStationLatLng =
        LatLng(place.geometry!.location.lat, place.geometry!.location.lng);

        setState(() {
          _currentPosition = position;
          _initialCameraPosition = CameraPosition(
            target: policeStationLatLng,
            zoom: 15,
          );
          _policeMarker = Marker(
            markerId: MarkerId('police_station'),
            position: policeStationLatLng,
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          );
        });
      } else {
        setState(() {
          _currentPosition = position;
          _initialCameraPosition = CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 15,
          );
        });
      }
    }
  }

  Set<Marker> _createMarkers(LatLng center) {
    Set<Marker> markers = {};

    if (_policeMarker != null) {
      markers.add(_policeMarker!);
    }

    if (_currentPosition != null) {
      markers.add(
        Marker(
          markerId: MarkerId('center_marker'),
          position: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
    }

    return markers;
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition cameraPosition = _currentPosition != null
        ? CameraPosition(
      target: LatLng(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      ),
      zoom: 11,
    )
        : _initialCameraPosition!;

    return GoogleMap(
      initialCameraPosition: cameraPosition,
      onMapCreated: (controller) {
        setState(() {
          _mapController = controller;
        });
      },
      markers: _createMarkers(cameraPosition.target),
    );
  }
}
