// lib/screens/record_screen.dart
// ISL Connect – Sign Detection Entry Point
//
// This is the REAL detection screen that starts when the user taps
// "Start Sign Detection" on the Home screen.
//
// Flow:
//   HomeScreen → taps hero button
//     → Navigator.pushNamed('/detection')          ← wired in main.dart
//       → RecordScreen (this file)                 ← front camera opens
//         → user taps "Stop Recording"
//           → PreviewScreen(videoFile)             ← your existing preview screen
//
// The only file you need to place next to this one is:
//   lib/screens/preview_screen.dart  (your existing PreviewScreen widget)
//
// pubspec.yaml dependencies required:
//   camera: ^0.10.5+9
//   path_provider: ^2.1.2

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

// ── Import your existing PreviewScreen ────────────────────────────────────────
// Make sure preview_screen.dart is inside lib/screens/ alongside this file.
import 'package:isl_deep_blue/screens/preview_screen.dart';

// ── ISL Connect theme tokens (colours, text styles) ──────────────────────────
import '../theme/app_theme.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({super.key});

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen>
    with SingleTickerProviderStateMixin {
  // ── Camera state ──────────────────────────────────────────────────────────
  CameraController? _controller;
  bool _isRecording = false;
  bool _isInitializing = true; // shows loader while camera warms up
  String? _errorMessage;       // shown if camera fails to open

  // ── Pulsing red dot animation while recording ─────────────────────────────
  late AnimationController _recDotController;
  late Animation<double> _recDotOpacity;

  @override
  void initState() {
    super.initState();

    // Recording indicator: blinks red dot while recording
    _recDotController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _recDotOpacity = Tween<double>(begin: 1.0, end: 0.15).animate(
      CurvedAnimation(parent: _recDotController, curve: Curves.easeInOut),
    );

    _initCamera();
  }

  // ── Initialise front camera ───────────────────────────────────────────────
  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();

      // Prefer front camera for sign language (user faces camera)
      final frontCamera = cameras.firstWhere(
            (cam) => cam.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first, // fallback to rear if front unavailable
      );

      _controller = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false, // ISL is visual-only — no audio needed
      );

      await _controller!.initialize();
    } catch (e) {
      // Surface the error so the user knows what went wrong
      setState(() => _errorMessage = 'Camera unavailable: $e');
    } finally {
      if (mounted) setState(() => _isInitializing = false);
    }
  }

  // ── Start video recording ─────────────────────────────────────────────────
  Future<void> _startRecording() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    try {
      await _controller!.startVideoRecording();
      setState(() => _isRecording = true);
      _recDotController.repeat(reverse: true); // start blink
    } catch (e) {
      _showSnack('Could not start recording: $e');
    }
  }

  // ── Stop recording and hand off to PreviewScreen ──────────────────────────
  Future<void> _stopRecording() async {
    if (_controller == null || !_controller!.value.isRecordingVideo) return;

    try {
      final video = await _controller!.stopVideoRecording();
      _recDotController.stop();
      setState(() => _isRecording = false);

      if (!mounted) return;

      // Push to your existing PreviewScreen with the recorded file
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PreviewScreen(videoFile: File(video.path)),
        ),
      );
    } catch (e) {
      _showSnack('Could not stop recording: $e');
    }
  }

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    _recDotController.dispose();
    _controller?.dispose();
    super.dispose();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    // ── Loading state ────────────────────────────────────────────────────────
    if (_isInitializing) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: _buildAppBar(),
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.accent),
        ),
      );
    }

    // ── Error state ──────────────────────────────────────────────────────────
    if (_errorMessage != null || _controller == null) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: _buildAppBar(),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.videocam_off_rounded,
                    color: AppColors.accentWarm, size: 64),
                const SizedBox(height: 16),
                Text(
                  _errorMessage ?? 'Camera not available',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    color: Colors.white70,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // ── Main camera UI ───────────────────────────────────────────────────────
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // ── Camera preview fills available space ─────────────────────────
          Expanded(
            child: Stack(
              children: [
                // Full-screen camera feed
                SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: CameraPreview(_controller!),
                ),

                // ── Corner frame overlay (from ISL Connect design) ───────────
                Positioned.fill(
                  child: CustomPaint(
                    painter: _FrameCornerPainter(color: AppColors.accent),
                  ),
                ),

                // ── "Position your hands here" hint (shown before recording) ─
                if (!_isRecording)
                  Positioned(
                    top: 24,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: const Text(
                          '🤚  Position your hand in frame',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),

                // ── Blinking REC indicator (top-left while recording) ─────────
                if (_isRecording)
                  Positioned(
                    top: 20,
                    left: 20,
                    child: AnimatedBuilder(
                      animation: _recDotOpacity,
                      builder: (_, __) => Opacity(
                        opacity: _recDotOpacity.value,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.circle,
                                  color: AppColors.accentWarm, size: 10),
                              SizedBox(width: 6),
                              Text(
                                'REC',
                                style: TextStyle(
                                  fontFamily: 'Nunito',
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // ── Bottom control bar ────────────────────────────────────────────
          Container(
            color: Colors.black,
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Status text above button
                Text(
                  _isRecording
                      ? 'Recording your sign…'
                      : 'Tap to start recording',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 14),

                // Record / Stop button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed:
                    _isRecording ? _stopRecording : _startRecording,
                    // Dynamically swap icon and label
                    icon: Icon(
                      _isRecording
                          ? Icons.stop_circle_outlined
                          : Icons.fiber_manual_record_rounded,
                      size: 22,
                    ),
                    label: Text(
                      _isRecording ? 'Stop Recording' : 'Start Recording',
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      // Red while recording, brand violet otherwise
                      backgroundColor: _isRecording
                          ? AppColors.accentWarm
                          : AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: _isRecording ? 0 : 6,
                      shadowColor: AppColors.primary.withOpacity(0.4),
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

  // ── Shared AppBar ─────────────────────────────────────────────────────────
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      elevation: 0,
      title: const Text(
        'Record Sign',
        style: TextStyle(
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
        onPressed: () => Navigator.pop(context),
        tooltip: 'Go back',
      ),
      actions: [
        // Camera flip button (UI only — wire to controller.lensDirection if needed)
        IconButton(
          icon: const Icon(Icons.flip_camera_ios_rounded, color: Colors.white),
          onPressed: () {
            // TODO: implement front/rear camera switch
          },
          tooltip: 'Switch camera',
        ),
      ],
    );
  }
}

// ── Corner frame painter (same as the ISL Connect detection UI) ───────────────
// Draws 4 bracket-style corners over the camera feed to guide hand placement.
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

    const len = 32.0;
    const r = 12.0;
    const margin = 40.0; // inset from screen edges

    final l = margin;
    final t = margin;
    final ri = size.width - margin;
    final b = size.height - margin;

    // Top-left bracket
    canvas.drawLine(Offset(l + r, t), Offset(l + r + len, t), paint);
    canvas.drawLine(Offset(l, t + r), Offset(l, t + r + len), paint);
    canvas.drawArc(Rect.fromLTWH(l, t, r * 2, r * 2),
        3.14159, 0.5 * 3.14159, false, paint);

    // Top-right bracket
    canvas.drawLine(Offset(ri - r - len, t), Offset(ri - r, t), paint);
    canvas.drawLine(Offset(ri, t + r), Offset(ri, t + r + len), paint);
    canvas.drawArc(Rect.fromLTWH(ri - r * 2, t, r * 2, r * 2),
        1.5 * 3.14159, 0.5 * 3.14159, false, paint);

    // Bottom-left bracket
    canvas.drawLine(Offset(l, b - r - len), Offset(l, b - r), paint);
    canvas.drawLine(Offset(l + r, b), Offset(l + r + len, b), paint);
    canvas.drawArc(Rect.fromLTWH(l, b - r * 2, r * 2, r * 2),
        0.5 * 3.14159, 0.5 * 3.14159, false, paint);

    // Bottom-right bracket
    canvas.drawLine(Offset(ri - r - len, b), Offset(ri - r, b), paint);
    canvas.drawLine(Offset(ri, b - r - len), Offset(ri, b - r), paint);
    canvas.drawArc(Rect.fromLTWH(ri - r * 2, b - r * 2, r * 2, r * 2),
        0, 0.5 * 3.14159, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:isl_deep_blue/screens/preview_screen.dart';
// import 'package:path_provider/path_provider.dart';
//
// class RecordScreen extends StatefulWidget {
//   const RecordScreen({super.key});
//
//   @override
//   State<RecordScreen> createState() => _RecordScreenState();
// }
//
// class _RecordScreenState extends State<RecordScreen> {
//   CameraController? _controller;
//   bool _isRecording = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _initCamera();
//   }
//
//   Future<void> _initCamera() async {
//     final cameras = await availableCameras();
//     final frontCamera = cameras.firstWhere(
//           (cam) => cam.lensDirection == CameraLensDirection.front,
//     );
//
//     _controller = CameraController(
//       frontCamera,
//       ResolutionPreset.medium,
//       enableAudio: false,
//     );
//
//     await _controller!.initialize();
//     if (mounted) setState(() {});
//   }
//
//   Future<void> _startRecording() async {
//     if (!_controller!.value.isInitialized) return;
//
//     await _controller!.startVideoRecording();
//     setState(() => _isRecording = true);
//   }
//
//   Future<void> _stopRecording() async {
//     if (!_controller!.value.isRecordingVideo) return;
//     final video = await _controller!.stopVideoRecording();
//     setState(() => _isRecording = false);
//
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => PreviewScreen(videoFile: File(video.path)),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _controller?.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (_controller == null || !_controller!.value.isInitialized) {
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }
//
//     return Scaffold(
//       appBar: AppBar(title: const Text("Record Sign")),
//       body: Column(
//         children: [
//           Expanded(
//             child: CameraPreview(_controller!),
//           ),
//           const SizedBox(height: 10),
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: ElevatedButton(
//               onPressed: _isRecording ? _stopRecording : _startRecording,
//               child: Text(_isRecording ? "Stop Recording" : "Start Recording"),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }