import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'globals.dart';


class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Map<String, dynamic> _userDetails;
  late String _uid;

  @override
  void initState() {
    super.initState();
    _userDetails = {};
    _uid = "";
    fetchUserDetails();
  }

  Future<void> fetchUserDetails() async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/user_details'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({'uid': globalUid}),
      );
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (mounted) {
          setState(() {
            _userDetails = jsonResponse;
          });
        }
      } else {
        print('Failed to fetch user details');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Transparent background
        title: Text(
          'Profile Page',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('lib/images/background.png'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.1),
                BlendMode.dstATop,
              ),
            ),
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black), // Back icon color
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/images/background.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.1),
              BlendMode.dstATop,
            ),
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                buildProfileInfoCard('Child Name', _userDetails['child_name'], Icons.child_care),
                SizedBox(height: 15),
                buildProfileInfoCard('Child Age', _userDetails['child_age'], Icons.cake),
                SizedBox(height: 15),
                buildProfileInfoCard('Parent Name', _userDetails['parent_name'], Icons.person),
                SizedBox(height: 15),
                buildProfileInfoCard('Parent Phone', _userDetails['parent_contact'], Icons.phone),
                SizedBox(height: 15),
                buildProfileInfoCard('Address', _userDetails['address'], Icons.home),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildProfileInfoCard(String label, dynamic value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Color(0xFFEBC272),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 30, color: Colors.white),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Text(
                value != null ? value.toString() : 'N/A',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
