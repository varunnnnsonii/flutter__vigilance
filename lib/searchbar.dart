import 'dart:convert';

import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  final void Function(String) onSearch;

  SearchBar({required this.onSearch});

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  List<String> suggestions = [];

  @override
  void initState() {
    super.initState();
    _loadSuggestions();
  }

  Future<void> _loadSuggestions() async {
    final data = await DefaultAssetBundle.of(context).loadString('assets/locations.csv');
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
          padding: const EdgeInsets.all(30),
          child: Center(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for a road',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onChanged: (value) {
                widget.onSearch(value); // Call the onSearch function provided by the parent
              },
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(suggestions[index]),
                onTap: () {
                  widget.onSearch(suggestions[index]); // Call the onSearch function provided by the parent
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
