// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/localization_ext.dart';
import '../widgets/app_widgets.dart';
import '../widgets/language_switcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseScale;
  late Animation<double> _pulseOpacity;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800))..repeat();
    _pulseScale   = Tween<double>(begin: 1.0, end: 1.15).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeOut));
    _pulseOpacity = Tween<double>(begin: 0.4, end: 0.0).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _startDetection() => Navigator.of(context).pushNamed('/detection');
  void _openRecent()     => Navigator.of(context).pushNamed('/recent');

  String _currentLangLabel(BuildContext context) {
    final code = Localizations.localeOf(context).languageCode;
    final lang = kSupportedLanguages.firstWhere((l) => l.locale == code, orElse: () => kSupportedLanguages.first);
    return '${lang.flag} ${lang.nativeName}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            expandedHeight: 170,
            floating: false, pinned: false, snap: false,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(background: _buildHeader(context, l10n)),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                FadeSlideIn(delay: const Duration(milliseconds: 200), child: _buildDetectionButton(context, size, l10n)),
                const SizedBox(height: 28),
                FadeSlideIn(
                  delay: const Duration(milliseconds: 350),
                  child: Text(l10n.homeQuickAccess,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.textSecondary, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                ),
                const SizedBox(height: 14),
                FadeSlideIn(
                  delay: const Duration(milliseconds: 430),
                  child: SmallFeatureCard(title: l10n.homePracticeMode, icon: Icons.play_circle_fill_rounded, color: AppColors.accent, onTap: _startDetection),
                ),
                const SizedBox(height: 12),
                FadeSlideIn(
                  delay: const Duration(milliseconds: 510),
                  child: SmallFeatureCard(title: l10n.homeRecentSigns, icon: Icons.history_rounded, color: AppColors.primary, onTap: _openRecent),
                ),
                const SizedBox(height: 28),
                FadeSlideIn(delay: const Duration(milliseconds: 600), child: _buildTipBanner(context, l10n)),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, l10n) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [Color(0xFF2066BC), Color(0xFF477CE4), Color(0xFF00C9B1)],
          stops: [0.0, 0.6, 1.0],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(36)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: FadeSlideIn(
                      delay: const Duration(milliseconds: 50),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.homeCommunicate, style: const TextStyle(fontFamily: 'Nunito', fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -0.5)),
                          Text(l10n.homeFreely,       style: const TextStyle(fontFamily: 'Nunito', fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -0.5)),
                        ],
                      ),
                    ),
                  ),
                  // ── Language switcher pill ───────────────────────────
                  FadeSlideIn(
                    delay: const Duration(milliseconds: 100),
                    child: GestureDetector(
                      onTap: () => LanguageSwitcher.show(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.2),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.language_rounded, color: Colors.white, size: 16),
                            const SizedBox(width: 5),
                            Text(_currentLangLabel(context),
                                style: const TextStyle(fontFamily: 'Nunito', fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
                            const SizedBox(width: 2),
                            const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white, size: 15),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              FadeSlideIn(
                delay: const Duration(milliseconds: 150),
                child: Text(l10n.homeSubtitle,
                    style: TextStyle(fontFamily: 'Nunito', fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white.withOpacity(0.75))),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetectionButton(BuildContext context, Size size, l10n) {
    return Semantics(
      label: l10n.homeStartDetectionLabel,
      button: true,
      child: TapScaleWidget(
        onTap: _startDetection,
        scaleTo: 0.97,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF3F88F6), Color(0xFF00C9B1)]),
            borderRadius: BorderRadius.circular(32),
            boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.35), blurRadius: 24, offset: const Offset(0, 8), spreadRadius: 2)],
          ),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (_, __) => Transform.scale(
                      scale: _pulseScale.value,
                      child: Container(
                        width: 110, height: 110,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(_pulseOpacity.value * 0.3),
                          border: Border.all(color: Colors.white.withOpacity(_pulseOpacity.value), width: 2),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 90, height: 90,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18), shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withOpacity(0.35), width: 2),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Image.asset('assets/images/camera.png', fit: BoxFit.contain),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(l10n.homeStartDetection,
                  style: const TextStyle(fontFamily: 'Nunito', fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -0.3)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
                child: Text(l10n.homeStartDetectionHint,
                    style: const TextStyle(fontFamily: 'Nunito', fontSize: 13, color: Colors.white, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTipBanner(BuildContext context, l10n) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.accent.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.accent.withOpacity(0.2), width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.lightbulb_rounded, color: AppColors.accent, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.homeTipTitle,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.accent, fontWeight: FontWeight.w800)),
                const SizedBox(height: 2),
                Text(l10n.homeTipBody,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary, fontSize: 12, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}