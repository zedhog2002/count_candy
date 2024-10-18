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
      Uri.parse('http://127.0.0.1:8000/prediction_tables'),
      body: json.encode({'uid': globalUid}), // Pass the uid in the body
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final predictedValues = jsonResponse['predicted_values'] ?? {};

      setState(() {
        // Convert the predicted values to a list of doubles
        predictions = List<double>.from(predictedValues.values.map((value) => value.toDouble()));
      });
    } else {
      print('Failed to fetch predictions');
    }
  }


  Future<void> fetchResults() async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/result_history'),
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
      'Counting': countingResults
          .map((result) => {'average_result': result})
          .toList(),
      'Coloring': coloringResults
          .map((result) => {'average_result': result})
          .toList(),
      'Calculation': calculationResults
          .map((result) => {'average_result': result})
          .toList(),
    };
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF6F6F6),
        title: Text('Result History'),
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
      body: SingleChildScrollView(
        child: Container(
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 50, top: 16, bottom: 16),
                  child: Text(
                    'Predictions',
                    style: TextStyle(
                      fontSize: 32,
                      fontFamily: 'Assistant',
                    ),
                  ),
                ),
                if (predictions.isNotEmpty)
                  Container(
                    width: 400,
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
                    child: SfCartesianChart(
                      primaryXAxis: CategoryAxis(title: AxisTitle(text: 'Prediction')),
                      primaryYAxis: NumericAxis(title: AxisTitle(text: 'Value')),
                      series: [
                        LineSeries<double, String>(
                          dataSource: predictions,
                          xValueMapper: (prediction, index) => 'Prediction ${index + 1}',
                          yValueMapper: (prediction, _) => prediction,
                          markerSettings: MarkerSettings(
                            isVisible: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                SizedBox(height: 35),
                Text(
                  'Your results are like stepping stones in \nthe playful garden of knowledge. Keep leaping, \nlittle explorer!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Assistant',
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => IndividualQuizResultsPage(
                          quizResults: groupResultsByQuiz(),
                          quizType: 'Counting', // Passing the quiz type
                          quizTitle: 'Counting Quiz', // Passing the quiz title
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(270, 46),
                    backgroundColor: Color(0xFFEBC272),
                  ),
                  child: Text(
                    'Counting Quiz',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => IndividualQuizResultsPage(
                          quizResults: groupResultsByQuiz(),
                          quizType: 'Coloring', // Passing the quiz type
                          quizTitle: 'Coloring Quiz', // Passing the quiz title
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(270, 46),
                    backgroundColor: Color(0xFFEBC272),
                  ),
                  child: Text(
                    'Coloring Quiz',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => IndividualQuizResultsPage(
                          quizResults: groupResultsByQuiz(),
                          quizType: 'Calculation', // Passing the quiz type
                          quizTitle: 'Calculation Quiz', // Passing the quiz title
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(270, 46),
                    backgroundColor: Color(0xFFEBC272),
                  ),
                  child: Text(
                    'Calculation Quiz',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
