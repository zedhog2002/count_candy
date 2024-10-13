import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:untitled1/pages/counting_quiz_history_page.dart';

class ResultHistoryPage extends StatefulWidget {
  final String uid;

  ResultHistoryPage({required this.uid});

  @override
  _ResultHistoryPageState createState() => _ResultHistoryPageState();
}

class _ResultHistoryPageState extends State<ResultHistoryPage> {
  List<Map<String, dynamic>> results = [];
  List<Map<String, dynamic>> predictions = [];

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
    final response = await http.get(
      Uri.parse('https://flask-dyscalculia.onrender.com/prediction_table/${widget.uid}'),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse.containsKey('predictions')) {
        if (mounted) {
          setState(() {
            predictions = List<Map<String, dynamic>>.from(jsonResponse['predictions']);
            print(predictions);
          });
        }
      } else {
        print('Prediction key not found in the response');
      }
    } else {
      print('Failed to fetch predictions');
    }
  }

  Future<void> fetchResults() async {
    final response = await http.get(
      Uri.parse('https://flask-dyscalculia.onrender.com/result_history/${widget.uid}'),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse.containsKey('results')) {
        if (mounted) {
          setState(() {
            results = List<Map<String, dynamic>>.from(jsonResponse['results']);
            print(results);
          });
        }
      } else {
        print('Results key not found in the response');
      }
    } else {
      print('Failed to fetch result history');
    }
  }

  Map<String, List<Map<String, dynamic>>> groupResultsByQuiz() {
    Map<String, List<Map<String, dynamic>>> groupedResults = {};

    for (var result in results) {
      final quizId = result['quiz_id'].toString();
      if (!groupedResults.containsKey(quizId)) {
        groupedResults[quizId] = [];
      }
      groupedResults[quizId]!.add(result);
    }

    // Log the grouped results to the console
    print('Grouped Results: $groupedResults');

    return groupedResults;
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
      body: Container(
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
                      LineSeries<Map<String, dynamic>, String>(
                        dataSource: predictions,
                        xValueMapper: (prediction, _) => 'Prediction ${predictions.indexOf(prediction) + 1}',
                        yValueMapper: (prediction, _) => prediction['predicted_values'],
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
              // Display results in a ListView
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CountResultsPage(
                        quizResults: groupResultsByQuiz(),
                        id: 2,
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
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CountResultsPage(
                        quizResults: groupResultsByQuiz(),
                        id: 1,
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
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CountResultsPage(
                        quizResults: groupResultsByQuiz(),
                        id: 3,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(270, 46),
                  backgroundColor: Color(0xFFEBC272),
                ),
                child: Text(
                  'Calculating Quiz',
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
    );
  }
}
