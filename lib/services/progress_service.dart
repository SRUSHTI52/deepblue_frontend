import 'package:hive/hive.dart';

class ProgressService {
  static final Box _box = Hive.box('progressBox');

  static void markLessonComplete(String lessonId) {
    _box.put(lessonId, true);
  }

  static bool isLessonCompleted(String lessonId) {
    return _box.get(lessonId, defaultValue: false);
  }

  static double calculateProgress(List<String> lessonIds) {
    if (lessonIds.isEmpty) return 0;

    int completed = 0;

    for (var id in lessonIds) {
      if (isLessonCompleted(id)) {
        completed++;
      }
    }

    return completed / lessonIds.length;
  }
}
