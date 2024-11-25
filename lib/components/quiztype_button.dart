import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:untitled1/data/quiz_data.dart';


import '../models/generated_question.dart';
import '../models/question.dart';
import '../pages/generated_quiz_page.dart';
import '../pages/globals.dart';
import '../pages/quiz_page.dart';




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

  Future<void> generateQuestions(
      String? globalUid, String quizType, BuildContext context) async {
    // Dummy question data specific to count_1
    final Map<String, dynamic> jsonData = {
      "question_quiznumber": "count_1", // Matches the 'questiontypenumber' field
      "question_string": "How many apples are there in the image?",
      "gen_image": "https://example.com/sample-image.png",
      "options": ["3", "5", "7", "9"],
      "answer": "5"
    };

    // Create a GeneratedQuestion object
    final generatedQuestion = GeneratedQuestion.fromJson(jsonData);

    // Navigate to the GeneratedQuizPage
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GeneratedQuizPage(
          generated_question: generatedQuestion,
        ),
      ),
    );
  }



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
          if (isFirstQuizAttempt) {
            // First attempt: Navigate directly to the QuizPage with predefined questions
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => QuizPage(
                  questions: questions,
                  quizType: quizType,
                ),
              ),
            );
          } else {
            // Second or subsequent attempts: Generate a new question dynamically
            loadGlobalUid(); // Ensure the globalUid is available
            await generateQuestions(globalUid, quizType, context);
          }

          // Mark as not first attempt after navigation
          if (quizType == 'counting') isFirstAttempt_counting = false;
          //if (quizType == 'coloring') isFirstAttempt_coloring = false;
          //if (quizType == 'calculate') isFirstAttempt_calculation = false;
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
