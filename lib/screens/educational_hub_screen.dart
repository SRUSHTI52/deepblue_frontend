// lib/screens/educational_hub_screen.dart
import 'package:flutter/material.dart';
import 'package:isl_deep_blue/screens/category_detail_screen.dart';
import '../theme/app_theme.dart';
import '../utils/localization_ext.dart';
import '../widgets/app_widgets.dart';

class SignCategory {
  final String titleKey; // l10n key
  final String imageAsset;
  final Color color;
  final String descKey;
  final String route;
  String get avatarCategory {
    switch (titleKey) {
      case 'categoryAlphabets': return 'alpha';
      case 'categoryNumbers':   return 'nums';
      default:                  return 'actions';
    }
  }
  const SignCategory({required this.titleKey, required this.imageAsset, required this.color, required this.descKey, required this.route});
}

class EducationalHubScreen extends StatefulWidget {
  const EducationalHubScreen({super.key});
  @override
  State<EducationalHubScreen> createState() => _EducationalHubScreenState();
}

class _EducationalHubScreenState extends State<EducationalHubScreen> with SingleTickerProviderStateMixin {
  static const List<SignCategory> _categories = [
    SignCategory(titleKey: 'categoryAlphabets',   imageAsset: 'assets/images/c1-removebg-preview.png', color: AppColors.categoryAlphabet,  descKey: 'categoryAlphabetsDesc',    route: '/lessons/alphabets'),
    SignCategory(titleKey: 'categoryNumbers',      imageAsset: 'assets/images/c2-removebg-preview.png', color: AppColors.categoryNumbers,   descKey: 'categoryNumbersDesc',      route: '/lessons/numbers'),
    SignCategory(titleKey: 'categoryDailyActions', imageAsset: 'assets/images/c3-removebg-preview.png', color: AppColors.categoryActions,   descKey: 'categoryDailyActionsDesc', route: '/lessons/daily_actions'),
    SignCategory(titleKey: 'categoryEmotions',     imageAsset: 'assets/images/c4-removebg-preview.png', color: AppColors.categoryEmotions,  descKey: 'categoryEmotionsDesc',     route: '/lessons/emotions'),
    SignCategory(titleKey: 'categoryEmergency',    imageAsset: 'assets/images/c5-removebg-preview.png', color: AppColors.categoryEmergency, descKey: 'categoryEmergencyDesc',    route: '/lessons/emergency'),
    SignCategory(titleKey: 'categoryGreetings',    imageAsset: 'assets/images/c6-removebg-preview.png', color: AppColors.categoryGreetings, descKey: 'categoryGreetingsDesc',    route: '/lessons/greetings'),
  ];

