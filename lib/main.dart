import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';

void main() {
  runApp(MyApp());
}

class LocationData {
  final String name;
  final double latitude;
  final double longitude;

  LocationData({
    required this.name,
    required this.latitude,
    required this.longitude,
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  List<LocationData> _locations = [];

  static const CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(19.174472, 72.866), // San Francisco's coordinates
    zoom: 15,
  );

  bool _isLocationMenuOpen = false;
  bool _isOverlayOpen = false;
  bool _isSidebarOpen = false;

  @override
  void initState() {
    super.initState();
    _loadLocations();
    _getCurrentLocation();
  }

  Future<void> _loadLocations() async {
    final String data = await rootBundle.loadString('assets/anaums.csv');
    List<List<dynamic>> csvTable = CsvToListConverter().convert(data);
    csvTable.removeAt(0); // Remove header row

    _locations = csvTable.map((row) {
      return LocationData(
        name: row[1].toString(),
        latitude: double.parse(row[3].toString()),
        longitude: double.parse(row[4].toString()),
      );
    }).toList();
  }

  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    LatLng latLng = LatLng(position.latitude, position.longitude);
    _mapController?.animateCamera(CameraUpdate.newLatLng(latLng));
  }

  void _onLocationSelected(LocationData location) {
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: MarkerId(location.name),
          position: LatLng(location.latitude, location.longitude),
          infoWindow: InfoWindow(title: location.name),
        ),
      );
    });
    _mapController?.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(location.latitude, location.longitude),
      ),
    );
  }

  void _toggleLocationMenu() {
    setState(() {
      _isLocationMenuOpen = !_isLocationMenuOpen;
    });
  }

  void _toggleOverlay() {
    setState(() {
      _isOverlayOpen = !_isOverlayOpen;
    });
  }

  void _toggleSidebar() {
    setState(() {
      _isSidebarOpen = !_isSidebarOpen;
    });
  }

  void _openPopUpWindow() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Popup Window'),
          content: Text('This is a popup window.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the popup window
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/logo.png',
              width: 40,
            ),
            SizedBox(width: 100),
            Text(
              "VIGILANCE",
              style: TextStyle(
                fontFamily: 'MyFont',
                fontSize: 30,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: initialCameraPosition,
            onMapCreated: (controller) {
              _mapController = controller;
            },
            markers: _markers,
          ),
          if (_isSidebarOpen)
            Positioned(
              top: AppBar().preferredSize.height - 56,
              left: 0,
              bottom: 0,
              width: _isSidebarOpen ? 175 : 80,
              child: _buildSidebar(),
            ),
          Positioned(
            top: AppBar().preferredSize.height - 35,
            left: 25,
            child: AnimatedOpacity(
              opacity: _isSidebarOpen ? 0 : 1,
              duration: Duration(milliseconds: 500),
              child: GestureDetector(
                onTap: _toggleSidebar,
                child: Icon(
                  _isSidebarOpen ? Icons.menu_open_rounded : Icons.menu,
                  color: Colors.black,
                  size: 32,
                ),
              ),
            ),
          ),
          if (_isOverlayOpen)
            GestureDetector(
              onTap: _toggleOverlay,
              child: Container(
                color: Colors.black.withOpacity(0.5),
                alignment: Alignment.center,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  width: MediaQuery.of(context).size.width * 0.8,
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'This is a placeholder message for the overlay.',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _toggleLocationMenu,
            child: _isLocationMenuOpen
                ? Icon(Icons.arrow_circle_down)
                : Icon(Icons.arrow_circle_up),
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: _openPopUpWindow, // Open the popup window
            child: Icon(Icons.message),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomSheet: _isLocationMenuOpen
          ? Container(
        height: MediaQuery.of(context).size.height / 3,
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _locations.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_locations[index].name),
                    onTap: () {
                      _onLocationSelected(_locations[index]);
                      _toggleLocationMenu();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      )
          : null,
    );
  }

  Widget _buildSidebar() {
    return Container(
        width: _isSidebarOpen ? 500 : 20,
        color: Color(0xFF000000),
    child: Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
    GestureDetector(
    onTap: _toggleSidebar,
    child: Container(
    padding: EdgeInsets.all(25),
    child: Icon(
    _isSidebarOpen ? Icons.menu_open_rounded : Icons.menu,
    color: Colors.white,
    size: 32,
    ),
    ),
    ),
    SizedBox(height:20
    ),
      SizedBox(height: 20),
      _buildSidebarButton(
          "Notifications", Icons.notifications_active, _isSidebarOpen),
      SizedBox(height: 20),
      _buildSidebarButton("Contact", Icons.contact_support_outlined, _isSidebarOpen),
      SizedBox(height: 20),
      _buildSidebarButton("Change Theme", Icons.sunny, _isSidebarOpen),
    ],
    ),
    );
  }

  Widget _buildSidebarButton(String title, IconData icon, bool showText) {
    return GestureDetector(
      onTap: () {
        if (title == "Notifications") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NotificationsPage()),
          );
        } else if (title == "Contact") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ContactPage()),
          );
        }
        _toggleSidebar();
      },
      child: Container(
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),
            if (showText) SizedBox(width: 10),
            if (showText)
              Text(
                title,
                style: TextStyle(color: Colors.white),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('This is Notifications Page'),
      ),
      body: Center(
        child: Text('This is the notifications page.'),
      ),
    );
  }
}

class ContactPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Page'),
      ),
      body: Center(
        child: Text('This is the contact page.'),
      ),
    );
  }
}

