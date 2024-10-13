import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:untitled1/models/answers.dart';
import 'dart:convert';
import 'package:untitled1/pages/home_page.dart'; // For JSON encoding
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class QuizResultPage extends StatefulWidget {
  final Map<String, List<double>> userAnswers;
  final String quizType;
  final List<int> questionids;
  const QuizResultPage({
    Key? key,
    required this.userAnswers,
    required this.quizType,
    required this.questionids,
  }) : super(key: key);

  @override
  _QuizResultPageState createState() => _QuizResultPageState();
}

class _QuizResultPageState extends State<QuizResultPage> {
  double? prediction;
  bool quizSubmitted = false;

  // Track the completion of all quizzes
  bool countingCompleted = false;
  bool coloringCompleted = false;
  bool calculateCompleted = false;


  Future<void> getUserID() async {
    // Retrieve the currently signed-in user
    User? user = FirebaseAuth.instance.currentUser;
    String uid = user?.uid ?? ""; // Fetch the UID
    print("User UID: $uid");

    await quiz_update(uid);
  }

  Future<void> quiz_update(String uid) async {
    int quizid;
    int avgResult;
    try {
      List<int> questionids = widget.questionids;

      if (widget.quizType == 'counting') {
        quizid = 2;

        // Ensure widget.userAnswers['counting'] is not null
        List<double>? countingAnswers = widget.userAnswers['counting'] ?? [];
        if (countingAnswers.isNotEmpty) {
          avgResult = ((countingAnswers.fold(0.0, (sum, score) => sum + score) / 5) * 100).toInt();
        } else {
          avgResult = 0; // Default to 0 if no answers are present
        }
        countingCompleted = true; // Mark counting as completed
      } else if (widget.quizType == 'coloring') {
        quizid = 1;

        // Ensure widget.userAnswers['coloring'] is not null
        List<double>? coloringAnswers = widget.userAnswers['coloring'] ?? [];
        if (coloringAnswers.isNotEmpty) {
          avgResult = ((coloringAnswers.fold(0.0, (sum, score) => sum + score) / 5) * 100).toInt();
        } else {
          avgResult = 0; // Default to 0 if no answers are present
        }
        coloringCompleted = true; // Mark coloring as completed
      } else if (widget.quizType == 'calculate') {
        quizid = 3;

        // Ensure widget.userAnswers['calculate'] is not null
        List<double>? calculationAnswers = widget.userAnswers['calculate'] ?? [];
        if (calculationAnswers.isNotEmpty) {
          avgResult = ((calculationAnswers.fold(0.0, (sum, score) => sum + score) / 5) * 100).toInt();
        } else {
          avgResult = 0; // Default to 0 if no answers are present
        }
        calculateCompleted = true; // Mark calculate as completed
      } else {
        throw Exception('Invalid quiz type: ${widget.quizType}');
      }

      // Perform the API call to update the quiz result
      final response = await http.post(
        Uri.parse('https://flask-dyscalculia.onrender.com/quiz_update'),
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'uid': uid,
          'questionids': questionids,
          'quizid': quizid,
          'avg_result': avgResult,
        }),
      );

      print('Quiz Update Response status: ${response.statusCode}');
      print('Quiz Update Response body: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception('Failed to update quiz results');
      }

