import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../components/my_button.dart';
import '../components/my_textfield.dart';
import 'home_page.dart';
import 'login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'globals.dart';
import 'user_details_page.dart'; // Import the global file


class RegisterPage extends StatefulWidget {
  final Function()? onTap;

  RegisterPage({super.key, this.onTap});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Function to handle user registration
  void signUserUp() async {
    if (passwordController.text != confirmPasswordController.text) {
      showErrorMessage("Passwords do not match.");
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('$apiUrl/register'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'email': emailController.text,
          'username': usernameController.text,
          'password': passwordController.text,
          'confirm_password': passwordController.text
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final userId = data['uid'];
        print('User ID from backend: $userId');

        await setGlobalUid(userId); // Store in SharedPreferences and set global UID

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => UserDetailsPage()));
      } else {
        showErrorMessage('Failed to register.');
      }
    } catch (e) {
      showErrorMessage('An error occurred during registration.');
    }
  }

  // Function to display error messages
  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Dismiss the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFEBC272),
        image: DecorationImage(
          image: AssetImage('lib/images/background.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 180),
                    Container(
                      width: screenWidth,
                      padding: EdgeInsets.fromLTRB(0, 30, 0, 30.0),
                      decoration: BoxDecoration(
                        color: Color(0xFFEBC272),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(10.0),
                          bottom: Radius.circular(10.0),
                        ),
                        border: Border.all(color: Colors.white),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(width: 50),
                          Row(
                            children: [
                              const SizedBox(width: 30),
                              Image.asset(
                                'lib/images/App_logo.png',
                                width: 75,
                                height: 75,
                              ),
                              const SizedBox(width: 20),
                              Text(
                                'CountCandy',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 43,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                            child: Text(
                              'Register',
                              style: TextStyle(
                                color: const Color.fromARGB(255, 0, 0, 0),
                                fontSize: 33,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          MyTextField(
                            controller: emailController,
                            hintText: 'Email',
                            obscureText: false,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 5),
                                Text(
                                  'Email must be in the format: example@domain.com',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          MyTextField(
                            controller: usernameController,
                            hintText: 'Username',
                            obscureText: false,
                          ),
                          const SizedBox(height: 20),
                          MyTextField(
                            controller: passwordController,
                            hintText: 'Password',
                            obscureText: true,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 5),
                                Text(
                                  'Password must contain:',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '- At least 8 characters',
                                  style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                                ),
                                Text(
                                  '- At least one uppercase letter',
                                  style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                                ),
                                Text(
                                  '- At least one lowercase letter',
                                  style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                                ),
                                Text(
                                  '- At least one number',
                                  style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                                ),
                                Text(
                                  '- At least one special character (@, \$, !, %, *, ?, &)',
                                  style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          MyTextField(
                            controller: confirmPasswordController,
                            hintText: 'Confirm Password',
                            obscureText: true,
                          ),
                          const SizedBox(height: 25),
                          MyButton(
                            text: "Sign Up",
                            onTap: signUserUp,
                          ),
                          const SizedBox(height: 50),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already have an account?",
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                              const SizedBox(width: 4),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage()),
                                  );
                                },
                                child: const Text(
                                  "Login now",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}

