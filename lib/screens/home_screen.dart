// lib/screens/home_screen.dart
// ISL Connect – Home Screen (Sign Detection Hub)
//
// Layout:
//   • Gradient greeting header
//   • Large hero detection button with SVG icon + scale animation
//   • Two quick-access cards: Practice Mode & Recent Signs
//   • Staggered fade-up entrance animations for all sections

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  // ── Controls the pulsing ring around the detection button ────────────────
  late AnimationController _pulseController;
  late Animation<double> _pulseScale;
  late Animation<double> _pulseOpacity;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: false);

    _pulseScale = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeOut),
    );

    _pulseOpacity = Tween<double>(begin: 0.4, end: 0.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  // ── Navigate to RecordScreen via named route '/detection' ───────────────
  // Wired in main.dart: '/detection' → RecordScreen (lib/screens/record_screen.dart)
  void _startDetection() {
    Navigator.of(context).pushNamed('/detection');
  }

  // ── Navigate to practice mode (placeholder) ──────────────────────────────
  void _openPractice() {
    Navigator.of(context).pushNamed('/practice');
  }

  // ── Navigate to recent signs history (placeholder) ───────────────────────
  void _openRecent() {
    Navigator.of(context).pushNamed('/recent');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Custom SliverAppBar with gradient header ──────────────────────
          SliverAppBar(
            automaticallyImplyLeading: false,
            expandedHeight: 160,
            floating: false,
            pinned: false,
            snap: false,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildHeader(context),
            ),
          ),
          // const SizedBox(height: 28),
          SliverToBoxAdapter(
            child: SizedBox(height: 20),
          ),
          // ── Main content ─────────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ── Hero detection button ─────────────────────────────────
                FadeSlideIn(
                  delay: const Duration(milliseconds: 200),
                  child: _buildDetectionButton(context, size),
                ),

                const SizedBox(height: 28),

                // ── Quick access label ────────────────────────────────────
                FadeSlideIn(
                  delay: const Duration(milliseconds: 350),
                  child: Text(
                    'Quick Access',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // ── Practice mode card ────────────────────────────────────
                FadeSlideIn(
                  delay: const Duration(milliseconds: 430),
                  child: SmallFeatureCard(
                    title: 'Practice Mode',
                    icon: Icons.play_circle_fill_rounded,
                    color: AppColors.accent,
                    onTap: _startDetection,
                  ),
                ),

                const SizedBox(height: 12),

                // ── Recent signs card ─────────────────────────────────────
                FadeSlideIn(
                  delay: const Duration(milliseconds: 510),
                  child: SmallFeatureCard(
                    title: 'Recent Signs',
                    icon: Icons.history_rounded,
                    color: AppColors.primary,
                    onTap: _openRecent,
                  ),
                ),

                const SizedBox(height: 28),

                // ── Tips banner ───────────────────────────────────────────
                FadeSlideIn(
                  delay: const Duration(milliseconds: 600),
                  child: _buildTipBanner(context),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  // ── Gradient header with greeting text ───────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2066BC),
            Color(0xFF477CE4),
            Color(0xFF00C9B1),
          ],
          stops: [0.0, 0.6, 1.0],
        ),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(36),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Top row: title and avatar ─────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FadeSlideIn(
                    delay: const Duration(milliseconds: 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Communicate',
                          style: const TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                        Text(
                          'Freely',
                          style: const TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Notification / profile icon
                  // FadeSlideIn(
                  //   delay: const Duration(milliseconds: 100),
                  //   child: Container(
                  //     width: 48,
                  //     height: 48,
                  //     decoration: BoxDecoration(
                  //       color: Colors.white.withOpacity(0.15),
                  //       borderRadius: BorderRadius.circular(14),
                  //       border: Border.all(
                  //         color: Colors.white.withOpacity(0.25),
                  //       ),
                  //     ),
                  //     child: const Icon(
                  //       Icons.notifications_none_rounded,
                  //       color: Colors.white,
                  //       size: 24,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(height: 8),
              FadeSlideIn(
                delay: const Duration(milliseconds: 150),
                child: Text(
                  'Indian Sign Language made simple',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(0.75),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Hero sign detection button with pulsing ring ─────────────────────────
  Widget _buildDetectionButton(BuildContext context, Size size) {
    return Semantics(
      label: 'Start Sign Detection. Tap to open camera and begin detecting signs.',
      button: true,
      child: TapScaleWidget(
        onTap: _startDetection,
        scaleTo: 0.97,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF3F88F6),
                Color(0xFF00C9B1),
              ],
            ),
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.35),
                blurRadius: 24,
                offset: const Offset(0, 8),
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            children: [
              // ── Camera icon with pulsing ring ──────────────────────────
              Stack(
                alignment: Alignment.center,
                children: [
                  // Pulsing ring
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (_, __) => Transform.scale(
                      scale: _pulseScale.value,
                      child: Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white
                              .withOpacity(_pulseOpacity.value * 0.3),
                          border: Border.all(
                            color: Colors.white
                                .withOpacity(_pulseOpacity.value),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Icon container
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.35),
                        width: 2,
                      ),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Image.asset(
                      'assets/images/camera.png',
                      fit: BoxFit.contain,

                      // colorFilter: const ColorFilter.mode(
                      //   Colors.white,
                      //   BlendMode.srcIn,
                      // ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ── Label ─────────────────────────────────────────────────
              const Text(
                'Start Sign Detection',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: -0.3,
                ),
              ),

              const SizedBox(height: 8),

              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Point camera at hands to begin',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 13,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Daily tip banner ─────────────────────────────────────────────────────
  Widget _buildTipBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.accent.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.accent.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.lightbulb_rounded,
              color: AppColors.accent,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tip of the Day',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.accent,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Practice "Hello" sign: wave open palm side to side.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}