import 'package:flutter/material.dart';

class Count1Page extends StatefulWidget {
  final Map<String, dynamic> data;

  const Count1Page({Key? key, required this.data}) : super(key: key);

  @override
  _Count1PageState createState() => _Count1PageState();
}

class _Count1PageState extends State<Count1Page> {
  String? selectedAnswer;

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
                  setState(() {
                    selectedAnswer = value;
                  });

                  if (value == correctAnswer) {
                    // Show success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Correct Answer!")),
                    );
                  } else {
                    // Show error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Try Again!")),
                    );
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
