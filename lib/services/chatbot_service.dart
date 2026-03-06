// lib/screens/chatbot_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_theme.dart';
import '../utils/localization_ext.dart';
import '../widgets/app_widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final bool isSign;
  final DateTime time;
  const ChatMessage({required this.text, required this.isUser, this.isSign = false, required this.time});
}

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});
  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> with TickerProviderStateMixin {
  final List<ChatMessage> _messages = [];
  final List<AnimationController> _msgAnimControllers = [];
  bool _isTyping = false;
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  final String baseUrl = "https://lightfast-diane-gruntled.ngrok-free.dev";

  @override
  void initState() {
    super.initState();
    // Welcome message added after first frame so l10n is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _addNewMessage(ChatMessage(
        text: context.l10n.chatbotWelcome,
        isUser: false,
        time: DateTime.now(),
      ));
    });
  }

  @override
  void dispose() {
    for (final c in _msgAnimControllers) c.dispose();
    _inputController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  AnimationController _addMessageController() {
    final controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 350));
    _msgAnimControllers.add(controller);
    return controller;
  }

  void _sendMessage() {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;
    _addNewMessage(ChatMessage(text: text, isUser: true, time: DateTime.now()));
    _inputController.clear();
    _focusNode.unfocus();
    _getGeminiResponse(text);
  }

  Future<void> _triggerSignDetection() async {
    final picker = ImagePicker();
    final XFile? video = await picker.pickVideo(source: ImageSource.camera);
    if (video == null) return;
    setState(() => _isTyping = true);
    try {
      var request = http.MultipartRequest("POST", Uri.parse("https://laurie-unhinderable-lucy.ngrok-free.dev/predict"));
      request.files.add(await http.MultipartFile.fromPath("video", video.path));
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      final data = jsonDecode(response.body);
      final predictedLabel = data["label"];
      setState(() => _isTyping = false);
      if (predictedLabel != null) {
        _inputController.text = predictedLabel;
        _inputController.selection = TextSelection.fromPosition(TextPosition(offset: _inputController.text.length));
        _focusNode.requestFocus();
      } else {
        _addNewMessage(ChatMessage(text: context.l10n.chatbotLowConfidence, isUser: false, time: DateTime.now()));
      }
    } catch (e) {
      setState(() => _isTyping = false);
      _addNewMessage(ChatMessage(text: context.l10n.chatbotDetectionFailed, isUser: false, time: DateTime.now()));
    }
  }

  void _addNewMessage(ChatMessage message) {
    setState(() {
      _messages.add(message);
      final controller = _addMessageController();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.forward();
        _scrollToBottom();
      });
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
      setState(() => _isTyping = false);
      _addNewMessage(ChatMessage(text: botReply ?? context.l10n.chatbotBackendError, isUser: false, time: DateTime.now()));
    } catch (e) {
      setState(() => _isTyping = false);
      _addNewMessage(ChatMessage(text: context.l10n.chatbotBackendError, isUser: false, time: DateTime.now()));
    }
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
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          _buildBotHeader(context, l10n),
          Expanded(child: _buildMessageList(context)),
          if (_isTyping) _buildTypingIndicator(context),
          _buildInputBar(context, l10n),
        ],
      ),
    );
  }

  Widget _buildBotHeader(BuildContext context, l10n) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [BoxShadow(color: AppColors.shadowColor, blurRadius: 12, offset: const Offset(0, 2))],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: 52, height: 52,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFF6C3FF6), Color(0xFF00C9B1)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))],
                    ),
                    padding: const EdgeInsets.all(10),
                    child: SvgPicture.asset('assets/svg/bot_avatar.svg', colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
                  ),
                  Positioned(
                    right: 1, bottom: 1,
                    child: Container(
                      width: 13, height: 13,
                      decoration: BoxDecoration(color: const Color(0xFF4CAF50), shape: BoxShape.circle, border: Border.all(color: AppColors.surface, width: 2)),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.chatbotTitle, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Container(width: 7, height: 7, decoration: const BoxDecoration(color: Color(0xFF4CAF50), shape: BoxShape.circle)),
                        const SizedBox(width: 5),
                        Text(l10n.chatbotStatus, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageList(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        final controller = index < _msgAnimControllers.length ? _msgAnimControllers[index] : null;
        Widget bubble = Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: ChatBubble(message: message.text, isUser: message.isUser, isSign: message.isSign, timestamp: message.time),
        );
        if (controller != null) {
          return AnimatedBuilder(
            animation: controller,
            builder: (_, child) {
              final opacity = CurvedAnimation(parent: controller, curve: Curves.easeOut).value;
              return Opacity(opacity: opacity, child: Transform.translate(offset: Offset(0, (1.0 - opacity) * 20), child: child));
            },
            child: bubble,
          );
        }
        return bubble;
      },
    );
  }

  Widget _buildTypingIndicator(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(color: AppColors.botBubble, borderRadius: BorderRadius.circular(20)),
          child: const TypingIndicator(),
        ),
      ),
    );
  }

  Widget _buildInputBar(BuildContext context, l10n) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [BoxShadow(color: AppColors.shadowColor.withOpacity(0.5), blurRadius: 20, offset: const Offset(0, -4))],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Semantics(
                label: l10n.chatbotCameraLabel,
                button: true,
                child: TapScaleWidget(
                  onTap: _triggerSignDetection,
                  child: Container(
                    width: 52, height: 52,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFF6C3FF6), Color(0xFF00C9B1)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 3))],
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Image.asset('assets/images/camera.png', fit: BoxFit.contain),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  constraints: const BoxConstraints(minHeight: 52),
                  child: TextField(
                    controller: _inputController,
                    focusNode: _focusNode,
                    textInputAction: TextInputAction.send,
                    minLines: 1, maxLines: 4,
                    style: Theme.of(context).textTheme.bodyLarge,
                    onSubmitted: (_) => _sendMessage(),
                    decoration: InputDecoration(
                      hintText: l10n.chatbotInputHint,
                      suffixIcon: Icon(Icons.emoji_emotions_outlined, color: AppColors.textSecondary.withOpacity(0.6), size: 20),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Semantics(
                label: l10n.chatbotSendLabel,
                button: true,
                child: TapScaleWidget(
                  onTap: _sendMessage,
                  child: Container(
                    width: 52, height: 52,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.35), blurRadius: 10, offset: const Offset(0, 3))],
                    ),
                    child: const Icon(Icons.send_rounded, color: Colors.white, size: 22),
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