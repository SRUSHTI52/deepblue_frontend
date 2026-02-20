import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class RecentSignsScreen extends StatelessWidget {
  const RecentSignsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔹 Dummy Data (Replace later with real model history)
    final List<Map<String, dynamic>> recentPredictions = [
      {"word": "Happy", "score": 0.94},
      {"word": "Healthy", "score": 0.90},
      {"word": "Sick", "score": 0.86},
      {"word": "Sad", "score": 0.82},
      {"word": "Angry", "score": 0.78},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
        title: const Text(
          "Recent Signs",
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: recentPredictions.length,
        itemBuilder: (context, index) {
          final item = recentPredictions[index];
          final scorePercent = (item["score"] * 100).toInt();

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                // 🔹 Word Icon Circle
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.pan_tool_alt_rounded,
                    color: AppColors.primary,
                  ),
                ),

                const SizedBox(width: 16),

                // 🔹 Word + Score
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item["word"],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),

                      // 🔹 Confidence bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: item["score"],
                          minHeight: 6,
                          backgroundColor:
                          AppColors.primary.withOpacity(0.1),
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // 🔹 Percentage Text
                Text(
                  "$scorePercent%",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}