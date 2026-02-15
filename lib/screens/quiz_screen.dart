import 'package:flutter/material.dart';

class QuizScreen extends StatefulWidget {
  final String categoryId;

  const QuizScreen({super.key, required this.categoryId});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int score = 0;

  List<Map<String, dynamic>> questions = [
    {
      "question": "What is ISL sign for Hello?",
      "options": ["Hand wave", "Clap", "Jump"],
      "answer": 0
    },
    {
      "question": "ISL is used for?",
      "options": ["Cooking", "Communication", "Driving"],
      "answer": 1
    },
  ];

  int currentQuestion = 0;

  void checkAnswer(int index) {
    if (index == questions[currentQuestion]["answer"]) {
      score++;
    }

    if (currentQuestion < questions.length - 1) {
      setState(() => currentQuestion++);
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Quiz Completed"),
          content: Text("Your score: $score / ${questions.length}"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var q = questions[currentQuestion];

    return Scaffold(
      appBar: AppBar(title: const Text("Quiz")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(q["question"], style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            ...List.generate(
              q["options"].length,
                  (index) => ElevatedButton(
                onPressed: () => checkAnswer(index),
                child: Text(q["options"][index]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
