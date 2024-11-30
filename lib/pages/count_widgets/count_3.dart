import 'package:flutter/material.dart';
import '../../models/answers.dart';

class Count3Page extends StatefulWidget {
  final Map<String, dynamic> data;

  const Count3Page({Key? key, required this.data}) : super(key: key);

  @override
  _Count3PageState createState() => _Count3PageState();
}

class _Count3PageState extends State<Count3Page> {
  String? selectedAnswer;

  void handleAnswerSelection(BuildContext context, String value, String correctAnswer) {
    setState(() {
      selectedAnswer = value;
    });

    if (value == correctAnswer) {
      generated_answer_counting[2] = 100.0;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Correct Answer!")),
      );
    } else {
      generated_answer_counting[2] = 0.0;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Try Again!")),
      );
    }

    // Pop the current page and return the score
    Future.delayed(Duration(milliseconds: 500), () {
      Navigator.pop(context, generated_answer_counting[2]);
    });
  }

  @override
  Widget build(BuildContext context) {
    final String questionString = widget.data['question_string'];
    final List<dynamic> options = widget.data['options'];
    final String correctAnswer = widget.data['answer'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF6F6F6),
        title: Text('Count 3 Quiz'),
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
      body: Container(
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform.scale(
                scale: 1.25,
                child: Image.network(
                  widget.data['gen_image'],
                  width: 200,
                  height: 200,
                ),
              ),
              SizedBox(height: 40.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  questionString,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Column(
                children: List.generate(
                  options.length,
                      (index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ElevatedButton(
                      onPressed: () =>
                          handleAnswerSelection(context, options[index], correctAnswer),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFEBC272),
                        minimumSize: Size(270, 45),
                      ),
                      child: Text(
                        options[index],
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
