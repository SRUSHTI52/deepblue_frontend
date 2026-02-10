import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:isl_deep_blue/screens/preview_screen.dart';
import 'package:path_provider/path_provider.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({super.key});

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  CameraController? _controller;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
          (cam) => cam.lensDirection == CameraLensDirection.front,
    );

    _controller = CameraController(
      frontCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _controller!.initialize();
    if (mounted) setState(() {});
  }

  Future<void> _startRecording() async {
    if (!_controller!.value.isInitialized) return;

    await _controller!.startVideoRecording();
    setState(() => _isRecording = true);
  }

  Future<void> _stopRecording() async {
    if (!_controller!.value.isRecordingVideo) return;

    final video = await _controller!.stopVideoRecording();
    setState(() => _isRecording = false);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PreviewScreen(videoFile: File(video.path)),
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Record Sign")),
      body: Column(
        children: [
          Expanded(
            child: CameraPreview(_controller!),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: _isRecording ? _stopRecording : _startRecording,
              child: Text(_isRecording ? "Stop Recording" : "Start Recording"),
            ),
          ),
        ],
      ),
    );
  }
}