import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'globals.dart';
import 'home_page.dart';

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
  bool isLoading = false; // Add a loading flag
  bool _isDisposed = false; // Add a flag to track if the widget is disposed

  @override
  void dispose() {
    _isDisposed = true; // Set the flag to true when the widget is disposed
    super.dispose();
  }

  // Post quiz results to the backend
  Future<void> quiz_update() async {
    int quizid;
    int avgResult;

    try {
      if (!_isDisposed) {
        setState(() {
          isLoading = true; // Set loading to true before starting the API call
        });
      }

      List<int> questionids = widget.questionids;

      if (widget.quizType == 'counting') {
        quizid = 1;
        List<double>? countingAnswers = widget.userAnswers['counting'] ?? [];
        avgResult = _calculateAverage(countingAnswers);
      } else if (widget.quizType == 'coloring') {
        quizid = 2;
        List<double>? coloringAnswers = widget.userAnswers['coloring'] ?? [];
        avgResult = _calculateAverage(coloringAnswers);
      } else if (widget.quizType == 'calculate') {
        quizid = 3;
        List<double>? calculationAnswers = widget.userAnswers['calculate'] ?? [];
        avgResult = _calculateAverage(calculationAnswers);
      } else {
        throw Exception('Invalid quiz type: ${widget.quizType}');
      }

      // Post the quiz results to the FastAPI backend
      final response = await http.post(
        Uri.parse('$apiUrl/score'),
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'uid': globalUid,
          'quiz_id': quizid,
          'question1_id': questionids[0],
          'question2_id': questionids[1],
          'question3_id': questionids[2],
          'question4_id': questionids[3],
          'question5_id': questionids[4],
          'average_result': avgResult,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update quiz results');
      }

      // Check if all quizzes are completed and get prediction
      await checkAllQuizzesAndPredict();
    } catch (e) {
      print('Error from quiz_result_page.dart: $e');
    } finally {
      if (!_isDisposed) {
        setState(() {
          isLoading = false; // Set loading to false after completing the request
        });
      }
    }
  }

  // Check if all quizzes are completed and handle prediction
  Future<void> checkAllQuizzesAndPredict() async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/predict'),
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'uid': globalUid,
        }),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        if (data.containsKey('quizzes_to_attempt')) {
          // If not all quizzes are completed, show missing quizzes
          _showMissingQuizzes(data['quizzes_to_attempt']);
        } else if (data.containsKey('result')) {
          // If prediction is available, display it
          if (!_isDisposed) {
            setState(() {
              prediction = data['result'];
              quizSubmitted = true;
            });
          }
        }
      } else {
        throw Exception('Failed to fetch prediction');
      }
    } catch (e) {
      print('Error from checkAllQuizzesAndPredict: $e');
    }
  }

  // Show missing quizzes in an alert dialog
  void _showMissingQuizzes(List<dynamic> missingQuizzes) {
    if (!_isDisposed) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Incomplete Quizzes'),
            content: Text(
                'Please attempt the following quizzes: ${missingQuizzes.join(', ')}'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
  }

  // Helper function to calculate average score
  int _calculateAverage(List<double> answers) {
    if (answers.isNotEmpty) {
      return ((answers.fold(0.0, (sum, score) => sum + score) / 5) * 100).toInt();
    } else {
      return 0; // Default to 0 if no answers are present
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Results'),
        backgroundColor: Colors.transparent,
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
      ),
      body: Stack(
        children: [
          Container(
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Image.asset("lib/images/Result_page.png", width: 340, height: 350),
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
                      borderRadius: BorderRadius.circular(15),
                    ),
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
                          '${_calculateAverage(widget.userAnswers[widget.quizType] ?? [])} %',
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
                  ElevatedButton(
                    onPressed: () async {
                      await quiz_update(); // Post quiz results and check for prediction
                      // Navigate back to the HomePage after submitting the quiz
                      if (!_isDisposed) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),  // Pass any necessary parameters to HomePage
                              (Route<dynamic> route) => false,  // Remove all previous routes
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFEBC272),
                      minimumSize: Size(270, 60),
                    ),
                    child: Text(
                      'Submit Quiz Results',
                      style: TextStyle(fontSize: 25, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isLoading)
            Center(
              child: CircularProgressIndicator(), // Display a loading indicator while isLoading is true
            ),
        ],
      ),
    );
  }
}
