import 'package:flutter/material.dart';
// Import other pages as needed

import '../models/generated_question.dart';
import 'count_widgets/count_1.dart';

class GeneratedQuizPage extends StatelessWidget {
  final GeneratedQuestion generated_question;

  const GeneratedQuizPage({Key? key, required this.generated_question})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Check the `questiontypenumber` and render the appropriate widget
    switch (generated_question.question_quiznumber) {
      case "count_1": // For count_1 type question
        return Count1Page(data: generated_question.data);
      default:
        return Scaffold(
          appBar: AppBar(title: Text("Generated Quiz")),
          body: Center(
            child: Text(
              'Unknown question type: ${generated_question.question_quiznumber}',
              style: TextStyle(color: Colors.red, fontSize: 18),
            ),
          ),
        );
    }
  }
}
