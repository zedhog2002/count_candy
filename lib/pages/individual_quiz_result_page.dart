import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class IndividualQuizResultsPage extends StatelessWidget {
  final Map<String, List<Map<String, dynamic>>> quizResults;
  final String quizType;
  final String quizTitle;

  const IndividualQuizResultsPage({
    Key? key,
    required this.quizResults,
    required this.quizType,
    required this.quizTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Fetch results for the selected quiz type, use original order for graph
    final resultsForQuiz = quizResults[quizType] ?? [];
    final totalAttempts = resultsForQuiz.length; // Track the total number of attempts

    return Scaffold(
      appBar: AppBar(
        title: Text('$quizTitle Results', style: TextStyle(color: Colors.black)),
        backgroundColor: Color(0xFFF6F6F6),
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
              child: Text(
                '$quizTitle Results Overview',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            // Graph showing average scores for the selected quiz
            Container(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(
                  title: AxisTitle(text: 'Attempt'),
                  labelStyle: TextStyle(fontSize: 12),
                ),
                primaryYAxis: NumericAxis(
                  title: AxisTitle(text: 'Average Score'),
                  labelStyle: TextStyle(fontSize: 12),
                ),
                series: [
                  LineSeries<Map<String, dynamic>, int>(
                    dataSource: resultsForQuiz, // Use original order for graph
                    xValueMapper: (result, index) => index + 1, // Oldest to newest, left to right
                    yValueMapper: (result, _) => result['average_result'],
                    name: '$quizTitle',
                    markerSettings: MarkerSettings(
                      isVisible: true,
                      color: Colors.orange,
                      borderColor: Colors.white,
                    ),
                    color: Colors.orange,
                  ),
                ],
              ),
            ),
            SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Attempts Breakdown',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(height: 10),
            // Make only the attempts scrollable and the graph stationery
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView.builder(
                  itemCount: resultsForQuiz.reversed.length, // Reverse for ListView
                  itemBuilder: (context, index) {
                    final result = resultsForQuiz.reversed.toList()[index]; // Reversed for attempts list
                    final attemptNumber = totalAttempts - index; // Correct attempt number
                    return Container(
                      margin: EdgeInsets.only(bottom: 15),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Color(0xFF373737),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Attempt $attemptNumber',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              SizedBox(width: 15),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Color(0xFFF8E191),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Avg. Score: ${result['average_result']}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
