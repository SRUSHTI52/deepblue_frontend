// lib/screens/avatar_viewer_screen.dart
// ISL Connect – 3D Avatar WebView Screen
//
// Loads the hosted ISL avatar web app directly from GitHub Pages.
// No GLB files bundled in the APK — the website fetches all models itself.
//
// Live URL: https://srushti52.github.io/isl_avatar_web/
//
// After the page finishes loading Flutter injects JS to:
//   1. setCategory('actions' | 'alpha' | 'nums') → selects the sidebar tab
//   2. playAnim('Hello')                         → auto-plays a sign (optional)
//
// Deep-link args (passed from EducationalHubScreen via Navigator):
//   { 'category': 'actions' | 'alpha' | 'nums',
//     'sign':     'Hello' | 'A' | ... }           ← optional
//
// Android: <uses-permission android:name="android.permission.INTERNET"/>
//   is already present in most Flutter projects' AndroidManifest.xml.
// iOS: no extra config needed for plain https:// URLs.
//
// pubspec.yaml dep: webview_flutter: ^4.7.0

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../theme/app_theme.dart';

// ── Hosted URL — swap this if the site moves ─────────────────────────────────
const String _kAvatarUrl = 'https://srushti52.github.io/isl_avatar_web/';

class AvatarViewerScreen extends StatefulWidget {
  /// Sidebar tab to open first: 'actions' | 'alpha' | 'nums'
  final String initialCategory;

  /// If set, auto-plays this sign once the page finishes loading
  final String? initialSign;

  const AvatarViewerScreen({
    super.key,
    this.initialCategory = 'actions',
    this.initialSign,
  });

  @override
  State<AvatarViewerScreen> createState() => _AvatarViewerScreenState();
}

class _AvatarViewerScreenState extends State<AvatarViewerScreen> {
  // ── WebView controller ────────────────────────────────────────────────────
  late final WebViewController _webController;

  // ── UI state ──────────────────────────────────────────────────────────────
  bool _pageLoaded  = false; // true once onPageFinished fires
  bool _hasError    = false; // true on network / resource error
  int  _loadPercent = 0;     // 0–100 shown in loading bar

  // ── How long we wait after onPageFinished before injecting JS ─────────────
  // Three.js needs a moment to set up the scene after the HTML has loaded.
  static const Duration _jsDelay = Duration(milliseconds: 800);

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  void _initWebView() {
    _webController = WebViewController()
    // Allow JS — Three.js requires it
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
    // Dark background matches --bg token (#0D0820) so no white flash
      ..setBackgroundColor(const Color(0xFF0D0820))
    // Allow the page to load mixed content if needed (safe for GitHub Pages)
      ..setNavigationDelegate(
        NavigationDelegate(
          // ── Page is fully loaded ──────────────────────────────────────────
          onPageFinished: (_) async {
            // Wait for Three.js scene to initialise before injecting commands
            await Future.delayed(_jsDelay);
            if (!mounted) return;

            try {
              // 1. Switch to the correct category tab
              await _webController.runJavaScript(
                "if(typeof setCategory==='function') setCategory('${widget.initialCategory}');",
              );

              // 2. Optionally auto-play a specific sign
              if (widget.initialSign != null) {
                // Extra delay so the category tab finishes rendering
                await Future.delayed(const Duration(milliseconds: 400));
                await _webController.runJavaScript(
                  "if(typeof playAnim==='function') playAnim('${widget.initialSign}');",
                );
              }
            } catch (_) {
              // JS injection can fail if the page's window.setCategory /
              // window.playAnim aren't exposed yet — safe to ignore here;
              // the user can still interact with the page manually.
            }

            if (mounted) setState(() => _pageLoaded = true);
          },

          // ── Progress indicator ────────────────────────────────────────────
          onProgress: (progress) {
            if (mounted) setState(() => _loadPercent = progress);
          },

          // ── Navigation errors (no network, DNS fail, etc.) ────────────────
          onWebResourceError: (error) {
            // Only surface fatal errors (not sub-resource 404s)
            if (error.isForMainFrame ?? false) {
              if (mounted) setState(() => _hasError = true);
            }
          },

          // ── Block external navigations (keep user inside the avatar app) ──
          onNavigationRequest: (request) {
            if (request.url.startsWith(_kAvatarUrl)) {
              return NavigationDecision.navigate;
            }
            // Allow Three.js CDN and other resources from the page itself
            return NavigationDecision.navigate;
          },
        ),
      )
    // ── Load the live URL ──────────────────────────────────────────────────
      ..loadRequest(Uri.parse(_kAvatarUrl));
  }

