// lib/screens/chatbot_screen.dart
// ISL Connect – Chatbot Screen
//
// Features:
//   • Bot avatar header with status indicator
//   • Message bubbles: user (violet, right) vs bot (lavender, left)
//   • Sign-detected messages have a special badge
//   • Typing indicator (3-dot pulse animation)
//   • Input bar: camera icon + text field + send button
//   • Messages slide in from bottom as they are added

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../l10n/app_localizations.dart';

// ── Message data model ───────────────────────────────────────────────────────
class ChatMessage {
  final String text;
  final bool isUser;
  final bool isSign;
  final String? videoUrl;
  final DateTime time;

  const ChatMessage({
    required this.text,
    required this.isUser,
    this.isSign = false,
    this.videoUrl,
    required this.time,
  });
}

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen>
    with TickerProviderStateMixin {
  // ── Message list ─────────────────────────────────────────────────────────
  final List<ChatMessage> _messages = [
    ChatMessage(
      text: "Namaste! I'm your ISL guide. Ask me about any general, healthcare or support queries.",
      isUser: false,
      time: DateTime.now().subtract(const Duration(minutes: 2)),
    ),
    // ChatMessage(
    //   text: "How do I sign 'Thank you'?",
    //   isUser: true,
    //   time: DateTime.now().subtract(const Duration(minutes: 1)),
    // ),
    // ChatMessage(
    //   text: "Great question! For 'Thank you' in ISL: Place your right hand flat near your chin, then move it forward and slightly down. It's a graceful gesture! 🙏",
    //   isUser: false,
    //   time: DateTime.now().subtract(const Duration(seconds: 55)),
    // ),
  ];

  // ── Animation list for new messages ──────────────────────────────────────
  final List<AnimationController> _msgAnimControllers = [];

  // ── Typing indicator visibility ───────────────────────────────────────────
  bool _isTyping = false;

  // ── Text input controller ─────────────────────────────────────────────────
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  final String baseUrl = "https://lightfast-diane-gruntled.ngrok-free.dev";


  @override
  void initState() {
    super.initState();
    // Create animation controllers for initial messages
    for (int i = 0; i < _messages.length; i++) {
      _addMessageController();
    }
    // Play entrance animations for existing messages
    Future.delayed(const Duration(milliseconds: 100), _playAllEntrance);
  }

  @override
  void dispose() {
    for (final c in _msgAnimControllers) {
      c.dispose();
    }
    _inputController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // ── Add animation controller for a new message ───────────────────────────
  AnimationController _addMessageController() {
    final controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _msgAnimControllers.add(controller);
    return controller;
  }

  void _playAllEntrance() {
    for (int i = 0; i < _msgAnimControllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 120), () {
        if (mounted) _msgAnimControllers[i].forward();
      });
    }
  }

  // ── Send text message ────────────────────────────────────────────────────
  void _sendMessage() {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;

    // Add user message
    _addNewMessage(ChatMessage(
      text: text,
      isUser: true,
      time: DateTime.now(),
    ));

    _inputController.clear();
    _focusNode.unfocus();

    // Simulate bot typing delay + response
    _getGeminiResponse(text);

  }

  // ── Simulate sign camera detection (placeholder) ─────────────────────────
  Future<void> _triggerSignDetection() async {
    final picker = ImagePicker();

    final XFile? video =
    await picker.pickVideo(source: ImageSource.camera);

    if (video == null) return;

    setState(() => _isTyping = true);

    try {
      var request = http.MultipartRequest(
        "POST",
        Uri.parse("https://laurie-unhinderable-lucy.ngrok-free.dev/predict"),
      );

      request.files.add(
        await http.MultipartFile.fromPath(
          "video",
          video.path,
        ),
      );

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      final data = jsonDecode(response.body);

      final predictedLabel = data["label"];
      final confidence = data["confidence"];

      setState(() => _isTyping = false);

      if (predictedLabel != null) {
        _inputController.text = predictedLabel;

        _inputController.selection = TextSelection.fromPosition(
          TextPosition(offset: _inputController.text.length),
        );

        _focusNode.requestFocus();
      } else {
        _addNewMessage(ChatMessage(
          text: "Low confidence sign detection. Please try again.",
          isUser: false,
          time: DateTime.now(),
        ));
      }
    } catch (e) {
      setState(() => _isTyping = false);

      _addNewMessage(ChatMessage(
        text: "Sign detection failed.",
        isUser: false,
        time: DateTime.now(),
      ));
    }
  }


  // ── Add a message to the chat + animate it in ─────────────────────────────
  void _addNewMessage(ChatMessage message) {
    setState(() {
      _messages.add(message);
      final controller = _addMessageController();
      // Start animation after frame builds
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.forward();
        _scrollToBottom();
      });
    });
  }

  // ── Bot response simulation (2-second delay) ─────────────────────────────
  void _simulateBotResponse(String userInput) {
    setState(() => _isTyping = true);

    Future.delayed(const Duration(milliseconds: 1800), () {
      if (!mounted) return;
      setState(() => _isTyping = false);

      final botReply = _generateBotReply(userInput);
      _addNewMessage(ChatMessage(
        text: botReply,
        isUser: false,
        time: DateTime.now(),
      ));
    });
  }

  Future<void> _getGeminiResponse(String userInput) async {
    setState(() => _isTyping = true);

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/chat"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"message": userInput}),
      );

      final data = jsonDecode(response.body);
      final botReply = data["reply"];
      final videoUrl = data["video_url"];
      setState(() => _isTyping = false);

      _addNewMessage(ChatMessage(
        text: botReply ?? "Sorry, I couldn't respond.",
        videoUrl: videoUrl,
        isUser: false,
        time: DateTime.now(),
      ));
    } catch (e) {
      setState(() => _isTyping = false);

      _addNewMessage(ChatMessage(
        text: "Backend connection error.",
        isUser: false,
        time: DateTime.now(),
      ));
    }
  }

  String _generateBotReply(String input) {
    final lower = input.toLowerCase();
    if (lower.contains('hello') || lower == 'hello') {
      return "Namaste! In ISL, 'Hello' is signed by raising your right hand with palm facing out and waving gently. Try it! 👋";
    } else if (lower.contains('help')) {
      return "Of course! I can teach you ISL signs for anything. Just type a word or use the camera button to show me a sign. 🤝";
    } else if (lower.contains('thank')) {
      return "You're welcome! Keep practicing — consistency is the key to fluency in ISL. 🌟";
    } else if (lower.contains('bye')) {
      return "Goodbye! In ISL, close all fingers and wave your hand side to side. See you soon! 👋";
    }
    return "I understand '$input'. Would you like to learn the ISL sign for this? Tap the camera icon to show me a sign, or type another word! 🤟";
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 100,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true, // Keyboard pushes chat up
      body: Column(
        children: [
          // ── Top bot header bar ──────────────────────────────────────────
          _buildBotHeader(context),

          // ── Message list ────────────────────────────────────────────────
          Expanded(
            child: _buildMessageList(context),
          ),

          // ── Typing indicator ────────────────────────────────────────────
          if (_isTyping) _buildTypingIndicator(context),

          // ── Input bar ───────────────────────────────────────────────────
          _buildInputBar(context),
        ],
      ),
    );
  }

  // ── Bot header: avatar + name + status ───────────────────────────────────
  Widget _buildBotHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: Row(
            children: [
              // ── Bot avatar ──────────────────────────────────────────────
              Stack(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6C3FF6), Color(0xFF00C9B1)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(10),
                    child: SvgPicture.asset(
                      'assets/svg/bot_avatar.svg',
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  // Online indicator dot
                  Positioned(
                    right: 1,
                    bottom: 1,
                    child: Container(
                      width: 13,
                      height: 13,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.surface, width: 2),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 14),

              // ── Name and status ─────────────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ISL Guide',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            color: Color(0xFF4CAF50),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'Ask me in text or sign',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ── Info button ─────────────────────────────────────────────
              // IconButton(
              //   icon: const Icon(Icons.info_outline_rounded),
              //   color: AppColors.textSecondary,
              //   tooltip: 'About ISL Guide',
              //   onPressed: () {},
              // ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Messages scrollable list ──────────────────────────────────────────────
  Widget _buildMessageList(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        final controller = index < _msgAnimControllers.length
            ? _msgAnimControllers[index]
            : null;

        // Animated slide-in for each message
        if (controller != null) {
          return AnimatedBuilder(
            animation: controller,
            builder: (_, child) {
              final opacity = CurvedAnimation(
                parent: controller,
                curve: Curves.easeOut,
              ).value;
              final slideY = (1.0 - opacity) * 20;
              return Opacity(
                opacity: opacity,
                child: Transform.translate(
                  offset: Offset(0, slideY),
                  child: child,
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: ChatBubble(
                message: message.text,
                isUser: message.isUser,
                isSign: message.isSign,
                timestamp: message.time,
                videoUrl: message.videoUrl,
              ),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: ChatBubble(
            message: message.text,
            videoUrl: message.videoUrl,
            isUser: message.isUser,
            isSign: message.isSign,
            timestamp: message.time,
          ),
        );
      },
    );
  }

  // ── Typing indicator row ─────────────────────────────────────────────────
  Widget _buildTypingIndicator(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.botBubble,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const TypingIndicator(),
        ),
      ),
    );
  }

  // ── Input bar: camera + text + send ──────────────────────────────────────
  Widget _buildInputBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // ── Camera / sign detection button ──────────────────────────
              Semantics(
                label: 'Use camera to detect sign',
                button: true,
                child: TapScaleWidget(
                  onTap: _triggerSignDetection,
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6C3FF6), Color(0xFF00C9B1)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Image.asset(
                      'assets/images/camera.png',
                      fit: BoxFit.contain,
                      // colorFilter: const ColorFilter.mode(
                      //   Colors.white,
                      //   BlendMode.srcIn,
                      // ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              // ── Text input ───────────────────────────────────────────────
              Expanded(
                child: Container(
                  constraints: const BoxConstraints(minHeight: 52),
                  child: TextField(
                    controller: _inputController,
                    focusNode: _focusNode,
                    textInputAction: TextInputAction.send,
                    minLines: 1,
                    maxLines: 4,
                    style: Theme.of(context).textTheme.bodyLarge,
                    onSubmitted: (_) => _sendMessage(),
                    decoration: InputDecoration(
                      hintText: 'Ask anything…',
                      suffixIcon: Icon(
                        Icons.emoji_emotions_outlined,
                        color: AppColors.textSecondary.withOpacity(0.6),
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              // ── Send button ──────────────────────────────────────────────
              Semantics(
                label: 'Send message',
                button: true,
                child: TapScaleWidget(
                  onTap: _sendMessage,
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.35),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: 22,
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
