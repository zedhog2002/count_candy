import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/components/my_button.dart';
import 'package:untitled1/components/my_textfield.dart';
import 'package:untitled1/components/square_tile.dart';
import 'package:untitled1/pages/login_page.dart';
import 'package:untitled1/pages/user_details_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:untitled1/pages/login_page.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  RegisterPage({super.key, this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //text editing controllers
  final emailController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController(); // IMPLEMENT USER NAME
  // ***************************************************************************************************************
  //****************************************************************************************************************

  void signUserUp() async {
    if (!mounted) return;

    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    try {
      if (passwordController.text == confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        getUserID();
        Navigator.pop(context); // Close the loading circle

        navigateToUserDetailsPage();
      } else {
        Navigator.pop(context); // Close the loading circle
        showErrorMessage("Passwords don't match");
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      Navigator.pop(context); // Close the loading circle
      showErrorMessage(e.code);
    }
  }

// Separate method to get the user ID
  Future<void> getUserID() async {
    // Retrieve the currently signed-in user
    User? user = FirebaseAuth.instance.currentUser;
    String uid = user?.uid ?? ""; // Fetch the UID
    print("User UID: $uid");

    await sendUserDetailsToBackend(uid, emailController.text,
        passwordController.text, emailController.text);
  }

  Future<void> sendUserDetailsToBackend(
      String uid, String email, String password, String username) async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://flask-dyscalculia.onrender.com/register_user'), // Replace with your Flask backend URL
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'uid': uid,
          'email': email,
          'password': password,
          'username': username,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception('Failed to register user on the server');
      }
    } catch (e) {
      print('Error from Flutter: $e');
    }
  }

  //show error message
  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text(
              message,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        );
      },
    );
  }

  // Future<void> sendQuizResults(Map<String, List<double>> userAnswers) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse('http://127.0.0.1:5566/register_user'), // Replace with your Flask backend URL
  //       headers: <String, String>{
  //         'Content-Type': 'application/json; charset=UTF-8',
  //       },
  //       body: jsonEncode({
  //         'counting_input': userAnswers['counting'],
  //         'color_input': userAnswers['coloring'],
  //       }),
  //     );

  //     print('Response status: ${response.statusCode}');
  //     print('Response body: ${response.body}');

  //     if (response.statusCode == 200) {
  //       // Parse the response and handle the prediction as needed
  //       Map<String, dynamic> data = json.decode(response.body);
  //       double newPrediction = data['prediction'];
  //       print('Prediction: $newPrediction');

  //       // Update the state to trigger a UI refresh with the new prediction
  //       // setState(() {
  //       //   prediction = newPrediction;
  //       //   quizSubmitted = true; // Mark the quiz as submitted
  //       // });
  //     } else {
  //       throw Exception('Failed to submit quiz results');
  //     }
  //   } catch (e) {
  //     print('Error from quiz_result_page.dart: $e');
  //   }
  // }

  void navigateToUserDetailsPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserDetailsPage(),
      ),
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
                      const SizedBox(
                        height: 180,
                      ),
                      Container(
                        width: screenWidth,
                        padding: EdgeInsets.fromLTRB(0, 30, 0, 30.0),
                        decoration: BoxDecoration(
                          color: Color(0xFFEBC272),
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(
                                10.0), // Set top vertical radius
                            bottom: Radius.circular(
                                10.0), // Set bottom vertical radius to zero (no radius)
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
                                  width: 75, // Adjust the width as needed
                                  height: 75, // Adjust the height as needed
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
                            const SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                              child: Text(
                                'Register',
                                style: TextStyle(
                                    color: const Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 33),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            //email/ textfield
                            MyTextField(
                              controller: emailController,
                              hintText: 'Email',
                              obscureText: false,
                            ),
                            const SizedBox(
                              height: 20,
                            ),

                            //password textfield
                            MyTextField(
                              controller: passwordController,
                              hintText: 'Password',
                              obscureText: true,
                            ),

                            const SizedBox(
                              height: 10,
                            ),

                            //confirm password
                            MyTextField(
                              controller: confirmPasswordController,
                              hintText: 'Confirm Password',
                              obscureText: true,
                            ),

                            const SizedBox(
                              height: 10,
                            ),

                            const SizedBox(height: 25),

                            //sign in button
                            MyButton(
                              text: "sign Up",
                              onTap: signUserUp,
                            ),

                            const SizedBox(height: 50),

                            //or continue with

                            //not a member? register here
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Already have an account?",
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // Navigate to the register page
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              LoginPage()), // Replace 'RegisterPage' with the actual name of your register page class
                                    );
                                  },
                                  child: const Text(
                                    "Login now",
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold),
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
        ));
  }
}
