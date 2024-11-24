import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:untitled1/data/quiz_data.dart';


import '../models/question.dart';
import '../pages/globals.dart';
import '../pages/quiz_page.dart';




Future<List<Map<String, dynamic>>> generateQuestions(String? uid) async {
  List<Map<String, dynamic>> quizQuestions = [];

  try {
    // Call /flux_image to get the question and answer
    var fluxResponse = await http.post(
      Uri.parse('{$apiUrl}/flux_image'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({"uid": uid}),
    );

    if (fluxResponse.statusCode == 200) {
      var fluxData = json.decode(fluxResponse.body);

      // Extract question string and answer
      String questionString = fluxData["prompt"];
      String answer = fluxData["result"];

      // Call /get_image to retrieve the question image
      var imageResponse = await http.post(
        Uri.parse('{$apiUrl}/get_image'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({"uid": uid}),
      );

      if (imageResponse.statusCode == 200) {
        // Extract the image URL (or image data)
        String questionImage = "https://your-image-storage.com/${uid}.jpg"; // Adjust based on your API response

        // Add to the question list
        quizQuestions.add({
          "question": questionString,
          "image": questionImage,
          "answer": answer,
        });
      }
    }
  } catch (e) {
    print("Error generating questions: $e");
  }

  return quizQuestions;
}



class QuizTypeButton extends StatelessWidget {
  final String button_text;
  final Color button_color;
  final List<Question> questions;
  final String quizType;
  final String buttonImage;
  final bool isFirstQuizAttempt;

  const QuizTypeButton({
    Key? key,
    required this.button_color,
    required this.button_text,
    required this.questions,
    required this.quizType,
    required this.buttonImage,
    required this.isFirstQuizAttempt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Makes the button take full width of its container
      height: MediaQuery.of(context).size.height * 0.18,  // Responsive height based on screen size
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: button_color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          shadowColor: Colors.black,
          elevation: 12,
        ),
        onPressed: () async {
          List<Map<String, dynamic>> quizQuestions;

          if (!isFirstQuizAttempt) {
            // Use the predefined questions for the first attempt
            loadGlobalUid();
            quizQuestions = await generateQuestions(globalUid);
          }

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuizPage(questions: questions, quizType: quizType),
            ),
          );

          // Mark as not first attempt after navigation
          if (quizType == 'counting') isFirstAttempt_counting = false;
          if (quizType == 'coloring') isFirstAttempt_coloring = false;
          if (quizType == 'calculate') isFirstAttempt_calculation = false;
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 26,
              width: 110,
              decoration: BoxDecoration(
                color: Color(0xFF373737),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  button_text,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02), // Responsive spacing
            Transform.scale(
              scale: 1.75,
              child: Image.asset(
                buttonImage,
                height: 40,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          ],
        ),
      ),
    );
  }
}
