import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'globals.dart';
import 'individual_quiz_result_page.dart';

class ResultHistoryPage extends StatefulWidget {
  final String? uid;

  ResultHistoryPage({required this.uid});

  @override
  _ResultHistoryPageState createState() => _ResultHistoryPageState();
}

class _ResultHistoryPageState extends State<ResultHistoryPage> {
  List<double> countingResults = [];
  List<double> coloringResults = [];
  List<double> calculationResults = [];
  List<double> predictions = [];

  @override
  void initState() {
    super.initState();
    fetchResultsAndPredictions();
  }

  Future<void> fetchResultsAndPredictions() async {
    await fetchResults();
    await fetchPredictions();
  }

  Future<void> fetchPredictions() async {
    final response = await http.post(
      Uri.parse('$apiUrl/prediction_tables'),
      body: json.encode({'uid': globalUid}),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final predictedValues = jsonResponse['predicted_values'] ?? {};

      setState(() {
        predictions = List<double>.from(predictedValues.values.map((value) => value.toDouble()));
      });
    } else {
      print('Failed to fetch predictions');
    }
  }

  Future<void> fetchResults() async {
    final response = await http.post(
      Uri.parse('$apiUrl/result_history'),
      body: json.encode({'uid': globalUid}),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      setState(() {
        countingResults = List<double>.from(jsonResponse['counting_results'].map((result) => result.toDouble()));
        coloringResults = List<double>.from(jsonResponse['coloring_results'].map((result) => result.toDouble()));
        calculationResults = List<double>.from(jsonResponse['calculation_results'].map((result) => result.toDouble()));
      });
    } else {
      print('Failed to fetch result history');
    }
  }

  Map<String, List<Map<String, dynamic>>> groupResultsByQuiz() {
    return {
      'Counting': countingResults.map((result) => {'average_result': result}).toList(),
      'Coloring': coloringResults.map((result) => {'average_result': result}).toList(),
      'Calculation': calculationResults.map((result) => {'average_result': result}).toList(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF6F6F6),
        title: Text(
          'Result History',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
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
      body: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height, // Set the minimum height to the screen height
        ),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            decoration: BoxDecoration(
              color: Color(0xFFF6F6F6),
              image: DecorationImage(
                image: AssetImage('lib/images/background.png'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.white.withOpacity(0.1),
                  BlendMode.dstATop,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 16, top: 16, bottom: 16),
                  child: Text(
                    'Predictions',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Assistant',
                    ),
                  ),
                ),
                if (predictions.isNotEmpty)
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: SfCartesianChart(
                        primaryXAxis: CategoryAxis(title: AxisTitle(text: 'Prediction')),
                        primaryYAxis: NumericAxis(title: AxisTitle(text: 'Value')),
                        series: [
                          LineSeries<double, String>(
                            dataSource: predictions,
                            xValueMapper: (prediction, index) => 'P${index + 1}',
                            yValueMapper: (prediction, _) => prediction,
                            markerSettings: MarkerSettings(
                              isVisible: true,
                              color: Colors.orange,
                            ),
                            color: Colors.orange,
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Attempt all quizzes to view predictions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                SizedBox(height: 30),
                Text(
                  'Your results are like stepping stones in \nthe playful garden of knowledge. Keep leaping, \nlittle explorer!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Assistant',
                  ),
                ),
                SizedBox(height: 25),
                _buildQuizButton(
                  context,
                  'Counting Quiz',
                  'Counting',
                  'Counting Quiz',
                ),
                SizedBox(height: 15),
                _buildQuizButton(
                  context,
                  'Coloring Quiz',
                  'Coloring',
                  'Coloring Quiz',
                ),
                SizedBox(height: 15),
                _buildQuizButton(
                  context,
                  'Calculation Quiz',
                  'Calculation',
                  'Calculation Quiz',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuizButton(
      BuildContext context,
      String buttonText,
      String quizType,
      String quizTitle,
      ) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => IndividualQuizResultsPage(
              quizResults: groupResultsByQuiz(),
              quizType: quizType,
              quizTitle: quizTitle,
            ),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        fixedSize: Size(270, 46),
        backgroundColor: Color(0xFFEBC272),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.25),
      ),
      child: Text(
        buttonText,
        style: TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
