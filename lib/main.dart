import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vigilance2/map.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isSidebarOpen = false;

  void _toggleSidebar() {
    setState(() {
      _isSidebarOpen = !_isSidebarOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Image.asset(
          'assets/logo.png',
          width: 40,
        ),
      ),
      body: Stack(
        children: [
          MapWidget(), // Move the map widget to the bottom of the stack
          if (_isSidebarOpen) // Conditionally add the sidebar based on the `_isSidebarOpen` value
            Positioned(
              top: AppBar().preferredSize.height-56,
              left: 0,
              bottom: 0,
              width: _isSidebarOpen ? 175 : 80,
              child: _buildSidebar(),
            ),
          Positioned(
            top: AppBar().preferredSize.height - 35,
            left: 20,
            child: AnimatedOpacity(
              opacity: _isSidebarOpen ? 0 : 1,
              duration: Duration(milliseconds: 500),
              child: GestureDetector(
                onTap: _toggleSidebar,
                child: Icon(
                  Icons.menu,
                  color: Colors.black,
                  size: 32,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: _isSidebarOpen ? 175 : 80,
      color: Color(0xFF000000),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: _toggleSidebar,
            child: Container(
              padding: EdgeInsets.all(20),
              child: Icon(
                _isSidebarOpen ? Icons.menu_open_rounded : Icons.menu,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
          SizedBox(height: 20),
          _buildSidebarButton("Notifications", Icons.notifications_active, _isSidebarOpen),
          _buildSidebarButton("Contact", Icons.contact_support_outlined, _isSidebarOpen),
          _buildSidebarButton("Change Theme", Icons.sunny, _isSidebarOpen),
        ],
      ),
    );
  }
  // Widget _buildMap() {
  //   final LatLng center = const LatLng(19.184818, 72.834495); // Initial map coordinates
  //
  //   return GoogleMap(
  //     initialCameraPosition: CameraPosition(
  //       target: center,
  //       zoom: 11,
  //     ),
  //     markers: {
  //       Marker(
  //         markerId: MarkerId('markerId'),
  //         position: center,
  //         infoWindow: InfoWindow(title: 'Marker Title'),
  //       ),
  //     },
  //   );
  // }
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
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
        title: Text('Notifications Page'),
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

      ),
    );
  }
}