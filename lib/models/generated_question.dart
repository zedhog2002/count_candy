class GeneratedQuestion {

  final String question_quiznumber; // Determines the type of question
  final Map<String, dynamic> data; // Flexible data container

  GeneratedQuestion({required this.question_quiznumber, required this.data});

  factory GeneratedQuestion.fromJson(Map<String, dynamic> json) {
    return GeneratedQuestion(
      question_quiznumber: json['question_quiznumber'],
      data: json,
    );
  }
}
