// lib/screens/educational_hub_screen.dart
// ISL Connect – Educational Hub Screen
//
// Layout (top → bottom):
//   1. SliverAppBar  — collapsible header
//   2. _AvatarBanner — "Learn with 3D Avatar" hero strip  ← NEW
//   3. Section label — "Sign Categories"
//   4. 2-column grid — category cards (image-based, staggered entrance)
//
// Navigation:
//   • Category card tap  → CategoryDetailScreen (your existing screen)
//   • Avatar banner tap  → AvatarViewerScreen ('/avatar', category: actions)
//   • Quick-launch chips → '/avatar' with deep-link category + sign args

import 'package:flutter/material.dart';
import 'package:isl_deep_blue/screens/category_detail_screen.dart';
import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';

// ── Data model for a sign category ───────────────────────────────────────────
class SignCategory {
  final String title;
  final String imageAsset;
  final Color color;
  final String description;
  final String route;

  // Maps this category to the avatar viewer's tab id
  String get avatarCategory {
    switch (title.toLowerCase()) {
      case 'alphabets': return 'alpha';
      case 'numbers':   return 'nums';
      default:          return 'actions';
    }
  }

  const SignCategory({
    required this.title,
    required this.imageAsset,
    required this.color,
    required this.description,
    required this.route,
  });
}