  final List<bool> _visible = List.filled(6, false);
  bool _bannerVisible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 80), () { if (mounted) setState(() => _bannerVisible = true); });
    for (int i = 0; i < _categories.length; i++) {
      Future.delayed(Duration(milliseconds: 220 + (i * 90)), () { if (mounted) setState(() => _visible[i] = true); });
    }
  }

  String _localizedTitle(BuildContext context, String key) {
    final l10n = context.l10n;
    switch (key) {
      case 'categoryAlphabets':   return l10n.categoryAlphabets;
      case 'categoryNumbers':     return l10n.categoryNumbers;
      case 'categoryDailyActions':return l10n.categoryDailyActions;
      case 'categoryEmotions':    return l10n.categoryEmotions;
      case 'categoryEmergency':   return l10n.categoryEmergency;
      case 'categoryGreetings':   return l10n.categoryGreetings;
      default:                    return key;
    }
  }

  void _navigateToLesson(BuildContext context, SignCategory category) {
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => CategoryDetailScreen(
        categoryId: category.titleKey.replaceAll('category', '').toLowerCase(),
        title: _localizedTitle(context, category.titleKey),
        color: category.color,
      ),
    ));
  }

  void _openAvatar({String category = 'actions', String? sign}) {
    Navigator.of(context).pushNamed('/avatar', arguments: <String, dynamic>{'category': category, if (sign != null) 'sign': sign});
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            pinned: true,
            backgroundColor: AppColors.background,
            expandedHeight: 90,
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [StretchMode.fadeTitle, StretchMode.blurBackground],
              background: _buildHeader(context, l10n),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Avatar banner
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: _bannerVisible ? 1.0 : 0.0,
                  child: AnimatedSlide(
                    duration: const Duration(milliseconds: 500),
                    offset: _bannerVisible ? Offset.zero : const Offset(0, 0.12),
                    curve: Curves.easeOutCubic,
                    child: _AvatarBanner(onOpen: _openAvatar, l10n: l10n),
                  ),
                ),
                const SizedBox(height: 24),
                // Sign Categories header
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 400),
                  opacity: _bannerVisible ? 1.0 : 0.0,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Row(
                      children: [
                        Container(
                          width: 4, height: 18,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [AppColors.primary, AppColors.accent], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(l10n.eduHubSignCategories, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                        const Spacer(),
                        Text(l10n.eduHubTopicsCount(_categories.length), style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ),
                ),
                // Grid
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.92, crossAxisSpacing: 16, mainAxisSpacing: 16),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final cat = _categories[index];
                    return AnimatedOpacity(
                      duration: const Duration(milliseconds: 450),
                      opacity: _visible[index] ? 1.0 : 0.0,
                      curve: Curves.easeOut,
                      child: AnimatedSlide(
                        duration: const Duration(milliseconds: 450),
                        offset: _visible[index] ? Offset.zero : const Offset(0, 0.15),
                        curve: Curves.easeOutCubic,
                        child: CategoryCard(
                          title: _localizedTitle(context, cat.titleKey),
                          imageAsset: cat.imageAsset,
                          color: cat.color,
                          onTap: () => _navigateToLesson(context, cat),
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

  Widget _buildHeader(BuildContext context, l10n) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      alignment: Alignment.bottomLeft,
      color: AppColors.background,
      child: SafeArea(
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.school_rounded, color: AppColors.primary, size: 22),
            ),
            const SizedBox(width: 12),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.eduHubTitle, style: Theme.of(context).textTheme.headlineSmall),
                Text(l10n.eduHubCategoriesToExplore(_categories.length), style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AvatarBanner extends StatelessWidget {
  final void Function({String category, String? sign}) onOpen;
  final dynamic l10n;
  const _AvatarBanner({required this.onOpen, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: l10n.eduHubAvatarSemantics,
      button: true,
      child: TapScaleWidget(
        scaleTo: 0.98,
        onTap: () => onOpen(category: 'actions'),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.primary.withOpacity(0.12), width: 1.5),
            boxShadow: [
              BoxShadow(color: AppColors.primary.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 8), spreadRadius: -4),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(width: 3, height: 14, decoration: BoxDecoration(gradient: const LinearGradient(colors: [AppColors.primary, AppColors.accent], begin: Alignment.topCenter, end: Alignment.bottomCenter), borderRadius: BorderRadius.circular(2))),
                    const SizedBox(width: 8),
                    Text(l10n.eduHubInteractiveLearning, style: const TextStyle(fontFamily: 'Nunito', fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.accent, letterSpacing: 1.5)),
                  ],
                ),
                const SizedBox(height: 12),
                Text(l10n.eduHubLearnWith3D, style: const TextStyle(fontFamily: 'Nunito', fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.textPrimary, letterSpacing: -0.5, height: 1.2)),
                const SizedBox(height: 10),
                Text(l10n.eduHubAvatarDesc, style: TextStyle(fontFamily: 'Nunito', fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textSecondary, height: 1.5)),
                const SizedBox(height: 20),
                TapScaleWidget(
                  onTap: () => onOpen(category: 'actions'),
                  child: Container(
                    width: double.infinity, height: 52,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [AppColors.primary, AppColors.accent], begin: Alignment.centerLeft, end: Alignment.centerRight),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 16, offset: const Offset(0, 6))],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.view_in_ar_rounded, color: Colors.white, size: 20),
                        const SizedBox(width: 10),
                        Text(l10n.eduHubOpen3DViewer, style: const TextStyle(fontFamily: 'Nunito', color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800, letterSpacing: 0.2)),
                        const SizedBox(width: 4),
                        const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LessonPlaceholderScreen extends StatelessWidget {
  final String title;
  final Color color;
  const LessonPlaceholderScreen({super.key, required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: color.withOpacity(0.1),
        foregroundColor: color,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
          tooltip: l10n.lessonGoBack,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(width: 100, height: 100, decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle), child: Icon(Icons.construction_rounded, color: color, size: 48)),
            const SizedBox(height: 24),
            Text(l10n.lessonComingSoonTitle(title), style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: color)),
            const SizedBox(height: 12),
            Text(l10n.lessonComingSoon, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}