import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class _SearchBarState extends State<SearchBar> {
  List<String> suggestions = [];

  @override
  void initState() {
    super.initState();
    _loadSuggestions();
  }

  Future<void> _loadSuggestions() async {
    final data = await rootBundle.loadString('assets/locations.csv');
    final List<String> lines = LineSplitter.split(data).toList();
    setState(() {
      suggestions = lines;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search for police stations',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onChanged: (value) {
              // You can implement search functionality here
              // For example, filter the suggestions list based on the entered value
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(suggestions[index]),
                onTap: () {
                  // Implement your logic when a suggestion is tapped
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
