import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'globals.dart'; // Import the globals file
import 'home_page.dart';
import 'login_or_register_page.dart';


class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

// Check if the user is logged in by looking for a stored UID in SharedPreferences
  Future<bool> checkIfLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString("user_id");
    return uid != null; // If UID exists, user is logged in
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: checkIfLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData && snapshot.data == true) {
          loadGlobalUid(); // Load UID into globalUid
          return HomePage(); // If the user is logged in, navigate to HomePage
        } else {
          return LoginOrRegisterPage(); // Otherwise, show login/register page
        }
      },
    );
  }
}
