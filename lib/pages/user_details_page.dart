import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'globals.dart'; // Import your global file
import 'package:untitled1/components/my_textfield.dart';
import 'package:untitled1/pages/home_page.dart';

class UserDetailsPage extends StatefulWidget {
  final Function()? onDetailsSubmitted;
  UserDetailsPage({super.key, this.onDetailsSubmitted});

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController parentsNameController = TextEditingController();
  final TextEditingController parentsPhoneNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController preferredSubjectController = TextEditingController();

  Future<void> saveUserDetails(
      String childName, int childAge, String childGender, String parentName, String parentPhone, String address, String preferredSubject) async {
    try {
      // Use the global UID instead of fetching it from SharedPreferences
      if (globalUid == null || globalUid!.isEmpty) {
        throw Exception('User UID not found. Please log in again.');
      }

      // Send the profile data to the FastAPI server
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/profile'), // Replace with your FastAPI backend URL
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'uid': globalUid, // Use the globalUid directly
          "child_name": childName,
          "child_age": childAge,
          "child_gender": childGender,
          "parent_name": parentName,
          "parent_contact": parentPhone,
          "address": address,
          "preferred_subject": preferredSubject,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception('Failed to save profile data on the server');
      }
    } catch (e) {
      print('Error while saving user details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFEBC272),
        elevation: 10,
        shadowColor: Color.fromARGB(255, 46, 46, 46),
        title: Text('User Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context); // Close the UserDetailsPage
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFFF6F6F6), // Background color
          image: DecorationImage(
            image: AssetImage('lib/images/background.png'), // Image asset
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.1), // 10% opacity (90% transparent)
              BlendMode.dstATop, // Apply the opacity to the image
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyTextField(
                controller: nameController,
                hintText: 'Name',
                obscureText: false,
              ),
              const SizedBox(height: 20),
              MyTextField(
                controller: ageController,
                hintText: 'Age',
                obscureText: false,
              ),
              MyTextField(
                controller: genderController,
                hintText: 'Gender',
                obscureText: false,
              ),
              const SizedBox(height: 20),
              MyTextField(
                controller: parentsNameController,
                hintText: "Parents' Name",
                obscureText: false,
              ),
              const SizedBox(height: 20),
              MyTextField(
                controller: parentsPhoneNumberController,
                hintText: "Parents' Phone Number",
                obscureText: false,
              ),
              const SizedBox(height: 20),
              MyTextField(
                controller: addressController,
                hintText: 'Address',
                obscureText: false,
              ),
              MyTextField(
                controller: preferredSubjectController,
                hintText: 'Preferred Subject',
                obscureText: false,
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    minimumSize: MaterialStateProperty.all<Size>(Size(350.0, 50)),
                    elevation: MaterialStateProperty.all<double>(20.0),
                  ),
                  onPressed: () async {
                    // Save user profile data
                    await saveUserDetails(
                      nameController.text,
                      int.tryParse(ageController.text) ?? 0,
                      genderController.text,
                      parentsNameController.text,
                      parentsPhoneNumberController.text,
                      addressController.text,
                      preferredSubjectController.text,

                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ),
                    );
                  },
                  child: Text('Submit details'),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: 100.0,
        height: 100.0,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pop(context); // Close the UserDetailsPage
          },
          tooltip: 'Back to Home',
          backgroundColor: Color(0xFFEBC272),
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Transform.scale(scale: 1.8, child: Icon(Icons.home)),
        ),
      ),
    );
  }
}
