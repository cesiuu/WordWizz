class Question {
  final int id;
  final int languageId;
  final int levelId;
  final String questionText;
  final List<Answer> answers;

  Question({
    required this.id,
    required this.languageId,
    required this.levelId,
    required this.questionText,
    required this.answers,
  });

  factory Question.fromMap(Map<String, dynamic> map, List<Answer> answers) {
    return Question(
      id: map['question_id'],
      languageId: map['question_language'],
      levelId: map['question_level'],
      questionText: map['question_text'],
      answers: answers,
    );
  }
}

class Answer {
  final int id;
  final int questionId;
  final String answerText;
  final bool isCorrect;

  Answer({
    required this.id,
    required this.questionId,
    required this.answerText,
    required this.isCorrect,
  });

  factory Answer.fromMap(Map<String, dynamic> map) {
    return Answer(
      id: map['answer_id'],
      questionId: map['question_id'],
      answerText: map['answer_text'],
      isCorrect: map['is_correct'] == 1,
    );
  }
}
