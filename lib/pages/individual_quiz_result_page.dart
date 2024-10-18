import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class IndividualQuizResultsPage extends StatelessWidget {
  final Map<String, List<Map<String, dynamic>>> quizResults;
  final String quizType;
  final String quizTitle;

  const IndividualQuizResultsPage({
    Key? key,
    required this.quizResults,
    required this.quizType, // The key for the specific quiz (Counting, Coloring, Calculation)
    required this.quizTitle, // The title for the quiz (e.g., Counting Quiz)
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Fetch results for the selected quiz type
    final resultsForQuiz = quizResults[quizType] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text('$quizTitle Results'),
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
                  '$quizTitle',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Graph showing average scores for the selected quiz
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
                      name: '$quizTitle',
                      markerSettings: MarkerSettings(
                        isVisible: true,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25),
              // List of each attempt showing the average result
              Container(
                width: 286,
                height: MediaQuery.of(context).size.height - 252 - 70 - AppBar().preferredSize.height,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: resultsForQuiz.length,
                  itemBuilder: (context, index) {
                    final result = resultsForQuiz[index];
                    return Container(
                      margin: EdgeInsets.only(bottom: 10),
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

                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
