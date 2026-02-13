// lib/screens/placeholder_screens.dart
// ISL Connect – Placeholder screens for backend-integrated workflows.
// These represent routes that will be replaced once the ML backend is ready.

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';

// ─────────────────────────────────────────────────────────────────────────────
/// Sign Detection Placeholder Screen
/// Shows a camera viewfinder UI mockup until camera/ML integration is complete.
// ─────────────────────────────────────────────────────────────────────────────
class DetectionPlaceholderScreen extends StatefulWidget {
  const DetectionPlaceholderScreen({super.key});

  @override
  State<DetectionPlaceholderScreen> createState() =>
      _DetectionPlaceholderScreenState();
}

class _DetectionPlaceholderScreenState
    extends State<DetectionPlaceholderScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _scanController;
  late Animation<double> _scanAnim;

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _scanAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scanController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text(
          'Sign Detection',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
          tooltip: 'Go back',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_off_rounded, color: Colors.white),
            onPressed: () {},
            tooltip: 'Toggle flashlight',
          ),
          IconButton(
            icon: const Icon(Icons.flip_camera_ios_rounded, color: Colors.white),
            onPressed: () {},
            tooltip: 'Switch camera',
          ),
        ],
      ),
      body: Stack(
        children: [
          // ── Camera viewfinder mockup ──────────────────────────────────
          Container(
            color: const Color(0xFF0A0A0A),
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ── Corner frame overlay ────────────────────────────────
                  SizedBox(
                    width: 280,
                    height: 320,
                    child: CustomPaint(
                      painter: _FrameCornerPainter(
                        color: AppColors.accent,
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.pan_tool_outlined,
                              color: Colors.white.withOpacity(0.3),
                              size: 72,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Position your hand\nhere',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.4),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ── Scan line animation ─────────────────────────────────
                  AnimatedBuilder(
                    animation: _scanAnim,
                    builder: (_, __) => Container(
                      height: 3,
                      width: 280 * _scanAnim.value,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            AppColors.accent.withOpacity(0.8),
                            Colors.transparent,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Bottom detection result panel ─────────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.85),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(32),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── Status ─────────────────────────────────────────────
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Color(0xFF4CAF50),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Waiting for sign…',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ── Detected sign placeholder ──────────────────────────
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.accent.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.sign_language_rounded,
                            color: AppColors.accent, size: 32),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              '—',
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              'Detected sign appears here',
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                color: Colors.white38,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Action hint ────────────────────────────────────────
                  Center(
                    child: Text(
                      'Camera integration connects here',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        color: Colors.white.withOpacity(0.3),
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Frame corner painter for camera viewfinder ───────────────────────────────
class _FrameCornerPainter extends CustomPainter {
  final Color color;
  const _FrameCornerPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    const cornerLen = 30.0;
    const radius = 12.0;

    // Top-left
    canvas.drawLine(
        Offset(radius, 0), Offset(radius + cornerLen, 0), paint);
    canvas.drawLine(
        Offset(0, radius), Offset(0, radius + cornerLen), paint);
    canvas.drawArc(
        Rect.fromLTWH(0, 0, radius * 2, radius * 2),
        3.14159, 0.5 * 3.14159, false, paint);

    // Top-right
    canvas.drawLine(Offset(size.width - radius - cornerLen, 0),
        Offset(size.width - radius, 0), paint);
    canvas.drawLine(Offset(size.width, radius),
        Offset(size.width, radius + cornerLen), paint);
    canvas.drawArc(
        Rect.fromLTWH(size.width - radius * 2, 0, radius * 2, radius * 2),
        1.5 * 3.14159, 0.5 * 3.14159, false, paint);

    // Bottom-left
    canvas.drawLine(Offset(0, size.height - radius - cornerLen),
        Offset(0, size.height - radius), paint);
    canvas.drawLine(Offset(radius, size.height),
        Offset(radius + cornerLen, size.height), paint);
    canvas.drawArc(
        Rect.fromLTWH(0, size.height - radius * 2, radius * 2, radius * 2),
        0.5 * 3.14159, 0.5 * 3.14159, false, paint);

    // Bottom-right
    canvas.drawLine(
        Offset(size.width - radius - cornerLen, size.height),
        Offset(size.width - radius, size.height),
        paint);
    canvas.drawLine(
        Offset(size.width, size.height - radius - cornerLen),
        Offset(size.width, size.height - radius),
        paint);
    canvas.drawArc(
        Rect.fromLTWH(size.width - radius * 2,
            size.height - radius * 2, radius * 2, radius * 2),
        0, 0.5 * 3.14159, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
/// Generic Placeholder Screen for Practice Mode and Recent Signs
// ─────────────────────────────────────────────────────────────────────────────
class GenericPlaceholderScreen extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final String description;

  const GenericPlaceholderScreen({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeSlideIn(
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 52),
                ),
              ),
              const SizedBox(height: 28),
              FadeSlideIn(
                delay: const Duration(milliseconds: 100),
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 12),
              FadeSlideIn(
                delay: const Duration(milliseconds: 180),
                child: Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 32),
              FadeSlideIn(
                delay: const Duration(milliseconds: 260),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: color.withOpacity(0.2)),
                  ),
                  child: Text(
                    '🚧 Backend integration pending',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
