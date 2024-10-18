// globals.dart
library my_app.globals;


import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_page.dart';

String? globalUid; // Global variable to store the current user's UID

// Function to log the user in by setting the global UID and storing it in SharedPreferences
Future<void> setGlobalUid(String uid) async {
  globalUid = uid;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('user_id', uid); // Save UID in SharedPreferences
}

// Function to log the user out by clearing the global UID and SharedPreferences
Future<void> clearGlobalUid() async {
  globalUid = null;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('user_id'); // Remove UID from SharedPreferences
}



// Function to log the user out
Future<void> logout(BuildContext context) async {
  await clearGlobalUid(); // Clear global UID and SharedPreferences
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => LoginPage()),
  );
}


// Function to load UID from SharedPreferences and set it to the global variable
Future<void> loadGlobalUid() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  globalUid = prefs.getString('user_id'); // Load UID from SharedPreferences
}
