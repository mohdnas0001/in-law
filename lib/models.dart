import 'dart:convert';

class Question {
  final String text;
  final int weight;
  Question({required this.text, this.weight = 1});
  Map<String, dynamic> toJson() => {'text': text, 'weight': weight};
}

class TestResult {
  final String id;
  final String partnerName;
  final DateTime date;
  final int score;
  final int maxScore;
  final List<int> answers;

  TestResult({
    required this.id,
    required this.partnerName,
    required this.date,
    required this.score,
    required this.maxScore,
    required this.answers,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'partnerName': partnerName,
        'date': date.toIso8601String(),
        'score': score,
        'maxScore': maxScore,
        'answers': answers,
      };

  static TestResult fromJson(Map<String, dynamic> j) => TestResult(
        id: j['id'],
        partnerName: j['partnerName'],
        date: DateTime.parse(j['date']),
        score: j['score'],
        maxScore: j['maxScore'],
        answers: List<int>.from(j['answers'] ?? List.filled(10, 2)),
      );
}