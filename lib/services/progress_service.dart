import 'package:hive/hive.dart';

class ProgressService {
  static final _box = Hive.box('progressBox');

  static void markLessonComplete(String lessonId) {
    _box.put(lessonId, true);
  }

  static bool isLessonCompleted(String lessonId) {
    return _box.get(lessonId, defaultValue: false);
  }

  static double calculateProgress(List<String> lessonIds) {
    int completed = lessonIds
        .where((id) => _box.get(id, defaultValue: false) == true)
        .length;

    return completed / lessonIds.length;
  }
}
