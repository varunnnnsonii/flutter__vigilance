// import 'package:flutter/material.dart';
// import 'package:vigilance2/map.dart';
// import 'package:vigilance2/searchbar.dart'; // Remove this line
// import 'searchbar.dart';
// import 'package:vigilance2/panel.dart';
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Stack(
//         children: [
//           MapWidget(), // Full-screen map
//           HomePage(), // Overlay home page content
//         ],
//       ),
//     );
//   }
// }
//
//
// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   bool _isSidebarOpen = false;
//   bool _isSearchBarOpen = false;
//
//   void _toggleSidebar() {
//     setState(() {
//       _isSidebarOpen = !_isSidebarOpen;
//     });
//   }
//
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
//           if (_isSidebarOpen) // Conditionally add the sidebar based on the `_isSidebarOpen` value
//             Positioned(
//               top: AppBar().preferredSize.height - 56,
//               left: 0,
//               bottom: 0,
//               width: _isSidebarOpen ? 175 : 80,
//               child: _buildSidebar(),
//             ),
//
//           Positioned(
//             top: AppBar().preferredSize.height - 35,
//             left: 20,
//             child: AnimatedOpacity(
//               opacity: _isSidebarOpen ? 0 : 1,
//               duration: Duration(milliseconds: 500),
//               child: GestureDetector(
//                 onTap: _toggleSidebar,
//                 child: Icon(
//                   Icons.menu,
//                   color: Colors.black,
//                   size: 32,
//                 ),
//               ),
//             ),
//           ),
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
//   Widget _buildSidebar() {
//     return Container(
//       width: _isSidebarOpen ? 175 : 80,
//       color: Color(0xFF000000),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           GestureDetector(
//             onTap: _toggleSidebar,
//             child: Container(
//               padding: EdgeInsets.all(20),
//               child: Icon(
//                 _isSidebarOpen ? Icons.menu_open_rounded : Icons.menu,
//                 color: Colors.white,
//                 size: 32,
//               ),
//             ),
//           ),
//           SizedBox(height: 20),
//           _buildSidebarButton("Notifications", Icons.notifications_active, _isSidebarOpen),
//           _buildSidebarButton("Contact", Icons.contact_support_outlined, _isSidebarOpen),
//           _buildSidebarButton("Change Theme", Icons.sunny, _isSidebarOpen),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSidebarButton(String title, IconData icon, bool showText) {
//     return GestureDetector(
//       onTap: () {
//         if (title == "Notifications") {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => NotificationsPage()),
//           );
//         } else if (title == "Contact") {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => ContactPage()),
//           );
//         }
//         _toggleSidebar();
//       },
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//         child: Row(
//           children: [
//             Icon(
//               icon,
//               color: Colors.white,
//             ),
//             if (showText) SizedBox(width: 10),
//             if (showText)
//               Text(
//                 title,
//                 style: TextStyle(color: Colors.white),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
// }
//
// class NotificationsPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('THis is Notifications Page'),
//       ),
//       body: Center(
//         child: Text('This is the notifications page.'),
//       ),
//     );
//   }
// }
//
// class ContactPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Contact Page'),
//       ),
//       body: Center(
//         child: Text('This is the contact page.'),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Location App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
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

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  LocationData? _selectedLocation;

  static final CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(37.7749, -122.4194), // San Francisco's coordinates
    zoom: 12,
  );

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
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
      _selectedLocation = location;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location App'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: initialCameraPosition,
              onMapCreated: (controller) {
                _mapController = controller;
              },
              markers: _markers,
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                DropdownButton<LocationData>(
                  items: locations.map((location) {
                    return DropdownMenuItem<LocationData>(
                      value: location,
                      child: Text(location.name),
                    );
                  }).toList(),
                  onChanged: (selectedLocation) {
                    _onLocationSelected(selectedLocation!);
                  },
                  value: _selectedLocation,
                  hint: Text('Select a location'),
                ),
                SizedBox(height: 16),
                if (_selectedLocation != null)
                  Text(
                    'Selected Location: ${_selectedLocation!.name}',
                    style: TextStyle(fontSize: 16),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static final List<LocationData> locations = [
    LocationData(name: 'Location A', latitude: 19.7749, longitude: -122.4194),
    LocationData(name: 'Location B', latitude: 37.7740, longitude: -122.4149),
    LocationData(name: 'Location C', latitude: 37.7732, longitude: -122.4135),
  ];
}

