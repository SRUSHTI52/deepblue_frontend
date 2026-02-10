import 'package:flutter/material.dart';
import '../models/prediction_response.dart';

class ResultScreen extends StatelessWidget {
  final PredictionResponse result;

  const ResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Prediction Result")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Predicted Sign:",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              result.label,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text("Confidence: ${(result.confidence * 100).toStringAsFixed(2)}%"),
            const SizedBox(height: 20),
            const Text("Generated Sentence:"),
            const SizedBox(height: 8),
            Text(
              result.sentence,
              style: const TextStyle(fontSize: 18),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: const Text("Record Again"),
              ),
            )
          ],
        ),
      ),
    );
  }
}