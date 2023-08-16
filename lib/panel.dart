import 'package:flutter/material.dart';

class SlidingPanel extends StatefulWidget {
  final Widget panelContent;

  SlidingPanel({required this.panelContent});

  @override
  _SlidingPanelState createState() => _SlidingPanelState();
}

class _SlidingPanelState extends State<SlidingPanel> {
  bool _isPanelOpen = false;

  void _togglePanel() {
    setState(() {
      _isPanelOpen = !_isPanelOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: _isPanelOpen ? 300 :30,
      child: GestureDetector(
        onTap: _togglePanel,
        child: Container(
          color: Colors.white,
          child: Center(
            child: Text('Sliding Panel Content'),
          ),
        ),
      ),
    );
  }
}
