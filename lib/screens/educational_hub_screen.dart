// lib/screens/educational_hub_screen.dart
// ISL Connect – Educational Hub Screen
//
// Displays a 2-column grid of ISL sign categories.
// Each card has a custom SVG icon, title, and color coding.
// Staggered fade-in animation: each card enters with a delay based on position.

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:isl_deep_blue/screens/category_detail_screen.dart';
import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';

// ── Data model for a sign category ──────────────────────────────────────────
class SignCategory {
  final String title;
  final String imageAsset;
  final Color color;
  final String description;
  final String route;

  const SignCategory({
    required this.title,
    required this.imageAsset,
    required this.color,
    required this.description,
    required this.route,
  });
}

class EducationalHubScreen extends StatefulWidget {
  const EducationalHubScreen({super.key});

  @override
  State<EducationalHubScreen> createState() => _EducationalHubScreenState();
}

class _EducationalHubScreenState extends State<EducationalHubScreen>
    with SingleTickerProviderStateMixin {
  // ── Category data ─────────────────────────────────────────────────────────
  static const List<SignCategory> _categories = [
    SignCategory(
      title: 'Alphabets',
      imageAsset: 'assets/images/c1-removebg-preview.png',
      color: AppColors.categoryAlphabet,
      description: 'A to Z hand signs',
      route: '/lessons/alphabets',
    ),
    SignCategory(
      title: 'Numbers',
      imageAsset: 'assets/images/c2-removebg-preview.png',
      color: AppColors.categoryNumbers,
      description: '0 to 100 signs',
      route: '/lessons/numbers',
    ),
    SignCategory(
      title: 'Daily Actions',
      imageAsset: 'assets/images/c3-removebg-preview.png',
      color: AppColors.categoryActions,
      description: 'Eat, drink, go & more',
      route: '/lessons/daily_actions',
    ),
    SignCategory(
      title: 'Emotions',
      imageAsset: 'assets/images/c4-removebg-preview.png',
      color: AppColors.categoryEmotions,
      description: 'Happy, sad, angry...',
      route: '/lessons/emotions',
    ),
    SignCategory(
      title: 'Emergency',
      imageAsset: 'assets/images/c5-removebg-preview.png',
      color: AppColors.categoryEmergency,
      description: 'Help, danger, stop',
      route: '/lessons/emergency',
    ),
    SignCategory(
      title: 'Greetings',
      imageAsset: 'assets/images/c6-removebg-preview.png',
      color: AppColors.categoryGreetings,
      description: 'Hello, thanks, bye',
      route: '/lessons/greetings',
    ),
  ];

  // Tracks which cards have entered the viewport for stagger
  final List<bool> _visible = List.filled(6, false);

  @override
  void initState() {
    super.initState();
    _triggerStaggeredEntrance();
  }

  // ── Trigger staggered entrance: each card with 90ms gap ──────────────────
  void _triggerStaggeredEntrance() {
    for (int i = 0; i < _categories.length; i++) {
      Future.delayed(Duration(milliseconds: 120 + (i * 90)), () {
        if (mounted) {
          setState(() => _visible[i] = true);
        }
      });
    }
  }

  // void _navigateToLesson(SignCategory category) {
  //   // Placeholder: navigate to lesson screen when backend is ready
  //   Navigator.of(context).pushNamed(
  //     category.route,
  //     arguments: {'title': category.title, 'color': category.color},
  //   );
  // }
  void _navigateToLesson(SignCategory category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CategoryDetailScreen(
          categoryId: category.title.toLowerCase().replaceAll(' ', '_'),
          title: category.title,
          color: category.color,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Sticky header ─────────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.background,
            expandedHeight: 90,
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const <StretchMode>[
                StretchMode.fadeTitle,     // Fades the title as it collapses/stretches
                StretchMode.blurBackground, // Optional: blurs the background
              ],
              background: _buildHeader(context),
            ),
            // bottom: PreferredSize(
            //   preferredSize: const Size.fromHeight(56),
            //   child: _buildSearchBar(context),
            // ),
          ),

          // ── Grid ─────────────────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.92,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final category = _categories[index];
                  return AnimatedOpacity(
                    duration: const Duration(milliseconds: 450),
                    opacity: _visible[index] ? 1.0 : 0.0,
                    curve: Curves.easeOut,
                    child: AnimatedSlide(
                      duration: const Duration(milliseconds: 450),
                      offset: _visible[index]
                          ? Offset.zero
                          : const Offset(0, 0.15),
                      curve: Curves.easeOutCubic,
                      child: CategoryCard(
                        title: category.title,
                        imageAsset: category.imageAsset,
                        color: category.color,
                        onTap: () => _navigateToLesson(category),
                      ),
                    ),
                  );
                },
                childCount: _categories.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Header section ────────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      alignment: Alignment.bottomLeft,
      decoration: BoxDecoration(
        color: AppColors.background,
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.school_rounded,
                    color: AppColors.primary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Educational Hub',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Text(
                      '${_categories.length} categories to explore',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Search/Filter bar ─────────────────────────────────────────────────────
  // Widget _buildSearchBar(BuildContext context) {
  //   return Container(
  //     height: 56,
  //     color: AppColors.background,
  //     padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
  //     child: TextField(
  //       style: Theme.of(context).textTheme.bodyLarge?.copyWith(
  //         color: AppColors.textPrimary,
  //       ),
  //       decoration: InputDecoration(
  //         hintText: 'Search sign categories…',
  //         prefixIcon: const Icon(
  //           Icons.search_rounded,
  //           color: AppColors.textSecondary,
  //           size: 20,
  //         ),
  //         contentPadding: const EdgeInsets.symmetric(vertical: 10),
  //         isDense: true,
  //       ),
  //     ),
  //   );
  // }
}

// ─────────────────────────────────────────────────────────────────────────────
/// Placeholder Lesson Screen – shown when a category card is tapped
/// until backend lesson content is integrated.
// ─────────────────────────────────────────────────────────────────────────────
class LessonPlaceholderScreen extends StatelessWidget {
  final String title;
  final Color color;

  const LessonPlaceholderScreen({
    super.key,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: color.withOpacity(0.1),
        foregroundColor: color,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
          tooltip: 'Go back',
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.construction_rounded,
                color: color,
                size: 48,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '$title Lessons',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: color,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Coming soon! Lesson content\nwill appear here.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
