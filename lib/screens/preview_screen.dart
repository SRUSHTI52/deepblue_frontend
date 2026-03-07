import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';
import '../services/api_service.dart';
import '../models/prediction_response.dart';
import '../utils/localization_ext.dart';
import 'result_screen.dart';

class PreviewScreen extends StatefulWidget {
  final File videoFile;

  const PreviewScreen({super.key, required this.videoFile});

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen>
    with SingleTickerProviderStateMixin {

  late VideoPlayerController _videoController;
  bool _videoReady = false;

  bool _isUploading = false;

  late AnimationController _spinController;

  @override
  void initState() {
    super.initState();

    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

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

  void _togglePlay() {
    setState(() {
      _videoController.value.isPlaying
          ? _videoController.pause()
          : _videoController.play();
    });
  }

  Future<void> _uploadAndPredict() async {
    setState(() => _isUploading = true);

    try {
      final responseJson = await ApiService.uploadVideo(widget.videoFile);
      final result = PredictionResponse.fromJson(responseJson);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => ResultScreen(result: result),
          transitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (_, animation, __, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() => _isUploading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.l10n.previewPredictionFailed(e.toString()),
          ),
          backgroundColor: AppColors.accentWarm,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [

          _buildVideoLayer(),

          _buildTopBar(l10n),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomSheet(l10n),
          ),

          if (_isUploading) _buildUploadOverlay(l10n),
        ],
      ),
    );
  }

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
          fit: BoxFit.contain,  // ← change cover to contain
          child: SizedBox(
            width: _videoController.value.size.width,
            height: _videoController.value.size.height,
            child: VideoPlayer(_videoController),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(l10n) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [

              IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.pop(context),
                tooltip: l10n.previewRetake,
              ),

              Expanded(
                child: Text(
                  l10n.previewTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),

              IconButton(
                icon: const Icon(Icons.replay_rounded, color: Colors.white),
                tooltip: l10n.previewReplay,
                onPressed: () {
                  _videoController.seekTo(Duration.zero);
                  _videoController.play();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSheet(l10n) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Colors.black, Colors.black87, Colors.transparent],
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

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

              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.sign_language_rounded,
                      color: AppColors.accent,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.previewHint,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Row(
                children: [

                  Expanded(
                    child: TapScaleWidget(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        height: 54,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.camera_alt_outlined,
                                color: Colors.white),
                            const SizedBox(width: 8),
                            Text(
                              l10n.previewRetake,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    flex: 2,
                    child: TapScaleWidget(
                      onTap: _uploadAndPredict,
                      child: Container(
                        height: 54,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.primary, AppColors.accent],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.auto_awesome_rounded,
                                color: Colors.white),
                            const SizedBox(width: 8),
                            Text(
                              l10n.previewUpload,
                              style: const TextStyle(
                                color: Colors.white,
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

  Widget _buildUploadOverlay(l10n) {
    return Container(
      color: Colors.black.withOpacity(0.75),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            RotationTransition(
              turns: _spinController,
              child: const Icon(
                Icons.sign_language_rounded,
                size: 64,
                color: AppColors.accent,
              ),
            ),

            const SizedBox(height: 24),

            Text(
              l10n.previewAnalysing,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              l10n.previewSendingToModel,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}