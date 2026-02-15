import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../theme/app_theme.dart';
import '../services/education_service.dart';
import '../services/progress_service.dart';
import '../models/category_model.dart';
import 'lesson_screen.dart';
import 'package:hive/hive.dart';

class CategoryDetailScreen extends StatefulWidget {
  final String categoryId;
  final String title;
  final Color color;

  const CategoryDetailScreen({
    super.key,
    required this.categoryId,
    required this.title,
    required this.color,
  });

  @override
  State<CategoryDetailScreen> createState() =>
      _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  Category? category;

  @override
  void initState() {
    super.initState();
    _loadCategory();
  }

  Future<void> _loadCategory() async {
    final categories = await EducationService.loadCategories();
    setState(() {
      category =
          categories.firstWhere((c) => c.id == widget.categoryId);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (category == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final List<String> lessonIds =
    category!.lessons.map((e) => e.id).toList();

    final progress =
    ProgressService.calculateProgress(lessonIds);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: widget.color.withOpacity(0.1),
        foregroundColor: widget.color,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircularPercentIndicator(
              radius: 70,
              lineWidth: 10,
              percent: progress,
              animation: true,
              progressColor: widget.color,
              backgroundColor: widget.color.withOpacity(0.15),
              center: Text(
                "${(progress * 100).toInt()}%",
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(color: widget.color),
              ),
            ),
            const SizedBox(height: 30),

            Expanded(
              child: ListView.builder(
                itemCount: category!.lessons.length,
                itemBuilder: (context, index) {
                  final lesson = category!.lessons[index];
                  final completed =
                  ProgressService.isLessonCompleted(
                      lesson.id);

                  return ListTile(
                    contentPadding:
                    const EdgeInsets.symmetric(vertical: 6),
                    title: Text(lesson.title),
                    subtitle: Text(lesson.description),
                    trailing: Icon(
                      completed
                          ? Icons.check_circle
                          : Icons.play_circle_fill,
                      color: completed
                          ? Colors.green
                          : widget.color,
                    ),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LessonScreen(
                            lesson: lesson,
                            color: widget.color,
                            lessons: category!.lessons,
                            currentIndex: index,
                          ),
                        ),
                      );
                      setState(() {});
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
