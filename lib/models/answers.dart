import 'package:flutter/material.dart';

Map<String, List<double>> userAnswers = {
  'counting': [],
  'coloring': [],
  'calculate':[]
};

Map<String, List<double>> generatedUserAnswer = {
  'counting': [],
  'coloring': [],
  'calculation': []
};


final List<double> generated_answer_counting = [0.0, 0.0, 0.0];
final List<double> generated_answer_coloring = [0.0, 0.0, 0.0];
final List<double> generated_answer_calculation = [0.0, 0.0, 0.0];