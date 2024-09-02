import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  TextEditingController locController = TextEditingController();
  List<String> suggestions = [];

  void searchLocation(String query) async {
    final apiKey = 'd37b70dcd05240a7a94d484f53f562ba';
    final response = await http.get(
      Uri.parse('https://api.opencagedata.com/geocode/v1/json?q=$query&key=$apiKey'),
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var results = data['results'] as List;

      setState(() {
        suggestions = results.map((result) => result['formatted'] as String).toList();
      });
    } else {
      throw Exception('Failed to load suggestions');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/Image.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 50,
                      child: TextFormField(
                      style:const  TextStyle(color: Colors.white),
                        controller: locController,
                        onChanged: (value) {
                          searchLocation(value);
                        },
                        decoration: InputDecoration(
                      
                          hintText: 'Enter City',
                          hintStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: suggestions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        suggestions[index],
                        style: const TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                  
                        locController.text = suggestions[index];
                        
                        setState(() {
                          suggestions.clear();
                        });
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
