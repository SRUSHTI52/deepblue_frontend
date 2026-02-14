import 'lesson_model.dart';


class Category {
  final String id;
  final String title;
  final String description;
  final List<Lesson> lessons;

  Category({
    required this.id,
    required this.title,
    required this.description,
    required this.lessons,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      lessons: (json['lessons'] as List)
          .map((e) => Lesson.fromJson(e))
          .toList(),
    );
  }
}