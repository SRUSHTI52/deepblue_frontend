// lib/screens/record_screen.dart (localized)
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:isl_deep_blue/screens/preview_screen.dart';
import '../theme/app_theme.dart';
import '../utils/localization_ext.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({super.key});
  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> with SingleTickerProviderStateMixin {
  CameraController? _controller;
  bool _isRecording = false;
  bool _isInitializing = true;
  String? _errorMessage;
  late AnimationController _recDotController;
  late Animation<double> _recDotOpacity;

  @override
  void initState() {
    super.initState();
    _recDotController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _recDotOpacity = Tween<double>(begin: 1.0, end: 0.15).animate(CurvedAnimation(parent: _recDotController, curve: Curves.easeInOut));
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      final front = cameras.firstWhere((c) => c.lensDirection == CameraLensDirection.front, orElse: () => cameras.first);
      _controller = CameraController(front, ResolutionPreset.medium, enableAudio: false);
      await _controller!.initialize();
    } catch (e) {
      setState(() => _errorMessage = context.l10n.recordCameraUnavailable(e.toString()));
    } finally {
      if (mounted) setState(() => _isInitializing = false);
    }
  }

  Future<void> _startRecording() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    try {
      await _controller!.startVideoRecording();
      setState(() => _isRecording = true);
      _recDotController.repeat(reverse: true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  Future<void> _stopRecording() async {
    if (_controller == null || !_controller!.value.isRecordingVideo) return;
    try {
      final video = await _controller!.stopVideoRecording();
      _recDotController.stop();
      setState(() => _isRecording = false);
      if (!mounted) return;
      Navigator.push(context, MaterialPageRoute(builder: (_) => PreviewScreen(videoFile: File(video.path))));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  @override
  void dispose() { _recDotController.dispose(); _controller?.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    if (_isInitializing) return Scaffold(backgroundColor: Colors.black, appBar: _buildAppBar(l10n), body: const Center(child: CircularProgressIndicator(color: AppColors.accent)));
    if (_errorMessage != null || _controller == null) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: _buildAppBar(l10n),
        body: Center(child: Padding(padding: const EdgeInsets.all(32), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.videocam_off_rounded, color: AppColors.accentWarm, size: 64),
          const SizedBox(height: 16),
          Text(_errorMessage ?? 'Camera not available', textAlign: TextAlign.center, style: const TextStyle(fontFamily: 'Nunito', color: Colors.white70, fontSize: 15)),
        ]))),
      );
    }
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildAppBar(l10n),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                SizedBox(width: double.infinity, height: double.infinity, child: CameraPreview(_controller!)),
                Positioned.fill(child: CustomPaint(painter: _FrameCornerPainter(color: AppColors.accent))),
                if (!_isRecording)
                  Positioned(top: 24, left: 0, right: 0,
                      child: Center(child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(22)),
                        child: Text(l10n.recordPositionHint, style: const TextStyle(fontFamily: 'Nunito', color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                      ))),
                if (_isRecording)
                  Positioned(top: 20, left: 20,
                      child: AnimatedBuilder(animation: _recDotOpacity, builder: (_, __) => Opacity(opacity: _recDotOpacity.value,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(20)),
                            child: const Row(mainAxisSize: MainAxisSize.min, children: [
                              Icon(Icons.circle, color: AppColors.accentWarm, size: 10),
                              SizedBox(width: 6),
                              Text('REC', style: TextStyle(fontFamily: 'Nunito', color: Colors.white, fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 1.5)),
                            ]),
                          )))),
              ],
            ),
          ),
          Container(
            color: Colors.black,
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(_isRecording ? l10n.recordStatusRecording : l10n.recordStatusIdle,
                  style: TextStyle(fontFamily: 'Nunito', color: Colors.white.withOpacity(0.6), fontSize: 13, fontWeight: FontWeight.w500)),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity, height: 56,
                child: ElevatedButton.icon(
                  onPressed: _isRecording ? _stopRecording : _startRecording,
                  icon: Icon(_isRecording ? Icons.stop_circle_outlined : Icons.fiber_manual_record_rounded, size: 22),
                  label: Text(_isRecording ? l10n.recordStopBtn : l10n.recordStartBtn,
                      style: const TextStyle(fontFamily: 'Nunito', fontSize: 16, fontWeight: FontWeight.w800)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isRecording ? AppColors.accentWarm : AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    elevation: _isRecording ? 0 : 6,
                    shadowColor: AppColors.primary.withOpacity(0.4),
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar(l10n) => AppBar(
    backgroundColor: Colors.black, foregroundColor: Colors.white, elevation: 0,
    title: Text(l10n.recordTitle, style: const TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.w800, color: Colors.white)),
    leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white), onPressed: () => Navigator.pop(context), tooltip: l10n.recordGoBack),
    actions: [IconButton(icon: const Icon(Icons.flip_camera_ios_rounded, color: Colors.white), onPressed: () {}, tooltip: l10n.recordSwitchCamera)],
  );
}

class _FrameCornerPainter extends CustomPainter {
  final Color color;
  const _FrameCornerPainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..strokeWidth = 3.5..strokeCap = StrokeCap.round..style = PaintingStyle.stroke;
    const len = 32.0; const r = 12.0; const margin = 40.0;
    final l = margin; final t = margin; final ri = size.width - margin; final b = size.height - margin;
    canvas.drawLine(Offset(l + r, t), Offset(l + r + len, t), paint);
    canvas.drawLine(Offset(l, t + r), Offset(l, t + r + len), paint);
    canvas.drawArc(Rect.fromLTWH(l, t, r * 2, r * 2), 3.14159, 0.5 * 3.14159, false, paint);
    canvas.drawLine(Offset(ri - r - len, t), Offset(ri - r, t), paint);
    canvas.drawLine(Offset(ri, t + r), Offset(ri, t + r + len), paint);
    canvas.drawArc(Rect.fromLTWH(ri - r * 2, t, r * 2, r * 2), 1.5 * 3.14159, 0.5 * 3.14159, false, paint);
    canvas.drawLine(Offset(l, b - r - len), Offset(l, b - r), paint);
    canvas.drawLine(Offset(l + r, b), Offset(l + r + len, b), paint);
    canvas.drawArc(Rect.fromLTWH(l, b - r * 2, r * 2, r * 2), 0.5 * 3.14159, 0.5 * 3.14159, false, paint);
    canvas.drawLine(Offset(ri - r - len, b), Offset(ri - r, b), paint);
    canvas.drawLine(Offset(ri, b - r - len), Offset(ri, b - r), paint);
    canvas.drawArc(Rect.fromLTWH(ri - r * 2, b - r * 2, r * 2, r * 2), 0, 0.5 * 3.14159, false, paint);
  }
  @override bool shouldRepaint(covariant CustomPainter _) => false;
}