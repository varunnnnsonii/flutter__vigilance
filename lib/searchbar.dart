// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart' show rootBundle;
// import 'package:csv/csv.dart';
// import 'package:vigilance2/map.dart';
//
// class CustomSearchBar extends StatefulWidget {
//
//
//
//   @override
//   _CustomSearchBarState createState() => _CustomSearchBarState();
// }
//
// class _CustomSearchBarState extends State<CustomSearchBar> {
//   List<String> suggestions = [];
//   List<List<dynamic>> csvTable = [];
//   String? selectedOption;
//   double? lat;
//   double? long;
//   int? pDist;
//   int? criRate;
//   int? cctvCam;
//
//   void _onLocationSelected(double lat, double long) {
//     MapWidget.mapKey.currentState?.centerMapToLocation(lat, long);
//   }
//
//
//   @override
//   void initState() {
//     super.initState();
//     _loadSuggestions();
//   }
//
//
//
//   Future<void> _loadSuggestions() async {
//     final data = await rootBundle.loadString('assets/anaums.csv');
//     csvTable = const CsvToListConverter().convert(data);
//
//     setState(() {
//       suggestions = csvTable.map((row) => row[1].toString()).toList();
//     });
//   }
//
//
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         borderRadius: BorderRadius.all(Radius.circular(15)),
//         color: Colors.white,
//       ),
//       child: Center(
//         child: Column(
//           children: [
//             DropdownButton<String>(
//               items: suggestions.map((String value) {
//                 return DropdownMenuItem<String>(
//                   value: value,
//                   child: Text(value),
//                 );
//               }).toList(),
//               onChanged: (newValue) {
//                 print('Dropdown option selected: $newValue');
//                 setState(() {
//                   selectedOption = newValue;
//                   final rowIndex = suggestions.indexOf(newValue!);
//                   if (rowIndex >= 0 && rowIndex < csvTable.length) {
//                     lat = csvTable[rowIndex][3];
//                     long = csvTable[rowIndex][4];
//                     _onLocationSelected(lat!, long!);
//                     //_onLocationSelected(19.174472, 72.866);
//                     // pDist = int.parse(csvTable[rowIndex][5].toString());
//                     // criRate = int.parse(csvTable[rowIndex][6].toString());
//                     // cctvCam = int.parse(csvTable[rowIndex][7].toString());
//
//                     // Center map to the selected location
//                     // MapWidget.mapKey.currentState?.centerMapToLocation(lat!, long!);
//
//                     print('Lat: $lat, Long: $long');
//                   }
//                 });
//               },
//               value: selectedOption,
//               hint: const Text('Select a location'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }