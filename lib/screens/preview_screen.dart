// lib/screens/preview_screen.dart
// ISL Connect – Preview Screen
//
// Flow: RecordScreen → PreviewScreen → ResultScreen
//
// Shows the recorded video with playback controls, then lets the user
// either retake or upload to the prediction API.
//
// Design:
//   • Dark fullscreen video player (matches RecordScreen aesthetic)
//   • Frosted-glass bottom sheet with playback + action controls
//   • Loading overlay with animated indicator during upload
//   • Retake / Upload & Predict buttons using ISL Connect button styles

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';
import '../services/api_service.dart';
import '../models/prediction_response.dart';
import 'result_screen.dart';

class PreviewScreen extends StatefulWidget {
  final File videoFile;
  const PreviewScreen({super.key, required this.videoFile});

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen>
    with SingleTickerProviderStateMixin {
  // ── Video playback ────────────────────────────────────────────────────────
  late VideoPlayerController _videoController;
  bool _videoReady = false;

  // ── Upload state ──────────────────────────────────────────────────────────
  bool _isUploading = false;

  // ── Upload progress animation (indeterminate spinner rotation) ────────────
  late AnimationController _spinController;

  @override
  void initState() {
    super.initState();

    // Spinner for upload overlay
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    // Initialise video player from the recorded file
    _videoController = VideoPlayerController.file(widget.videoFile)
      ..initialize().then((_) {
        if (mounted) {
          setState(() => _videoReady = true);
          _videoController.setLooping(true);
          _videoController.play();
        }
      });
  }

  @override
  void dispose() {
    _videoController.dispose();
    _spinController.dispose();
    super.dispose();
  }

  // ── Toggle play / pause ───────────────────────────────────────────────────
  void _togglePlay() {
    setState(() {
      _videoController.value.isPlaying
          ? _videoController.pause()
          : _videoController.play();
    });
  }

  // ── Upload video to API and navigate to ResultScreen ─────────────────────
  Future<void> _uploadAndPredict() async {
    setState(() => _isUploading = true);
    try {
      final responseJson = await ApiService.uploadVideo(widget.videoFile);
      final result = PredictionResponse.fromJson(responseJson);

      if (!mounted) return;
      // Replace this screen with ResultScreen (user can't go "back" to preview)
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => ResultScreen(result: result),
          transitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (_, animation, __, child) => FadeTransition(
            opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
            child: child,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isUploading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Prediction failed: $e',
            style: const TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.w600),
          ),
          backgroundColor: AppColors.accentWarm,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // No AppBar — full-bleed dark layout matching RecordScreen
      body: Stack(
        children: [
          // ── Full-screen video player ────────────────────────────────────
          _buildVideoLayer(),

          // ── Top bar: back button + title ────────────────────────────────
          _buildTopBar(context),

          // ── Bottom action sheet ─────────────────────────────────────────
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: _buildBottomSheet(context),
          ),

          // ── Upload loading overlay ──────────────────────────────────────
          if (_isUploading) _buildUploadOverlay(),
        ],
      ),
    );
  }

  // ── Video layer with tap-to-pause ─────────────────────────────────────────
  Widget _buildVideoLayer() {
    if (!_videoReady) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.accent),
      );
    }
    return GestureDetector(
      onTap: _togglePlay,
      child: SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: _videoController.value.size.width,
            height: _videoController.value.size.height,
            child: VideoPlayer(_videoController),
          ),
        ),
      ),
    );
  }

  // ── Play/pause icon flash in center ──────────────────────────────────────
  // (shown as subtle overlay when user taps to pause/play)
  Widget _buildPlayPauseHint() {
    return ValueListenableBuilder<VideoPlayerValue>(
      valueListenable: _videoController,
      builder: (_, value, __) {
        return AnimatedOpacity(
          duration: const Duration(milliseconds: 250),
          opacity: value.isPlaying ? 0.0 : 0.85,
          child: Center(
            child: Container(
              width: 72, height: 72,
              decoration: BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white30, width: 1.5),
              ),
              child: const Icon(
                Icons.play_arrow_rounded,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
        );
      },
    );
  }

  // ── Top safe-area bar ─────────────────────────────────────────────────────
  Widget _buildTopBar(BuildContext context) {
    return Positioned(
      top: 0, left: 0, right: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              // Back → go back to RecordScreen to retake
              IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.pop(context),
                tooltip: 'Retake',
              ),
              const Expanded(
                child: Text(
                  'Preview Sign',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              // Replay button
              IconButton(
                icon: const Icon(Icons.replay_rounded, color: Colors.white),
                onPressed: () {
                  _videoController.seekTo(Duration.zero);
                  _videoController.play();
                },
                tooltip: 'Replay',
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Bottom frosted action sheet ───────────────────────────────────────────
  Widget _buildBottomSheet(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Colors.black, Colors.black87, Colors.transparent],
          stops: [0.0, 0.7, 1.0],
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Video progress bar ────────────────────────────────────────
              if (_videoReady) ...[
                VideoProgressIndicator(
                  _videoController,
                  allowScrubbing: true,
                  colors: VideoProgressColors(
                    playedColor: AppColors.accent,
                    bufferedColor: AppColors.accent.withOpacity(0.25),
                    backgroundColor: Colors.white12,
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // ── Info chip ─────────────────────────────────────────────────
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.sign_language_rounded,
                        color: AppColors.accent, size: 16),
                    SizedBox(width: 8),
                    Text(
                      'Review your sign before sending',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        color: Colors.white70,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ── Action buttons row ────────────────────────────────────────
              Row(
                children: [
                  // Retake — secondary style (outlined)
                  Expanded(
                    child: TapScaleWidget(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        height: 54,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white24,
                            width: 1.5,
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt_outlined,
                                color: Colors.white, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Retake',
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Upload & Predict — primary gradient button
                  Expanded(
                    flex: 2,
                    child: TapScaleWidget(
                      onTap: _uploadAndPredict,
                      child: Container(
                        height: 54,
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
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.auto_awesome_rounded,
                                color: Colors.white, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Upload & Predict',
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Full-screen upload loading overlay ────────────────────────────────────
  Widget _buildUploadOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.75),
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 48),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1035),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.25),
                blurRadius: 40,
                spreadRadius: 4,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Animated gradient ring
              SizedBox(
                width: 72,
                height: 72,
                child: RotationTransition(
                  turns: _spinController,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: SweepGradient(
                        colors: [
                          AppColors.primary,
                          AppColors.accent,
                          AppColors.primary.withOpacity(0.1),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: const BoxDecoration(
                          color: Color(0xFF1A1035),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.sign_language_rounded,
                          color: AppColors.accent,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Analysing Sign…',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Sending to ISL model',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  color: Colors.white54,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
// import '../services/api_service.dart';
// import '../models/prediction_response.dart';
// import 'result_screen.dart';
// class PreviewScreen extends StatefulWidget {
//   final File videoFile;
//
//   const PreviewScreen({super.key, required this.videoFile});
//
//   @override
//   State<PreviewScreen> createState() => _PreviewScreenState();
// }
//
// class _PreviewScreenState extends State<PreviewScreen> {
//   late VideoPlayerController _videoController;
//
//   @override
//   void initState() {
//     super.initState();
//     _videoController = VideoPlayerController.file(widget.videoFile)
//       ..initialize().then((_) {
//         setState(() {});
//         _videoController.play();
//       });
//   }
//
//   @override
//   void dispose() {
//     _videoController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Preview")),
//       body: Column(
//         children: [
//           AspectRatio(
//             aspectRatio: _videoController.value.aspectRatio,
//             child: VideoPlayer(_videoController),
//           ),
//           const SizedBox(height: 20),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               ElevatedButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text("Retake"),
//               ),
//               ElevatedButton(
//                 onPressed: () async {
//                   try {
//                     showDialog(
//                       context: context,
//                       barrierDismissible: false,
//                       builder: (_) => const Center(child: CircularProgressIndicator()),
//                     );
//
//                     final responseJson =
//                     await ApiService.uploadVideo(widget.videoFile);
//
//                     Navigator.pop(context); // remove loader
//
//                     final result = PredictionResponse.fromJson(responseJson);
//
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => ResultScreen(result: result),
//                       ),
//                     );
//                   } catch (e) {
//                     print("Error: $e");
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text("Prediction failed: $e")),
//                     );
//                   }
//
//                 },
//                 child: const Text("Upload & Predict"),
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }