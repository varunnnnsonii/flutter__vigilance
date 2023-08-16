import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:csv/csv.dart';

import 'map.dart';

class CustomSearchBar extends StatefulWidget {
  @override
  _CustomSearchBarState createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  List<String> suggestions = [];
  List<List<dynamic>> csvTable = [];
  String? selectedOption;

  void _onLocationSelected(double lat, double long) {
    MapWidget.mapKey.currentState?.centerMapToLocation(lat, long);
  }


  @override
  void initState() {
    super.initState();
    _loadSuggestions();
  }



  Future<void> _loadSuggestions() async {
    final data = await rootBundle.loadString('assets/anaums.csv');
    csvTable = CsvToListConverter().convert(data);

    setState(() {
      suggestions = csvTable.map((row) => row[1].toString()).toList();
    });
  }

  double? lat;
  double? long;
  int? pDist;
  int? criRate;
  int? cctvCam;




  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: Colors.white,
      ),
      child: Center(
        child: Column(
          children: [
            DropdownButton<String>(
              items: suggestions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedOption = newValue;
                  final rowIndex = suggestions.indexOf(newValue!);
                  if (rowIndex >= 0 && rowIndex < csvTable.length) {
                    lat = csvTable[rowIndex][3];
                    long = csvTable[rowIndex][4];
                    // pDist = int.parse(csvTable[rowIndex][5].toString());
                    // criRate = int.parse(csvTable[rowIndex][6].toString());
                    // cctvCam = int.parse(csvTable[rowIndex][7].toString());

                    // Center map to the selected location
                    MapWidget.mapKey.currentState?.centerMapToLocation(lat!, long!);

                    print('Lat: $lat, Long: $long');
                  }
                });
              },
              value: selectedOption,
              hint: Text('Select a location'),
            ),
          ],
        ),
      ),
    );
  }
}