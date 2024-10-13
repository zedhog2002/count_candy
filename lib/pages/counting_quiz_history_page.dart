import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CountResultsPage extends StatelessWidget {
  final Map<String, List<Map<String, dynamic>>> quizResults;
  final int id;

  const CountResultsPage({
    Key? key,
    required this.quizResults,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Filter out the results for the specific quiz ID
    final resultsForQuiz = quizResults[id.toString()] ?? []; // Ensure id is converted to string

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Results'),
        backgroundColor: Color(0xFFF6F6F6),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Counting Quiz',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Chart for quiz results
              Container(
                height: 252,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(title: AxisTitle(text: 'Attempt')),
                  primaryYAxis: NumericAxis(title: AxisTitle(text: 'Average Score')),
                  series: [
                    LineSeries<Map<String, dynamic>, int>(
                      dataSource: resultsForQuiz,
                      xValueMapper: (result, index) => index + 1,
                      yValueMapper: (result, _) => result['average_result'],
                      name: 'Counting Quiz',
                      markerSettings: MarkerSettings(
                        isVisible: true,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25),
              // ListView for individual attempts
              Container(
                width: 286,
                height: MediaQuery.of(context).size.height - 252 - 70 - AppBar().preferredSize.height,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(), // Disable scrolling in ListView
                  itemCount: resultsForQuiz.length,
                  itemBuilder: (context, index) {
                    final result = resultsForQuiz[index];
                    return Container(
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 15,
                            left: 10,
                            child: Container(
                              height: 20,
                              width: 95,
                              decoration: BoxDecoration(
                                color: Color(0xFF373737),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                child: Text(
                                  'Attempt ${index + 1}',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 15,
                            left: 150,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0xFFF8E191),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Average Result:\n ${result['average_result']}',
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 45,
                            left: 10,
                            child: Text(
                              "Date: ${result['date'] ?? 'N/A'}\nTime: ${result['time'] ?? 'N/A'}",
                            ), // Display date and time if available
                          ),
                        ],
                      ));
                    }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
