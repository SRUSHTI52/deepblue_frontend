// lib/screens/result_screen.dart
// ISL Connect – Prediction Result Screen
//
// Flow: PreviewScreen → ResultScreen
//
// Shows:
//   • Detected sign label (large, bold, brand-colored)
//   • Animated confidence ring (arc that fills to match confidence %)
//   • Confidence percentage with color coding (green/amber/red)
//   • Optional sentence field (commented out in original — kept ready)
//   • "Record Again" CTA → pops back to Home (route.isFirst)
//   • "Learn This Sign" shortcut → Educational Hub
//
// All entrance elements use FadeSlideIn stagger from app_widgets.dart

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';
import '../models/prediction_response.dart';

class ResultScreen extends StatefulWidget {
  final PredictionResponse result;
  const ResultScreen({super.key, required this.result});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  // ── Confidence ring fills from 0 → actual confidence on mount ────────────
  late AnimationController _ringController;
  late Animation<double> _ringAnim;

  @override
  void initState() {
    super.initState();
    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _ringAnim = Tween<double>(
      begin: 0.0,
      end: widget.result.confidence.clamp(0.0, 1.0),
    ).animate(
      CurvedAnimation(parent: _ringController, curve: Curves.easeOutCubic),
    );

    // Small delay so the screen entrance animation plays first
    Future.delayed(const Duration(milliseconds: 350), () {
      if (mounted) _ringController.forward();
    });
  }

  @override
  void dispose() {
    _ringController.dispose();
    super.dispose();
  }

  // ── Color for confidence: green ≥ 0.8, amber ≥ 0.5, red < 0.5 ────────────
  Color _confidenceColor(double confidence) {
    if (confidence >= 0.80) return AppColors.categoryActions;  // green
    if (confidence >= 0.50) return AppColors.categoryEmergency; // amber
    return AppColors.accentWarm;                                 // coral/red
  }

  String _confidenceLabel(double confidence) {
    if (confidence >= 0.80) return 'High confidence';
    if (confidence >= 0.50) return 'Medium confidence';
    return 'Low confidence';
  }

