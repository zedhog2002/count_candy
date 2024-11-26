class GeneratedQuestion {
  final String quiz_type;
  final String question_quiznumber; // Determines the type of question
  final Map<String, dynamic> data; // Flexible data container

  GeneratedQuestion({required this.quiz_type ,required this.question_quiznumber, required this.data});

  factory GeneratedQuestion.fromJson(Map<String, dynamic> json) {
    return GeneratedQuestion(
      quiz_type: json['quiz_type'],
      question_quiznumber: json['question_quiznumber'],
      data: json,
    );
  }
}
