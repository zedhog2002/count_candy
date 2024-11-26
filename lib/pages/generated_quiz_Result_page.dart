import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:untitled1/models/answers.dart';
import 'dart:convert';
import 'globals.dart';
import 'home_page.dart';

class GeneratedQuizResultPage extends StatefulWidget {
  final String quizType;

  const GeneratedQuizResultPage({
    Key? key,
    required this.quizType,
  }) : super(key: key);

  @override
  _GeneratedQuizResultPageState createState() => _GeneratedQuizResultPageState();
}


class _GeneratedQuizResultPageState extends State<GeneratedQuizResultPage> {



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
                          '${generatedUserAnswer[widget.quizType]} %',
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
                      // Navigate to HomePage and remove the current page from the navigation stack
                      await Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()), // HomePage() should be your actual home page widget
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFEBC272),
                      minimumSize: Size(270, 60),
                    ),
                    child: Text(
                      'Go to Home',
                      style: TextStyle(fontSize: 25, color: Colors.black),
                    ),
                  ),

                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}