  // ── Called from outside (e.g. a future overlay widget) ───────────────────
  void playSign(String signName) {
    _webController.runJavaScript(
      "if(typeof playAnim==='function') playAnim('$signName');",
    );
  }

  // ── Reload button helper ─────────────────────────────────────────────────
  Future<void> _reload() async {
    setState(() {
      _hasError    = false;
      _pageLoaded  = false;
      _loadPercent = 0;
    });
    await _webController.loadRequest(Uri.parse(_kAvatarUrl));
  }

  // ═══════════════════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0820),
      body: Stack(
        children: [
          // ── WebView (always present in tree so it loads in background) ─────
          if (!_hasError)
            WebViewWidget(controller: _webController),

          // ── Error state ───────────────────────────────────────────────────
          if (_hasError)
            _buildErrorState(context),

          // ── Loading overlay (fades out when page finishes) ────────────────
          AnimatedOpacity(
            duration: const Duration(milliseconds: 600),
            opacity: _pageLoaded ? 0.0 : 1.0,
            child: IgnorePointer(
              ignoring: _pageLoaded,
              child: _buildLoadingOverlay(),
            ),
          ),
        ],
      ),
    );
  }

  // ── Loading overlay ───────────────────────────────────────────────────────
  Widget _buildLoadingOverlay() {
    return Container(
      color: const Color(0xFF0D0820),
      child: SafeArea(
        child: Column(
          children: [

            // ── Top bar with back button ────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 8, 16, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Colors.white70,
                    ),
                    onPressed: () => Navigator.pop(context),
                    tooltip: 'Go back',
                  ),
                  const Text(
                    'Loading Avatar…',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      color: Colors.white54,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  // Percent label
                  Text(
                    '$_loadPercent%',
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      color: Colors.white30,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),

            // ── Thin progress bar ───────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: _loadPercent > 0 ? _loadPercent / 100 : null,
                  minHeight: 3,
                  backgroundColor: AppColors.primary.withOpacity(0.12),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.accent,
                  ),
                ),
              ),
            ),

            const Spacer(),

            // ── Dual-ring spinner ───────────────────────────────────────────
            SizedBox(
              width: 88,
              height: 88,
              child: _DualRingSpinner(),
            ),

            const SizedBox(height: 24),

            // ── Status text ─────────────────────────────────────────────────
            const Text(
              'Preparing 3D Avatar',
              style: TextStyle(
                fontFamily: 'Nunito',
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 8),

            // ── URL pill ────────────────────────────────────────────────────
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.2),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.public_rounded,
                    size: 13,
                    color: AppColors.accent.withOpacity(0.7),
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      'srushti52.github.io/isl_avatar_web',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 11,
                        color: Colors.white.withOpacity(0.4),
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            Text(
              'Fetching Three.js models from the web…',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 12,
                color: Colors.white.withOpacity(0.25),
              ),
            ),

            const Spacer(),

            // ── ISL Connect branding ────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.only(bottom: 28),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 6, height: 6,
                    decoration: const BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'ISL CONNECT · 3D AVATAR',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      color: Colors.white24,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Error state ───────────────────────────────────────────────────────────
  Widget _buildErrorState(BuildContext context) {
    return Container(
      color: const Color(0xFF0D0820),
      child: SafeArea(
        child: Column(
          children: [
            // Back button row
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 8, 16, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Colors.white70,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Error icon
            Container(
              width: 82, height: 82,
              decoration: BoxDecoration(
                color: AppColors.accentWarm.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.accentWarm.withOpacity(0.2),
                ),
              ),
              child: const Icon(
                Icons.wifi_off_rounded,
                color: AppColors.accentWarm,
                size: 40,
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Could not reach 3D Viewer',
              style: TextStyle(
                fontFamily: 'Nunito',
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 10),

            // URL that failed
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                _kAvatarUrl,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  color: Colors.white30,
                  fontSize: 12,
                  height: 1.5,
                ),
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'Check your internet connection and try again.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Nunito',
                color: Colors.white38,
                fontSize: 13,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 32),

            // Retry button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Retry
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeOutBack,
                  builder: (_, v, child) =>
                      Transform.scale(scale: v, child: child),
                  child: GestureDetector(
                    onTap: _reload,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 14),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, AppColors.accent],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.refresh_rounded,
                              color: Colors.white, size: 18),
                          SizedBox(width: 8),
                          Text(
                            'Retry',
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Go back
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: const Text(
                      'Go Back',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        color: Colors.white54,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const Spacer(),

            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Text(
                'ISL CONNECT · 3D AVATAR',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  color: Colors.white.withOpacity(0.12),
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
/// Pure-Flutter dual-ring spinner
/// Outer violet ring (clockwise) + inner teal ring (counter-clockwise) + 🤟
// ─────────────────────────────────────────────────────────────────────────────
class _DualRingSpinner extends StatefulWidget {
  @override
  State<_DualRingSpinner> createState() => _DualRingSpinnerState();
}

class _DualRingSpinnerState extends State<_DualRingSpinner>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => CustomPaint(
        painter: _RingPainter(progress: _ctrl.value),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  const _RingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerR = size.shortestSide / 2 - 4;
    final innerR = size.shortestSide / 2 - 16;
    const tau = 2 * 3.14159265;

    // Outer ring — violet, clockwise
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: outerR),
      progress * tau,
      1.8 * 3.14159,
      false,
      Paint()
        ..color = AppColors.primary
        ..strokeWidth = 5.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    // Inner ring — teal, counter-clockwise
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: innerR),
      -progress * tau,
      1.4 * 3.14159,
      false,
      Paint()
        ..color = AppColors.accent
        ..strokeWidth = 4
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    // 🤟 centred inside rings
    const span = TextSpan(text: '🤟', style: TextStyle(fontSize: 24));
    final tp = TextPainter(text: span, textDirection: TextDirection.ltr)
      ..layout();
    tp.paint(
        canvas, Offset(center.dx - tp.width / 2, center.dy - tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) => old.progress != progress;
}

// // lib/screens/avatar_viewer_screen.dart
// // ISL Connect – 3D Avatar WebView Screen
// //
// // Loads assets/isl_avatar_viewer.html inside a Flutter WebView.
// // Optional deep-link args let the Educational Hub pre-select a category
// // or auto-play a specific sign on open.
// //
// // Flow:
// //   EducationalHubScreen
// //     → "Learn with 3D Avatar" banner tap  → /avatar (actions)
// //     → category card long-press (optional) → /avatar?category=alpha&sign=A
// //
// // pubspec.yaml dep required:
// //   webview_flutter: ^4.7.0
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import '../theme/app_theme.dart';
//
// class AvatarViewerScreen extends StatefulWidget {
//   /// Which panel tab to open first: 'actions' | 'alpha' | 'nums'
//   final String initialCategory;
//
//   /// If set, auto-plays this sign immediately after the page loads
//   final String? initialSign;
//
//   const AvatarViewerScreen({
//     super.key,
//     this.initialCategory = 'actions',
//     this.initialSign,
//   });
//
//   @override
//   State<AvatarViewerScreen> createState() => _AvatarViewerScreenState();
// }
//
// class _AvatarViewerScreenState extends State<AvatarViewerScreen> {
//   late final WebViewController _webController;
//   bool _pageLoaded = false;
//   bool _hasError = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _initWebView();
//   }
//
//   Future<void> _initWebView() async {
//     // ── Read HTML from assets ─────────────────────────────────────────────
//     final htmlString =
//     await rootBundle.loadString('assets/isl_avatar_viewer.html');
//
//     _webController = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setBackgroundColor(const Color(0xFF0D0820)) // match --bg token
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onPageFinished: (_) async {
//             // ── Deep-link: set category tab then optionally auto-play sign ─
//             await _webController.runJavaScript(
//               "setCategory('${widget.initialCategory}');",
//             );
//             if (widget.initialSign != null) {
//               // Small delay so Three.js scene finishes initialising
//               await Future.delayed(const Duration(milliseconds: 600));
//               await _webController.runJavaScript(
//                 "playAnim('${widget.initialSign}');",
//               );
//             }
//             if (mounted) setState(() => _pageLoaded = true);
//           },
//           onWebResourceError: (_) {
//             if (mounted) setState(() => _hasError = true);
//           },
//         ),
//       )
//     // ── Load from assets as a data URI (works on Android + iOS) ─────────
//       ..loadHtmlString(htmlString, baseUrl: 'file:///android_asset/flutter_assets/');
//   }
//
//   // ── Change sign from Flutter (e.g. from a future overlay sheet) ──────────
//   void playSign(String signName) {
//     _webController.runJavaScript("playAnim('$signName');");
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0D0820),
//       body: Stack(
//         children: [
//           // ── WebView ───────────────────────────────────────────────────────
//           if (!_hasError)
//             WebViewWidget(controller: _webController),
//
//           // ── Error state ───────────────────────────────────────────────────
//           if (_hasError) _buildErrorState(context),
//
//           // ── Loading overlay (fades out once pageLoaded) ───────────────────
//           AnimatedOpacity(
//             duration: const Duration(milliseconds: 500),
//             opacity: _pageLoaded ? 0.0 : 1.0,
//             child: IgnorePointer(
//               ignoring: _pageLoaded,
//               child: _buildLoadingOverlay(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ── Loading overlay ───────────────────────────────────────────────────────
//   Widget _buildLoadingOverlay() {
//     return Container(
//       color: const Color(0xFF0D0820),
//       child: SafeArea(
//         child: Column(
//           children: [
//             // Minimal top bar so user can back out during load
//             Padding(
//               padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
//               child: Row(
//                 children: [
//                   IconButton(
//                     icon: const Icon(
//                       Icons.arrow_back_ios_rounded,
//                       color: Colors.white,
//                     ),
//                     onPressed: () => Navigator.pop(context),
//                   ),
//                   const Text(
//                     'Loading Avatar…',
//                     style: TextStyle(
//                       fontFamily: 'Nunito',
//                       color: Colors.white60,
//                       fontSize: 15,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             const Spacer(),
//
//             // Dual-ring spinner
//             SizedBox(
//               width: 80,
//               height: 80,
//               child: _DualRingSpinner(),
//             ),
//             const SizedBox(height: 22),
//             const Text(
//               'Preparing 3D Avatar',
//               style: TextStyle(
//                 fontFamily: 'Nunito',
//                 color: Colors.white,
//                 fontSize: 17,
//                 fontWeight: FontWeight.w800,
//               ),
//             ),
//             const SizedBox(height: 6),
//             const Text(
//               'Loading Indian Sign Language scene…',
//               style: TextStyle(
//                 fontFamily: 'Nunito',
//                 color: Colors.white38,
//                 fontSize: 13,
//               ),
//             ),
//
//             const Spacer(),
//
//             // ISL branding at bottom
//             Padding(
//               padding: const EdgeInsets.only(bottom: 24),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Container(
//                     width: 7, height: 7,
//                     decoration: BoxDecoration(
//                       color: AppColors.accent,
//                       shape: BoxShape.circle,
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   const Text(
//                     'ISL CONNECT · 3D AVATAR',
//                     style: TextStyle(
//                       fontFamily: 'Nunito',
//                       color: Colors.white24,
//                       fontSize: 11,
//                       fontWeight: FontWeight.w700,
//                       letterSpacing: 2,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // ── Error state ───────────────────────────────────────────────────────────
//   Widget _buildErrorState(BuildContext context) {
//     return Container(
//       color: const Color(0xFF0D0820),
//       child: SafeArea(
//         child: Center(
//           child: Padding(
//             padding: const EdgeInsets.all(32),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   width: 80, height: 80,
//                   decoration: BoxDecoration(
//                     color: AppColors.accentWarm.withOpacity(0.1),
//                     shape: BoxShape.circle,
//                   ),
//                   child: const Icon(
//                     Icons.videogame_asset_off_rounded,
//                     color: AppColors.accentWarm,
//                     size: 40,
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 const Text(
//                   'Could not load 3D viewer',
//                   style: TextStyle(
//                     fontFamily: 'Nunito',
//                     color: Colors.white,
//                     fontSize: 18,
//                     fontWeight: FontWeight.w800,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 const Text(
//                   'Check that isl_avatar_viewer.html\nis present in assets/ and listed in pubspec.yaml',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontFamily: 'Nunito',
//                     color: Colors.white38,
//                     fontSize: 13,
//                     height: 1.5,
//                   ),
//                 ),
//                 const SizedBox(height: 32),
//                 TextButton.icon(
//                   onPressed: () => Navigator.pop(context),
//                   icon: const Icon(
//                     Icons.arrow_back_ios_rounded,
//                     color: AppColors.accent,
//                     size: 16,
//                   ),
//                   label: const Text(
//                     'Go Back',
//                     style: TextStyle(
//                       fontFamily: 'Nunito',
//                       color: AppColors.accent,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // ── Pure-Flutter dual-ring spinner (no Lottie needed) ────────────────────────
// class _DualRingSpinner extends StatefulWidget {
//   @override
//   State<_DualRingSpinner> createState() => _DualRingSpinnerState();
// }
//
// class _DualRingSpinnerState extends State<_DualRingSpinner>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _ctrl;
//
//   @override
//   void initState() {
//     super.initState();
//     _ctrl = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1400),
//     )..repeat();
//   }
//
//   @override
//   void dispose() {
//     _ctrl.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _ctrl,
//       builder: (_, __) {
//         return CustomPaint(
//           painter: _RingPainter(progress: _ctrl.value),
//         );
//       },
//     );
//   }
// }
//
// class _RingPainter extends CustomPainter {
//   final double progress;
//   const _RingPainter({required this.progress});
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final center = Offset(size.width / 2, size.height / 2);
//     final outerR = size.shortestSide / 2 - 4;
//     final innerR = size.shortestSide / 2 - 14;
//
//     // Outer ring — violet, clockwise
//     canvas.drawArc(
//       Rect.fromCircle(center: center, radius: outerR),
//       progress * 2 * 3.14159,
//       1.8 * 3.14159,
//       false,
//       Paint()
//         ..color = AppColors.primary
//         ..strokeWidth = 5
//         ..style = PaintingStyle.stroke
//         ..strokeCap = StrokeCap.round,
//     );
//
//     // Inner ring — teal, counter-clockwise
//     canvas.drawArc(
//       Rect.fromCircle(center: center, radius: innerR),
//       -progress * 2 * 3.14159,
//       1.4 * 3.14159,
//       false,
//       Paint()
//         ..color = AppColors.accent
//         ..strokeWidth = 4
//         ..style = PaintingStyle.stroke
//         ..strokeCap = StrokeCap.round,
//     );
//
//     // Center hand icon text
//     const textSpan = TextSpan(
//       text: '🤟',
//       style: TextStyle(fontSize: 22),
//     );
//     final tp = TextPainter(
//       text: textSpan,
//       textDirection: TextDirection.ltr,
//     )..layout();
//     tp.paint(
//       canvas,
//       Offset(center.dx - tp.width / 2, center.dy - tp.height / 2),
//     );
//   }
//
//   @override
//   bool shouldRepaint(covariant _RingPainter old) => old.progress != progress;
// }

// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
//
// class ISLAvatarScreen extends StatefulWidget {
//   const ISLAvatarScreen({super.key});
//
//   @override
//   State<ISLAvatarScreen> createState() => _ISLAvatarScreenState();
// }
//
// class _ISLAvatarScreenState extends State<ISLAvatarScreen> {
//   late final WebViewController controller;
//
//   @override
//   void initState() {
//     super.initState();
//
//     controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..loadRequest(
//         Uri.parse(
//           "https://srushti52.github.io/isl_avatar_web/",
//         ),
//       );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("ISL 3D Teacher"),
//       ),
//       body: WebViewWidget(controller: controller),
//     );
//   }
// }
