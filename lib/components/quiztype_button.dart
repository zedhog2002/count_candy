import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/pages/quiz_page.dart';
import 'package:untitled1/data/quiz_data.dart';
import 'package:untitled1/models/question.dart';

class QuizTypeButton extends StatelessWidget {
  final String button_text;
  final Color button_color;
  final List<Question> questions;
  final String quizType;
  final String buttonImage;

  const QuizTypeButton({
    Key? key,
    required this.button_color,
    required this.button_text,
    required this.questions,
    required this.quizType,
    required this.buttonImage,
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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuizPage(questions: questions, quizType: quizType),
            ),
          );
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
