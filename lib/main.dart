import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'package:http/http.dart' as http;

import 'notification.dart';
import 'notification_storage.dart';

void main() {
  runApp(MyApp());
}
class Safety{
  late final String line;
  Safety({
    required this.line,
  });
}
class LocationData {
  final String name;
  final double latitude;
  final double longitude;
  final double distance; // Add this property
  final double crimeRate; // Add this property
  final int cctvCameras; // Add this property

  LocationData({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.distance,
    required this.crimeRate,
    required this.cctvCameras, // Add this property
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
    target: LatLng(19.174472, 72.866),
    zoom: 15,
  );
  int _selectedListIndex = 0;

  bool _isLocationMenuOpen = false;
  bool _isOverlayOpen = false;
  bool _isSidebarOpen = false;

  @override
  void initState() {
    super.initState();
    _loadLocations();
    _getCurrentLocation();
  }
  String getColumn8Value(int selectedIndex, List<List<dynamic>> csvTable) {
    if (selectedIndex >= 0 && selectedIndex < csvTable.length) {
      return csvTable[selectedIndex][8].toString();
    } else {
      return 'Invalid index';
    }
  }

  Future<void> _loadLocations() async {
    final String data = await rootBundle.loadString('assets/anaums.csv');
    List<List<dynamic>> csvTable = const CsvToListConverter().convert(data);
    csvTable.removeAt(0);

    _locations = csvTable.map((row) {
      return LocationData(
        name: row[1].toString(),
        latitude: double.parse(row[3].toString()),
        longitude: double.parse(row[4].toString()),
        distance: double.parse(row[5].toString()), // Assuming it's in the 6th column
        crimeRate: double.parse(row[6].toString()), // Assuming it's in the 7th column
        cctvCameras: int.parse(row[7].toString()),
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
/*
IMPORTANNT IMPORTANT IMPORTANT
Since due to lack of time we werent able to create the api for ml model so for
the time being we have used to ml model to predict the answers and edited it to
the csv and we are printing on the Sreen on the basis of those predefined ml
 model's result ,as we get more time ,the ml model's api will also be integrated
 and the result will be directly posted from ml api to the popup window
*/
  Future<void> _openPopUpWindow(int selectedIndex) async {
    // Check if the selected index is within valid range
    if (selectedIndex >= 0 && selectedIndex < _locations.length) {
      double distance = _locations[selectedIndex].distance;
      double crimeRate = _locations[selectedIndex].crimeRate;
      int cctvCameras = _locations[selectedIndex].cctvCameras;

      // Make your API call with these values
      final response = await http.post(
        Uri.parse('http:// 192.168.137.81:8000/predict'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "Distance": distance,
          "Crime_Rate": crimeRate,
          "CCTV_Cameras": cctvCameras,
        }),
      );

      // Process the response and show the dialog
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        String popupMessage = data['prediction'];
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Popup Window'),
              content: Text(popupMessage),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
        await NotificationManager.createNotification(popupMessage);
        await NotificationStorage.addNotification(popupMessage);
      } else {
        String popupMessage = 'Error: ${response.statusCode}';
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Popup Window'),
              content: Text(popupMessage),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      }
    } else {
      // Handle invalid index
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Popup Window'),
            content: const Text('Invalid index'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);

                },
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
    }
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
            const SizedBox(width: 100),
            const Text(
              "VIGILANCE",
              style: TextStyle(
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
              duration: const Duration(milliseconds: 500),
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
                  padding: const EdgeInsets.all(16),
                  child: const Text(
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
                ? const Icon(Icons.arrow_circle_down)
                : const Icon(Icons.arrow_circle_up),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () async {
              if (_markers.isNotEmpty) {
                await _openPopUpWindow(_selectedListIndex);
              }
            },
            child: const Icon(Icons.message),
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
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _locations.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_locations[index].name),
                    onTap: () {
                      _selectedListIndex = index;
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
        color: const Color(0xFF000000),
    child: Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
    GestureDetector(
    onTap: _toggleSidebar,
    child: Container(
    padding: const EdgeInsets.all(25),
    child: Icon(
    _isSidebarOpen ? Icons.menu_open_rounded : Icons.menu,
    color: Colors.white,
    size: 32,
    ),
    ),
    ),
    const SizedBox(height:20
    ),
      const SizedBox(height: 20),
      _buildSidebarButton(
          "Notifications", Icons.notifications_active, _isSidebarOpen),
      const SizedBox(height: 20),
      _buildSidebarButton("Contact", Icons.contact_support_outlined, _isSidebarOpen),
      const SizedBox(height: 20),
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
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
          ),
          if (showText) const SizedBox(width: 10),
          if (showText)
            Text(
              title,
              style: const TextStyle(color: Colors.white),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }}
class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('THis is Notifications Page'),
      ),
      body: const Center(
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
        title: const Text('Contact Page'),
      ),
      body: const Center(
        child: Text('This is the contact page.'),
      ),
    );
  }
}

//   void _toggleSearchBar() {
//     setState(() {
//       _isSearchBarOpen = !_isSearchBarOpen;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         title: Image.asset(
//           'assets/logo.png',
//           width: 40,
//         ),
//       ),
//       body: Stack(
//         children: [
//           MapWidget(), // Move the map widget to the bottom of the stack
//
//
//           if (_isSearchBarOpen)
//             Positioned(
//                 top: AppBar().preferredSize.height - 40,
//                 right: 85, // Adjust the right position
//                 child: AnimatedOpacity(
//                   opacity: _isSidebarOpen ? 0 : 1,
//                   duration: Duration(milliseconds: 500),
//                   child:
//                   CustomSearchBar(), // Use your custom search bar widget here
//                 ),
//               ),
//
//
//           Positioned(
//             top: AppBar().preferredSize.height - 48, // Adjust the top padding
//             right: 25,
//             child: ElevatedButton(
//               onPressed: _toggleSearchBar,
//               style: ElevatedButton.styleFrom(
//                 primary: Colors.white, // Set the background color to transparent
//                 shape: CircleBorder(),
//                 padding: EdgeInsets.all( 6), // Adjust padding for the icon
//               ),
//               child: Icon(Icons.search, color: Colors.black),
//             ),
//           ),
//           Positioned(
//             // Add the SlidingUpPanel here
//             bottom: 0,
//             left: 0,
//             right: 0,
//             height: 65,
//             child: SlidingPanel(
//               panelContent: Container(
//                 // Customize your panel content here
//                 child: Center(
//                   child: Text('Sliding Panel Content'),
//                 ),
//               ),
//             ),),
//
//         ],
//       ),
//     );
//   }
//



