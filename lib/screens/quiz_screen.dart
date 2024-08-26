import 'dart:math'; // For generating random numbers
import 'package:flutter/material.dart';
import 'package:wordwizz/models/quiz_model.dart'; // Assuming the Quiz model is defined here
import 'package:wordwizz/components/database_helper.dart';
import 'package:wordwizz/models/question_model.dart'; // Import your Question model

class QuizScreen extends StatefulWidget {
  final Quiz quiz;

  QuizScreen({Key? key, required this.quiz}) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late Future<bool> futureDatabaseExists;
  late Future<List<Question>> futureQuestions;

  // Track which answer is selected, current question index, and score
  Map<int, int?> selectedAnswers = {}; // Maps question ID to selected answer ID
  int currentQuestionIndex = 0;
  int score = 0; // Track correct answers
  List<Question> loadedQuestions = []; // Store loaded questions

  @override
  void initState() {
    super.initState();
    score = 0; // Reset score at the start of the quiz
    futureDatabaseExists = DatabaseHelper().checkDatabaseExists();
    futureQuestions = getQuestionsForQuiz();
  }

  // Function to read 10 random questions from a table in the database
  Future<List<Question>> getQuestionsForQuiz() async {
    try {
      final db = await DatabaseHelper().database;

      String language = widget.quiz.language.toString();
      String level = widget.quiz.level.toString();

      // Fetch 10 random questions matching the quiz language and level
      final result = await db.rawQuery(
        'SELECT * FROM TEST_QUESTIONS WHERE question_language = ? AND question_level = ? ORDER BY RANDOM() LIMIT 10',
        [language, level],
      );

      // Map results to Question objects
      List<Question> questions = [];
      for (var questionMap in result) {
        final answerMaps = await db.rawQuery(
          'SELECT * FROM TEST_ANSWERS WHERE question_id = ?',
          [questionMap['question_id']],
        );

        List<Answer> answers = answerMaps.map((map) => Answer.fromMap(map)).toList();
        Question question = Question.fromMap(questionMap, answers);
        questions.add(question);
      }

      loadedQuestions = questions; // Store loaded questions for later use
      return questions;
    } catch (e) {
      throw Exception('Error reading from database: $e');
    }
  }

  void selectAnswer(int questionId, int answerId) {
    setState(() {
      selectedAnswers[questionId] = answerId;
    });
  }

  bool isAnswerCorrect(int questionId, int selectedAnswerId) {
    // Directly find the selected answer from loaded questions
    final question = loadedQuestions.firstWhere((q) => q.id == questionId);
    final answer = question.answers.firstWhere((a) => a.id == selectedAnswerId);
    return answer.isCorrect; // Check if the selected answer is correct
  }

  void nextQuestion() {
    setState(() {
      // Check if the answer is correct before incrementing the score
      if (selectedAnswers.containsKey(loadedQuestions[currentQuestionIndex].id)) {
        int questionId = loadedQuestions[currentQuestionIndex].id;
        int? selectedAnswerId = selectedAnswers[questionId];

        if (selectedAnswerId != null && isAnswerCorrect(questionId, selectedAnswerId)) {
          score++;
        }
      }

      if (currentQuestionIndex < 9) {
        currentQuestionIndex++;
      } else {
        // Navigate to end screen when quiz is finished
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => EndScreen(score: score),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quiz.title),
      ),
      body: FutureBuilder<bool>(
        future: futureDatabaseExists,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error checking database: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data == false) {
            return Center(child: Text('Database file not found in assets.'));
          } else {
            return FutureBuilder<List<Question>>(
              future: futureQuestions,
              builder: (context, questionSnapshot) {
                if (questionSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (questionSnapshot.hasError) {
                  return Center(child: Text('Error reading database: ${questionSnapshot.error}'));
                } else if (questionSnapshot.hasData && questionSnapshot.data!.isNotEmpty) {
                  final questions = questionSnapshot.data!;
                  final question = questions[currentQuestionIndex];
                  return Card(
                    margin: EdgeInsets.all(10.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Question counter
                          Text(
                            'Question ${currentQuestionIndex + 1} of 10',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Text(
                            question.questionText,
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          ...question.answers.map((answer) {
                            bool isSelected = selectedAnswers[question.id] == answer.id;
                            bool isCorrect = answer.isCorrect;
                            Color answerColor = isSelected
                                ? (isCorrect ? Colors.green : Colors.red)
                                : Colors.black;

                            return ListTile(
                              title: Text(
                                answer.answerText,
                                style: TextStyle(color: answerColor),
                              ),
                              leading: Icon(
                                isSelected
                                    ? (isCorrect ? Icons.check_circle : Icons.cancel)
                                    : Icons.radio_button_unchecked,
                                color: isSelected ? (isCorrect ? Colors.green : Colors.red) : null,
                              ),
                              onTap: () => selectAnswer(question.id, answer.id),
                            );
                          }).toList(),
                          SizedBox(height: 10),
                          if (selectedAnswers.containsKey(question.id))
                            ElevatedButton(
                              onPressed: () => nextQuestion(),
                              child: Text('Next Question'),
                            ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Center(child: Text('No questions available for this quiz.'));
                }
              },
            );
          }
        },
      ),
    );
  }
}

class EndScreen extends StatelessWidget {
  final int score;

  EndScreen({required this.score});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Completed'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Your Score',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              '$score / 10',
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Return to previous screen
              },
              child: Text('Back to Quiz Levels'),
            ),
          ],
        ),
      ),
    );
  }
}