      // If all quizzes are completed, send the results
      if (countingCompleted && coloringCompleted && calculateCompleted) {
        await sendQuizResults(widget.userAnswers, uid);
        resetQuizCompletionTracking(); // Reset after sending results
      }
    } catch (e) {
      print('Error from quiz_result_page.dart: $e');
    }
  }


  int getQuizId(String quizType) {
    switch (quizType) {
      case 'counting':
        return 2;
      case 'coloring':
        return 1;
      case 'calculate':
        return 3;
      default:
        throw Exception('Invalid quiz type: $quizType');
    }
  }

  Future<void> getUserID1(Map<String, List<double>> userAnswers) async {
    // Retrieve the currently signed-in user
    User? user = FirebaseAuth.instance.currentUser;
    String uid = user?.uid ?? ""; // Fetch the UID
    print("User UID: $uid");

    await sendQuizResults(userAnswers, uid);
  }

  Future<void> sendQuizResults(
      Map<String, List<double>> userAnswers, String uid) async {
    try {
      // Null safety check for userAnswers entries
      List<double>? countingInput = userAnswers['counting'] ?? [];
      List<double>? colorInput = userAnswers['coloring'] ?? [];
      List<double>? calculationInput = userAnswers['calculation'] ?? [];

      // Print logs to check what you're sending
      print("Counting input: $countingInput");
      print("Color input: $colorInput");
      print("Calculation input: $calculationInput");

      final response = await http.post(
        Uri.parse('https://flask-dyscalculia.onrender.com/predict'), // Replace with your Flask backend URL
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'counting_input': countingInput,
          'color_input': colorInput,
          'calculation_input': calculationInput,
          'uid': uid,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // Parse the response and handle the prediction as needed
        Map<String, dynamic> data = json.decode(response.body);
        double newPrediction = data['prediction'];
        print('Prediction: $newPrediction');

        // Update the state to trigger a UI refresh with the new prediction
        setState(() {
          prediction = newPrediction;
          quizSubmitted = true; // Mark the quiz as submitted
        });
      } else {
        throw Exception('Failed to submit quiz results');
      }
    } catch (e) {
      print('Error from quiz_result_page.dart: $e');
    }
  }


  // Reset the tracking variables after prediction
  void resetQuizCompletionTracking() {
    countingCompleted = false;
    coloringCompleted = false;
    calculateCompleted = false;
  }


  int calculateScore() {
    String quizType = widget.quizType;
    List<double> scores = widget.userAnswers[quizType]!;
    return ((scores.fold(0.0, (sum, score) => sum + score) / 5) * 100).toInt();
  }

  @override
  Widget build(BuildContext context) {
    int totalQuestions = widget.userAnswers.length;

    bool allQuizzesAttempted = widget.userAnswers['counting'] != null &&
        widget.userAnswers['counting']!.isNotEmpty &&
        widget.userAnswers['coloring'] != null &&
        widget.userAnswers['coloring']!.isNotEmpty &&
        widget.userAnswers['calculate'] != null &&
        widget.userAnswers['calculate']!.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text('Results'),
        backgroundColor: Colors.transparent, // Make the app bar transparent
        elevation: 0, // Remove the app bar's elevation
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
            fit:
            BoxFit.cover, // Adjusts the image to cover the entire container
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.1), // 10% opacity (90% transparent)
              BlendMode.dstATop, // Apply the opacity to the image
            ),
          ),
          // Replace with your desired background color and opacity
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Image.asset("lib/images/Result_page.png",
                  width: 340, height: 350),
              Text(
                'Tiny Rockstar! Your Results\n are here!',
                style: TextStyle(fontSize: 20.0),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.0),
              Container(
                width: 300,
                height: 110,
                decoration: BoxDecoration(
                    color: Color(0xFF373737),
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Your accuracy score for ${widget.quizType} questions is',
                      style: TextStyle(fontSize: 14.0, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      '${calculateScore()} %',
                      style: TextStyle(fontSize: 45, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                'Quiz-tastic! Your brain is like a superhero -\n swooping in to save the day!',
                style: TextStyle(fontSize: 13),
              ),
              SizedBox(height: 40.0),
              allQuizzesAttempted
                  ? ElevatedButton(
                onPressed: () async {
                  await getUserID1(widget.userAnswers);
                  await getUserID();

                  if (mounted) { // Ensure the widget is still mounted before navigation
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(
                          listfromresult: widget.userAnswers,
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFEBC272), // Button color EBC272
                  minimumSize: Size(270, 60),
                ),
                child: Text(
                  'Submit Quiz Results',
                  style: TextStyle(fontSize: 25, color: Colors.black),
                ),
              )
                  : ElevatedButton(
                onPressed: () async {
                  await getUserID1(widget.userAnswers);
                  await getUserID();

                  if (mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(
                          listfromresult: widget.userAnswers,
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFEBC272),
                  minimumSize: Size(270, 60),
                ),
                child: Text(
                  'Go to Home',
                  style: TextStyle(fontSize: 25, color: Colors.black),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}