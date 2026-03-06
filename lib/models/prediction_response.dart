class PredictionResponse {
  final String label;
  final double confidence;
  final List<List<double>> landmarks; // ← NEW: (30, 426) from predict API

  PredictionResponse({
    required this.label,
    required this.confidence,
    required this.landmarks, // ← NEW
  });

  factory PredictionResponse.fromJson(Map<String, dynamic> json) {
    return PredictionResponse(
      label:      json['label'],
      confidence: json['confidence'].toDouble(),
      // ← NEW: parse landmarks list from API response
      landmarks: (json['landmarks'] as List)
          .map((row) => (row as List)
          .map((val) => (val as num).toDouble())
          .toList())
          .toList(),
    );
  }
}


// class PredictionResponse {
//   final String label;
//   final double confidence;
//   // final String sentence;
//
//   PredictionResponse({
//     required this.label,
//     required this.confidence,
//     // required this.sentence,
//   });
//
//   factory PredictionResponse.fromJson(Map<String, dynamic> json) {
//     return PredictionResponse(
//       label: json['label'],
//       confidence: json['confidence'].toDouble(),
//       // sentence: json['sentence'],
//     );
//   }
// }