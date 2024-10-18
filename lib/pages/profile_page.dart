import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:untitled1/pages/globals.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Map<String, dynamic> _userDetails;
  late String _uid; // Add this line to store the user ID

  @override
  void initState() {
    super.initState();
    _userDetails = {}; // Initialize with empty details
    _uid = ""; // Initialize user ID
    fetchUserDetails();
  }

  Future<void> fetchUserDetails() async {
    try {


      // Make the POST request to fetch user details
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/user_details'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({'uid': globalUid}),
      );
      print(response.statusCode);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        // Check if the widget is still mounted before calling setState
        if (mounted) {
          setState(() {
            _userDetails = jsonResponse;
            print(_userDetails);
          });
        }
      } else {
        // Handle error
        print('Failed to fetch user details');
      }
    } catch (e) {
      // Handle exception
      print('Exception: $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF6F6F6), // Background color
        title: Text('Profile Page'),
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('lib/images/background.png'), // Image asset
              fit:
              BoxFit.cover, // Adjusts the image to cover the entire app bar
              colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.1), // 10% opacity (90% transparent)
                BlendMode.dstATop, // Apply the opacity to the image
              ),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/images/background.png'), // Image asset
            fit: BoxFit.cover, // Adjusts the image to cover the entire app bar
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.1), // 10% opacity (90% transparent)
              BlendMode.dstATop, // Apply the opacity to the image
            ),
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 16),
              Column(
                children: [
                  Container(
                    width: 270,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Color(0xFFEBC272)),
                    child: Column(
                      children: [
                        Text(
                          'Child Name:\n',
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          '${_userDetails['child_name'] ?? 'N/A'}',
                          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 5,),
                  Container(
                    width: 270,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Color(0xFFEBC272)),
                    child: Column(
                      children: [
                        Text(
                          'Child Age:\n',
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          '${_userDetails['child_age'] ?? 'N/A'}',
                          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 5,),
                  Container(
                    width: 270,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Color(0xFFEBC272)),
                    child: Column(
                      children: [
                        Text(
                          'Parent Name:\n',
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          '${_userDetails['parent_name'] ?? 'N/A'}',
                          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 5,),
                  Container(
                    width: 270,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Color(0xFFEBC272)),
                    child: Column(
                      children: [
                        Text(
                          'Parent Phone:\n',
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          '${_userDetails['parent_contact'] ?? 'N/A'}',
                          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 5,),
                  Container(
                    width: 270,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Color(0xFFEBC272)),
                    child: Column(
                      children: [
                        Text(
                          'Address:\n',
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          '${_userDetails['address'] ?? 'N/A'}',
                          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