// ─────────────────────────────────────────────────────────────────────────────

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

  final List<bool> _visible = List.filled(6, false);
  bool _bannerVisible = false;

  @override
  void initState() {
    super.initState();
    _triggerEntrances();
  }

  void _triggerEntrances() {
    // Banner appears first
    Future.delayed(const Duration(milliseconds: 80), () {
      if (mounted) setState(() => _bannerVisible = true);
    });
    // Grid cards stagger after banner
    for (int i = 0; i < _categories.length; i++) {
      Future.delayed(Duration(milliseconds: 220 + (i * 90)), () {
        if (mounted) setState(() => _visible[i] = true);
      });
    }
  }

  // ── Navigate to your existing CategoryDetailScreen ───────────────────────
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

  // ── Navigate to AvatarViewerScreen via named route ───────────────────────
  void _openAvatar({String category = 'actions', String? sign}) {
    Navigator.of(context).pushNamed(
      '/avatar',
      arguments: <String, dynamic>{
        'category': category,
        if (sign != null) 'sign': sign,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Collapsible header ────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.background,
            expandedHeight: 90,
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [
                StretchMode.fadeTitle,
                StretchMode.blurBackground,
              ],
              background: _buildHeader(context),
            ),
          ),

          // ── Body content as a single SliverList ───────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
            sliver: SliverList(
              delegate: SliverChildListDelegate([

                // ── 3D Avatar Banner ──────────────────────────────────────────
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: _bannerVisible ? 1.0 : 0.0,
                  child: AnimatedSlide(
                    duration: const Duration(milliseconds: 500),
                    offset: _bannerVisible
                        ? Offset.zero
                        : const Offset(0, 0.12),
                    curve: Curves.easeOutCubic,
                    child: _AvatarBanner(onOpen: _openAvatar),
                  ),
                ),

                const SizedBox(height: 24),

                // ── "Sign Categories" section label ───────────────────────────
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 400),
                  opacity: _bannerVisible ? 1.0 : 0.0,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Row(
                      children: [
                        // Accent bar
                        Container(
                          width: 4, height: 18,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColors.primary, AppColors.accent],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Sign Categories',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${_categories.length} topics',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),

                // ── 2-column category grid ────────────────────────────────────
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.92,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
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
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      alignment: Alignment.bottomLeft,
      color: AppColors.background,
      child: SafeArea(
        child: Row(
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
              mainAxisSize: MainAxisSize.min,
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
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
/// _AvatarBanner
///
/// Full-width hero card promoting the 3D ISL avatar viewer.
/// Dark gradient (#0D0820 → #1A0A3D → #0A2030) mirrors the Three.js viewer
/// background exactly so the UI transition feels native.
///
/// Includes:
///   • Floating 🤟 emoji with up/down animation
///   • "NEW" gradient pill
///   • Headline + description
///   • "Open 3D Viewer" primary CTA
///   • Quick-launch chips: Greetings · A–Z · 0–9
// ─────────────────────────────────────────────────────────────────────────────
class _AvatarBanner extends StatefulWidget {
  final void Function({String category, String? sign}) onOpen;
  const _AvatarBanner({required this.onOpen});

  @override
  State<_AvatarBanner> createState() => _AvatarBannerState();
}

class _AvatarBannerState extends State<_AvatarBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _floatCtrl;
  late Animation<double> _floatAnim;

  @override
  void initState() {
    super.initState();
    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);
    _floatAnim = Tween<double>(begin: -5.0, end: 5.0).animate(
      CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _floatCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Learn Indian Sign Language with 3D Avatar. Tap to open viewer.',
      button: true,
      child: TapScaleWidget(
        scaleTo: 0.98,
        onTap: () => widget.onOpen(category: 'actions'),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF0D0820), // viewer --bg
                Color(0xFF1A0A3D), // mid violet-dark
                Color(0xFF0A2030), // teal-tinted dark
              ],
              stops: [0.0, 0.55, 1.0],
            ),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.2),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: AppColors.accent.withOpacity(0.1),
                blurRadius: 40,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Subtle grid overlay (matches Three.js CSS grid)
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: CustomPaint(painter: _GridPatternPainter()),
                ),
              ),

              // Glow orbs
              Positioned(
                right: -16, top: -16,
                child: Container(
                  width: 90, height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withOpacity(0.12),
                  ),
                ),
              ),
              Positioned(
                right: 55, bottom: -8,
                child: Container(
                  width: 55, height: 55,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.accent.withOpacity(0.09),
                  ),
                ),
              ),

              // Main content
              Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // ── NEW badge + floating emoji ────────────────────────
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColors.primary, AppColors.accent],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            '✦  NEW',
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                        const Spacer(),
                        // Floating 3D emoji
                        AnimatedBuilder(
                          animation: _floatAnim,
                          builder: (_, __) => Transform.translate(
                            offset: Offset(0, _floatAnim.value),
                            child: Container(
                              width: 62, height: 62,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.15),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.primaryLight.withOpacity(0.3),
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withOpacity(0.3),
                                    blurRadius: 18,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Text('🤟',
                                    style: TextStyle(fontSize: 28)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // ── Headline ──────────────────────────────────────────
                    const Text(
                      'Learn with\n3D Avatar',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -0.5,
                        height: 1.15,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // ── Description ───────────────────────────────────────
                    Text(
                      'Watch an animated avatar perform every ISL sign in 3D. Rotate, zoom & control playback speed.',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(0.55),
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 18),

                    // ── Primary CTA ───────────────────────────────────────
                    TapScaleWidget(
                      onTap: () => widget.onOpen(category: 'actions'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 13),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.primary, AppColors.accent],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.4),
                              blurRadius: 16,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.view_in_ar_rounded,
                                color: Colors.white, size: 18),
                            SizedBox(width: 8),
                            Text(
                              'Open 3D Viewer',
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward_rounded,
                                color: Colors.white, size: 16),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ── Quick-launch chips ────────────────────────────────
                    Row(
                      children: [
                        Text(
                          'Jump to: ',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withOpacity(0.4),
                          ),
                        ),
                        const SizedBox(width: 4),
                        _QuickChip(
                          label: 'Greetings',
                          emoji: '👋',
                          color: AppColors.categoryGreetings,
                          onTap: () => widget.onOpen(
                            category: 'actions',
                            sign: 'Hello',
                          ),
                        ),
                        const SizedBox(width: 6),
                        _QuickChip(
                          label: 'A–Z',
                          emoji: '🤚',
                          color: AppColors.categoryAlphabet,
                          onTap: () => widget.onOpen(category: 'alpha'),
                        ),
                        const SizedBox(width: 6),
                        _QuickChip(
                          label: '0–9',
                          emoji: '☝️',
                          color: AppColors.categoryNumbers,
                          onTap: () => widget.onOpen(category: 'nums'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Quick-launch chip ─────────────────────────────────────────────────────────
class _QuickChip extends StatelessWidget {
  final String label;
  final String emoji;
  final Color color;
  final VoidCallback onTap;

  const _QuickChip({
    required this.label,
    required this.emoji,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TapScaleWidget(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 12)),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Subtle grid pattern — mirrors Three.js CSS grid overlay ───────────────────
class _GridPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withOpacity(0.05)
      ..strokeWidth = 0.8;
    const step = 32.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
/// LessonPlaceholderScreen — fallback for named routes until lessons are ready
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
              width: 100, height: 100,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.construction_rounded, color: color, size: 48),
            ),
            const SizedBox(height: 24),
            Text(
              '$title Lessons',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(color: color),
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

// // lib/screens/educational_hub_screen.dart
// // ISL Connect – Educational Hub Screen
// //
// // Displays a 2-column grid of ISL sign categories.
// // Each card has a custom SVG icon, title, and color coding.
// // Staggered fade-in animation: each card enters with a delay based on position.
//
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:isl_deep_blue/screens/category_detail_screen.dart';
// import '../theme/app_theme.dart';
// import '../widgets/app_widgets.dart';
//
// // ── Data model for a sign category ──────────────────────────────────────────
// class SignCategory {
//   final String title;
//   final String imageAsset;
//   final Color color;
//   final String description;
//   final String route;
//
//   const SignCategory({
//     required this.title,
//     required this.imageAsset,
//     required this.color,
//     required this.description,
//     required this.route,
//   });
// }
//
// class EducationalHubScreen extends StatefulWidget {
//   const EducationalHubScreen({super.key});
//
//   @override
//   State<EducationalHubScreen> createState() => _EducationalHubScreenState();
// }
//
// class _EducationalHubScreenState extends State<EducationalHubScreen>
//     with SingleTickerProviderStateMixin {
//   // ── Category data ─────────────────────────────────────────────────────────
//   static const List<SignCategory> _categories = [
//     SignCategory(
//       title: 'Alphabets',
//       imageAsset: 'assets/images/c1-removebg-preview.png',
//       color: AppColors.categoryAlphabet,
//       description: 'A to Z hand signs',
//       route: '/lessons/alphabets',
//     ),
//     SignCategory(
//       title: 'Numbers',
//       imageAsset: 'assets/images/c2-removebg-preview.png',
//       color: AppColors.categoryNumbers,
//       description: '0 to 100 signs',
//       route: '/lessons/numbers',
//     ),
//     SignCategory(
//       title: 'Daily Actions',
//       imageAsset: 'assets/images/c3-removebg-preview.png',
//       color: AppColors.categoryActions,
//       description: 'Eat, drink, go & more',
//       route: '/lessons/daily_actions',
//     ),
//     SignCategory(
//       title: 'Emotions',
//       imageAsset: 'assets/images/c4-removebg-preview.png',
//       color: AppColors.categoryEmotions,
//       description: 'Happy, sad, angry...',
//       route: '/lessons/emotions',
//     ),
//     SignCategory(
//       title: 'Emergency',
//       imageAsset: 'assets/images/c5-removebg-preview.png',
//       color: AppColors.categoryEmergency,
//       description: 'Help, danger, stop',
//       route: '/lessons/emergency',
//     ),
//     SignCategory(
//       title: 'Greetings',
//       imageAsset: 'assets/images/c6-removebg-preview.png',
//       color: AppColors.categoryGreetings,
//       description: 'Hello, thanks, bye',
//       route: '/lessons/greetings',
//     ),
//   ];
//
//   // Tracks which cards have entered the viewport for stagger
//   final List<bool> _visible = List.filled(6, false);
//
//   @override
//   void initState() {
//     super.initState();
//     _triggerStaggeredEntrance();
//   }
//
//   // ── Trigger staggered entrance: each card with 90ms gap ──────────────────
//   void _triggerStaggeredEntrance() {
//     for (int i = 0; i < _categories.length; i++) {
//       Future.delayed(Duration(milliseconds: 120 + (i * 90)), () {
//         if (mounted) {
//           setState(() => _visible[i] = true);
//         }
//       });
//     }
//   }
//
//   // void _navigateToLesson(SignCategory category) {
//   //   // Placeholder: navigate to lesson screen when backend is ready
//   //   Navigator.of(context).pushNamed(
//   //     category.route,
//   //     arguments: {'title': category.title, 'color': category.color},
//   //   );
//   // }
//   void _navigateToLesson(SignCategory category) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => CategoryDetailScreen(
//           categoryId: category.title.toLowerCase().replaceAll(' ', '_'),
//           title: category.title,
//           color: category.color,
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       body: CustomScrollView(
//         physics: const BouncingScrollPhysics(),
//         slivers: [
//           // ── Sticky header ─────────────────────────────────────────────────
//           SliverAppBar(
//             pinned: true,
//             backgroundColor: AppColors.background,
//             expandedHeight: 90,
//             flexibleSpace: FlexibleSpaceBar(
//               stretchModes: const <StretchMode>[
//                 StretchMode.fadeTitle,     // Fades the title as it collapses/stretches
//                 StretchMode.blurBackground, // Optional: blurs the background
//               ],
//               background: _buildHeader(context),
//             ),
//             // bottom: PreferredSize(
//             //   preferredSize: const Size.fromHeight(56),
//             //   child: _buildSearchBar(context),
//             // ),
//           ),
//
//           // ── Grid ─────────────────────────────────────────────────────────
//           SliverPadding(
//             padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
//             sliver: SliverGrid(
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 childAspectRatio: 0.92,
//                 crossAxisSpacing: 16,
//                 mainAxisSpacing: 16,
//               ),
//               delegate: SliverChildBuilderDelegate(
//                 (context, index) {
//                   final category = _categories[index];
//                   return AnimatedOpacity(
//                     duration: const Duration(milliseconds: 450),
//                     opacity: _visible[index] ? 1.0 : 0.0,
//                     curve: Curves.easeOut,
//                     child: AnimatedSlide(
//                       duration: const Duration(milliseconds: 450),
//                       offset: _visible[index]
//                           ? Offset.zero
//                           : const Offset(0, 0.15),
//                       curve: Curves.easeOutCubic,
//                       child: CategoryCard(
//                         title: category.title,
//                         imageAsset: category.imageAsset,
//                         color: category.color,
//                         onTap: () => _navigateToLesson(category),
//                       ),
//                     ),
//                   );
//                 },
//                 childCount: _categories.length,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ── Header section ────────────────────────────────────────────────────────
//   Widget _buildHeader(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
//       alignment: Alignment.bottomLeft,
//       decoration: BoxDecoration(
//         color: AppColors.background,
//       ),
//       child: SafeArea(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.end,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: AppColors.primary.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: const Icon(
//                     Icons.school_rounded,
//                     color: AppColors.primary,
//                     size: 22,
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Educational Hub',
//                       style: Theme.of(context).textTheme.headlineSmall,
//                     ),
//                     Text(
//                       '${_categories.length} categories to explore',
//                       style: Theme.of(context).textTheme.bodySmall,
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // ── Search/Filter bar ─────────────────────────────────────────────────────
//   // Widget _buildSearchBar(BuildContext context) {
//   //   return Container(
//   //     height: 56,
//   //     color: AppColors.background,
//   //     padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
//   //     child: TextField(
//   //       style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//   //         color: AppColors.textPrimary,
//   //       ),
//   //       decoration: InputDecoration(
//   //         hintText: 'Search sign categories…',
//   //         prefixIcon: const Icon(
//   //           Icons.search_rounded,
//   //           color: AppColors.textSecondary,
//   //           size: 20,
//   //         ),
//   //         contentPadding: const EdgeInsets.symmetric(vertical: 10),
//   //         isDense: true,
//   //       ),
//   //     ),
//   //   );
//   // }
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// /// Placeholder Lesson Screen – shown when a category card is tapped
// /// until backend lesson content is integrated.
// // ─────────────────────────────────────────────────────────────────────────────
// class LessonPlaceholderScreen extends StatelessWidget {
//   final String title;
//   final Color color;
//
//   const LessonPlaceholderScreen({
//     super.key,
//     required this.title,
//     required this.color,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       appBar: AppBar(
//         title: Text(title),
//         backgroundColor: color.withOpacity(0.1),
//         foregroundColor: color,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_rounded),
//           onPressed: () => Navigator.pop(context),
//           tooltip: 'Go back',
//         ),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               width: 100,
//               height: 100,
//               decoration: BoxDecoration(
//                 color: color.withOpacity(0.1),
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(
//                 Icons.construction_rounded,
//                 color: color,
//                 size: 48,
//               ),
//             ),
//             const SizedBox(height: 24),
//             Text(
//               '$title Lessons',
//               style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                 color: color,
//               ),
//             ),
//             const SizedBox(height: 12),
//             Text(
//               'Coming soon! Lesson content\nwill appear here.',
//               textAlign: TextAlign.center,
//               style: Theme.of(context).textTheme.bodyMedium,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
