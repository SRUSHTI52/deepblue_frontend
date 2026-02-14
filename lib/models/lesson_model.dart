class Lesson {
  final String id;
  final String title;
  final String description;
  final List<String> images;
  final List<String> videos;

  Lesson({
    required this.id,
    required this.title,
    required this.description,
    required this.images,
    required this.videos,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      images: List<String>.from(json['images'] ?? []),
      videos: List<String>.from(json['videos'] ?? []),
    );
  }
}
