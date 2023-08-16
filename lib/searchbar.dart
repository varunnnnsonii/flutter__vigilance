import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class CustomSearchBar extends StatefulWidget {
  @override
  _CustomSearchBarState createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  List<String> dropdownOptions = [];
  String? selectedOption;

  @override
  void initState() {
    super.initState();
    loadDropdownOptions();
  }

  Future<void> loadDropdownOptions() async {
    String csvData = await rootBundle.loadString('assets/locations.csv');
    List<String> lines = csvData.split('\n');
    setState(() {
      dropdownOptions = lines;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButton<String>(
          items: dropdownOptions.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedOption = newValue;
            });
          },
          value: selectedOption,
          hint: Text('Select a location'),
        ),
        // Add other search bar components here
      ],
    );
  }
}