  @override
  Widget build(BuildContext context) {
    final confidence = widget.result.confidence.clamp(0.0, 1.0);
    final confColor = _confidenceColor(confidence);
    final pct = (confidence * 100).toStringAsFixed(1);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar ───────────────────────────────────────────────────
            _buildTopBar(context),

            // ── Scrollable content ────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: Column(
                  children: [
                    // ── Success badge ─────────────────────────────────────
                    FadeSlideIn(
                      delay: const Duration(milliseconds: 50),
                      child: _buildSuccessBadge(),
                    ),

                    const SizedBox(height: 28),

                    // ── Detected sign card ────────────────────────────────
                    FadeSlideIn(
                      delay: const Duration(milliseconds: 150),
                      child: _buildSignCard(context),
                    ),

                    const SizedBox(height: 20),

                    // ── Confidence ring card ──────────────────────────────
                    FadeSlideIn(
                      delay: const Duration(milliseconds: 250),
                      child: _buildConfidenceCard(
                          context, confidence, confColor, pct),
                    ),

                    const SizedBox(height: 20),

                    // ── Sentence card (uncomment result.sentence when ready) ─
                    // FadeSlideIn(
                    //   delay: const Duration(milliseconds: 330),
                    //   child: _buildSentenceCard(context),
                    // ),

                    // ── Action buttons ────────────────────────────────────
                    FadeSlideIn(
                      delay: const Duration(milliseconds: 330),
                      child: _buildActions(context),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Top bar ───────────────────────────────────────────────────────────────
  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded),
            color: AppColors.textPrimary,
            onPressed: () => Navigator.pop(context),
            tooltip: 'Back to preview',
          ),
          Expanded(
            child: Text(
              'Detection Result',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          // Share placeholder
          IconButton(
            icon: const Icon(Icons.share_outlined),
            color: AppColors.textSecondary,
            onPressed: () {
              // TODO: share result
            },
            tooltip: 'Share result',
          ),
        ],
      ),
    );
  }

  // ── "Sign Detected" success badge ─────────────────────────────────────────
  Widget _buildSuccessBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.categoryActions.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: AppColors.categoryActions.withOpacity(0.25),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8, height: 8,
            decoration: const BoxDecoration(
              color: AppColors.categoryActions,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'Sign Successfully Detected',
            style: TextStyle(
              fontFamily: 'Nunito',
              color: AppColors.categoryActions,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // ── Main detected sign card ───────────────────────────────────────────────
  Widget _buildSignCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.accent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.35),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Hand icon
          Container(
            width: 64, height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white24, width: 1.5),
            ),
            child: const Icon(
              Icons.sign_language_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),

          // Label: "Predicted Sign"
          Text(
            'Predicted Sign',
            style: TextStyle(
              fontFamily: 'Nunito',
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),

          // The sign word — big, bold, white
          Text(
            widget.result.label.toUpperCase(),
            style: const TextStyle(
              fontFamily: 'Nunito',
              color: Colors.white,
              fontSize: 44,
              fontWeight: FontWeight.w900,
              letterSpacing: -1.0,
              height: 1.1,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ── Confidence ring card ──────────────────────────────────────────────────
  Widget _buildConfidenceCard(
      BuildContext context,
      double confidence,
      Color confColor,
      String pct,
      ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // ── Animated arc ring ───────────────────────────────────────────
          AnimatedBuilder(
            animation: _ringAnim,
            builder: (_, __) => SizedBox(
              width: 90,
              height: 90,
              child: CustomPaint(
                painter: _ConfidenceRingPainter(
                  progress: _ringAnim.value,
                  color: confColor,
                  trackColor: confColor.withOpacity(0.12),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${(_ringAnim.value * 100).toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: confColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 20),

          // ── Text info ───────────────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Confidence Score',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$pct% accurate',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: confColor,
                  ),
                ),
                const SizedBox(height: 8),
                // Confidence label chip
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: confColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    _confidenceLabel(confidence),
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: confColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Sentence card (ready for when sentence field is active) ───────────────
  Widget _buildSentenceCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.12),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.format_quote_rounded,
                  color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Generated Sentence',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            // result.sentence — uncomment when backend sends sentence
            'Sentence will appear here.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ── CTA buttons ───────────────────────────────────────────────────────────
  Widget _buildActions(BuildContext context) {
    return Column(
      children: [
        // Record Again — primary
        TapScaleWidget(
          onTap: () {
            // Pop all the way back to Home (route.isFirst = MainNavigation)
            Navigator.popUntil(context, (route) => route.isFirst);
          },
          child: Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.accent],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.35),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.fiber_manual_record_rounded,
                    color: Colors.white, size: 18),
                SizedBox(width: 10),
                Text(
                  'Record Again',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Learn This Sign — secondary outlined
        TapScaleWidget(
          onTap: () {
            // Navigate to Educational Hub (tab index 1)
            Navigator.popUntil(context, (route) => route.isFirst);
            // TODO: pass tab switch signal via callback / provider if needed
          },
          child: Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.25),
                width: 1.5,
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.menu_book_rounded,
                    color: AppColors.primary, size: 20),
                SizedBox(width: 10),
                Text(
                  'Learn This Sign',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    color: AppColors.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── Confidence arc ring painter ───────────────────────────────────────────────
// Draws a background track circle and a colored arc that fills to `progress`.
class _ConfidenceRingPainter extends CustomPainter {
  final double progress; // 0.0 → 1.0
  final Color color;
  final Color trackColor;

  const _ConfidenceRingPainter({
    required this.progress,
    required this.color,
    required this.trackColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.shortestSide / 2) - 6;
    const startAngle = -3.14159 / 2; // start at 12 o'clock
    final sweepAngle = 2 * 3.14159 * progress;

    // Track (background ring)
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = trackColor
        ..strokeWidth = 8
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    if (progress > 0) {
      // Filled arc
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        Paint()
          ..color = color
          ..strokeWidth = 8
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ConfidenceRingPainter old) =>
      old.progress != progress || old.color != color;
}

// import 'package:flutter/material.dart';
// import '../models/prediction_response.dart';
//
// class ResultScreen extends StatelessWidget {
//   final PredictionResponse result;
//
//   const ResultScreen({super.key, required this.result});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Prediction Result")),
//       body: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Predicted Sign:",
//               style: Theme.of(context).textTheme.titleLarge,
//             ),
//             const SizedBox(height: 8),
//             Text(
//               result.label,
//               style: const TextStyle(
//                 fontSize: 32,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 20),
//             Text("Confidence: ${(result.confidence * 100).toStringAsFixed(2)}%"),
//             const SizedBox(height: 20),
//             // const Text("Generated Sentence:"),
//             // const SizedBox(height: 8),
//             // Text(
//             //   result.sentence,
//             //   style: const TextStyle(fontSize: 18),
//             // ),
//             const Spacer(),
//             Center(
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.popUntil(context, (route) => route.isFirst);
//                 },
//                 child: const Text("Record Again"),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }