class PredictionResponse {
  final String label;
  final double confidence;
  final String sentence;

  PredictionResponse({
    required this.label,
    required this.confidence,
    required this.sentence,
  });

  factory PredictionResponse.fromJson(Map<String, dynamic> json) {
    return PredictionResponse(
      label: json['label'],
      confidence: json['confidence'].toDouble(),
      sentence: json['sentence'],
    );
  }
}