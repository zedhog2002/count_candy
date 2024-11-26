import 'package:flutter/material.dart';
import '../../models/answers.dart';

class Count1Page extends StatefulWidget {
  final Map<String, dynamic> data;

  const Count1Page({Key? key, required this.data}) : super(key: key);

  @override
  _Count1PageState createState() => _Count1PageState();
}

class _Count1PageState extends State<Count1Page> {
  String? selectedAnswer;

  void handleAnswerSelection(BuildContext context, String value, String correctAnswer) {
    setState(() {
      selectedAnswer = value;
    });

    if (value == correctAnswer) {
      generated_answer_counting[0] = 100.0;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Correct Answer!")),
      );
    } else {
      generated_answer_counting[0] = 0.0;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Try Again!")),
      );
    }

    // Pop the current page and return the score
    Future.delayed(Duration(milliseconds: 500), () {
      Navigator.pop(context, generated_answer_counting[0]);
    });
  }

  @override
  Widget build(BuildContext context) {
    final String questionString = widget.data['question_string'];
    final List<dynamic> options = widget.data['options'];
    final String correctAnswer = widget.data['answer'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Count 1 Quiz'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              questionString,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Image.network(widget.data['gen_image']),
            SizedBox(height: 20),
            ...options.map((option) => ListTile(
              title: Text(option),
              leading: Radio<String>(
                value: option,
                groupValue: selectedAnswer,
                onChanged: (value) {
                  if (value != null) {
                    handleAnswerSelection(context, value, correctAnswer);
                  }
                },
              ),
            )),
          ],
        ),
      ),
    );
  }
}
