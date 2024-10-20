import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'globals.dart'; // Import the global file
import '../components/my_button.dart';
import '../components/my_textfield.dart';
import 'home_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;

  LoginPage({super.key, this.onTap});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false; // Add a loading flag

  // Function to handle login
  Future<void> loginUser() async {
    try {
      setState(() {
        isLoading = true; // Set loading to true when starting the login process
      });

      final response = await http.post(
        Uri.parse('$apiUrl/login'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': emailController.text,
          'password': passwordController.text,
        }),
      );
      if (response.statusCode == 200) {
        // Extract user data
        final data = jsonDecode(response.body);
        final userId = data['uid'];
        print('User ID from backend: $userId');

        // Store userId in SharedPreferences and set it globally
        await setGlobalUid(userId); // Store in SharedPreferences and set global UID

        // Navigate to HomePage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        // Show error
        showErrorMessage('Login failed. Check credentials.');
      }
    } catch (e) {
      showErrorMessage('An error occurred. Please try again.');
    } finally {
      setState(() {
        isLoading = false; // Set loading to false after the request completes
      });
    }
  }

  // Error display
  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(message),
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
        body: Stack(
          children: [
            SingleChildScrollView(
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
                                  'Login',
                                  style: TextStyle(
                                    color: const Color.fromARGB(255, 23, 0, 0),
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
                              const SizedBox(height: 10),
                              MyTextField(
                                controller: passwordController,
                                hintText: 'Password',
                                obscureText: true,
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Forgot Password?',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 25),
                              MyButton(
                                text: "Sign In",
                                onTap: loginUser,
                              ),
                              const SizedBox(height: 15),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Not a member?",
                                    style: TextStyle(color: Colors.grey[700]),
                                  ),
                                  const SizedBox(width: 4),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => RegisterPage(),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      "Register now",
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
            if (isLoading)
              Center(
                child: CircularProgressIndicator(), // Display a loading indicator while isLoading is true
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
