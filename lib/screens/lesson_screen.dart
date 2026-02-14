import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../models/lesson_model.dart';

class LessonScreen extends StatefulWidget {
  final Lesson lesson;
  final Color color;

  const LessonScreen({
    super.key,
    required this.lesson,
    required this.color,
  });

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  VideoPlayerController? _controller;
  int currentVideoIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.lesson.videos.isNotEmpty) {
      _initializeVideo();
    }
  }

  void _initializeVideo() {
    _controller = VideoPlayerController.asset(
      widget.lesson.videos[currentVideoIndex],
    )..initialize().then((_) {
      setState(() {});
      _controller!.play();
    });

    _controller!.addListener(() {
      if (_controller!.value.position ==
          _controller!.value.duration) {
        _playNextVideo();
      }
    });
  }

  void _playNextVideo() {
    if (currentVideoIndex < widget.lesson.videos.length - 1) {
      currentVideoIndex++;
      _controller!.dispose();
      _initializeVideo();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lesson.title),
        backgroundColor: widget.color.withOpacity(0.1),
        foregroundColor: widget.color,
          ),      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// Description
            Text(widget.lesson.description),
            const SizedBox(height: 20),

            /// Images Section
            if (widget.lesson.images.isNotEmpty)
              Column(
                children: widget.lesson.images
                    .map((img) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Image.asset(img),
                ))
                    .toList(),
              ),

            /// Videos Section
            if (_controller != null &&
                _controller!.value.isInitialized)
              AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: VideoPlayer(_controller!),
              ),
          ],
        ),
      ),
    );
  }
}
