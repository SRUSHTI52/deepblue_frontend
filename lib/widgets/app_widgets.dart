// lib/widgets/app_widgets.dart
// Reusable UI building blocks for ISL Connect
// All widgets prioritize accessibility: large tap targets, high contrast, semantic labels

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
/// Animated tap wrapper that scales down on press for tactile feedback.
/// Used for all interactive cards and buttons throughout the app.
// ─────────────────────────────────────────────────────────────────────────────
class TapScaleWidget extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final double scaleTo;
  final Duration duration;

  const TapScaleWidget({
    super.key,
    required this.child,
    required this.onTap,
    this.scaleTo = 0.96,
    this.duration = const Duration(milliseconds: 120),
  });

  @override
  State<TapScaleWidget> createState() => _TapScaleWidgetState();
}

class _TapScaleWidgetState extends State<TapScaleWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _scaleAnim = Tween<double>(begin: 1.0, end: widget.scaleTo).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) => _controller.forward();
  void _onTapUp(TapUpDetails _) {
    _controller.reverse();
    widget.onTap();
  }
  void _onTapCancel() => _controller.reverse();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnim,
        builder: (_, child) => Transform.scale(
          scale: _scaleAnim.value,
          child: child,
        ),
        child: widget.child,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
/// FadeSlide entrance animation. Fades in while sliding up from offset.
/// Used for staggered list/grid entries across screens.
// ─────────────────────────────────────────────────────────────────────────────
class FadeSlideIn extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final double slideOffset; // Pixels to slide from (downward)

  const FadeSlideIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 500),
    this.slideOffset = 30.0,
  });

  @override
  State<FadeSlideIn> createState() => _FadeSlideInState();
}

class _FadeSlideInState extends State<FadeSlideIn>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _slide = Tween<Offset>(
      begin: Offset(0, widget.slideOffset),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    // Wait for delay then play entrance
    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) => Opacity(
        opacity: _opacity.value,
        child: Transform.translate(
          offset: _slide.value,
          child: child,
        ),
      ),
      child: widget.child,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
/// Category card used in the Educational Hub grid.
/// Accepts either a PNG image asset (imageAsset) or SVG (svgAsset).
/// When imageAsset is provided it takes priority over svgAsset.
// ─────────────────────────────────────────────────────────────────────────────
class CategoryCard extends StatefulWidget {
  final String title;
  final Color color;
  final VoidCallback onTap;

  /// PNG asset path, e.g. 'assets/images/c1-removebg-preview.png'
  final String? imageAsset;

  /// SVG asset path (used as fallback when imageAsset is null)
  final String? svgAsset;

  const CategoryCard({
    super.key,
    required this.title,
    required this.color,
    required this.onTap,
    this.imageAsset,
    this.svgAsset,
  }) : assert(
  imageAsset != null || svgAsset != null,
  'Provide either imageAsset or svgAsset',
  );

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  bool _pressed = false;

  // ── Decide which widget to render inside the icon box ────────────────────
  Widget _buildIconWidget() {
    if (widget.imageAsset != null) {
      // PNG: remove-bg image fills the rounded container
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          widget.imageAsset!,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Icon(
            Icons.sign_language_rounded,
            color: widget.color,
            size: 32,
          ),
        ),
      );
    }
    // SVG fallback
    return SvgPicture.asset(
      widget.svgAsset!,
      colorFilter: ColorFilter.mode(widget.color, BlendMode.srcIn),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '${widget.title} category. Tap to learn signs.',
      button: true,
      child: TapScaleWidget(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(_pressed ? 0.25 : 0.12),
                blurRadius: _pressed ? 20 : 12,
                offset: Offset(0, _pressed ? 8 : 4),
              ),
            ],
            border: Border.all(
              color: widget.color.withOpacity(0.15),
              width: 1.5,
            ),
          ),
          child: GestureDetector(
            onTapDown: (_) => setState(() => _pressed = true),
            onTapUp: (_) => setState(() => _pressed = false),
            onTapCancel: () => setState(() => _pressed = false),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ── Icon / image box ──────────────────────────────────────
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: widget.color.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    padding: widget.imageAsset != null
                        ? const EdgeInsets.all(6)
                        : const EdgeInsets.all(14),
                    child: _buildIconWidget(),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
/// Small feature shortcut card (Practice Mode, Recent Signs, etc.)
// ─────────────────────────────────────────────────────────────────────────────
class SmallFeatureCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const SmallFeatureCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$title. Tap to open.',
      button: true,
      child: TapScaleWidget(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          decoration: BoxDecoration(
            color: color.withOpacity(0.10),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withOpacity(0.2), width: 1.5),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
              const Spacer(),
              Icon(Icons.arrow_forward_ios_rounded,
                  size: 14, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
/// Typing indicator with animated pulsing dots (for chatbot screen)
// ─────────────────────────────────────────────────────────────────────────────
class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with TickerProviderStateMixin {
  final List<AnimationController> _controllers = [];
  final List<Animation<double>> _animations = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 3; i++) {
      final controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      );
      final animation = Tween<double>(begin: 0.3, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );
      _controllers.add(controller);
      _animations.add(animation);

      // Stagger each dot's animation by 200ms
      Future.delayed(Duration(milliseconds: i * 200), () {
        if (mounted) controller.repeat(reverse: true);
      });
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        return AnimatedBuilder(
          animation: _animations[i],
          builder: (_, __) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: 9,
            height: 9,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(_animations[i].value),
              shape: BoxShape.circle,
            ),
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
/// Chat message bubble (supports both user and bot messages)
// ─────────────────────────────────────────────────────────────────────────────
class ChatBubble extends StatelessWidget {
  final String message;
  final bool isUser;
  final bool isSign; // true if the message represents a sign
  final DateTime timestamp;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isUser,
    this.isSign = false,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: isUser ? 'You said: $message' : 'Bot says: $message',
      child: Align(
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          margin: EdgeInsets.only(
            top: 4,
            bottom: 4,
            left: isUser ? 60 : 0,
            right: isUser ? 0 : 60,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isUser ? AppColors.userBubble : AppColors.botBubble,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(20),
              topRight: const Radius.circular(20),
              bottomLeft: isUser ? const Radius.circular(20) : const Radius.circular(4),
              bottomRight: isUser ? const Radius.circular(4) : const Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: (isUser ? AppColors.primary : AppColors.primary)
                    .withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sign badge
              if (isSign) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  margin: const EdgeInsets.only(bottom: 6),
                  decoration: BoxDecoration(
                    color: (isUser ? Colors.white : AppColors.primary)
                        .withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.sign_language_rounded,
                        size: 12,
                        color: isUser
                            ? AppColors.textOnPrimary.withOpacity(0.8)
                            : AppColors.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Sign Detected',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: isUser
                              ? AppColors.textOnPrimary.withOpacity(0.8)
                              : AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              Text(
                message,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: isUser
                      ? AppColors.userBubbleText
                      : AppColors.botBubbleText,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import '../theme/app_theme.dart';
//
// // ─────────────────────────────────────────────────────────────────────────────
// /// Animated tap wrapper that scales down on press for tactile feedback.
// /// Used for all interactive cards and buttons throughout the app.
// // ─────────────────────────────────────────────────────────────────────────────
// class TapScaleWidget extends StatefulWidget {
//   final Widget child;
//   final VoidCallback onTap;
//   final double scaleTo;
//   final Duration duration;
//
//   const TapScaleWidget({
//     super.key,
//     required this.child,
//     required this.onTap,
//     this.scaleTo = 0.96,
//     this.duration = const Duration(milliseconds: 120),
//   });
//
//   @override
//   State<TapScaleWidget> createState() => _TapScaleWidgetState();
// }
//
// class _TapScaleWidgetState extends State<TapScaleWidget>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _scaleAnim;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(vsync: this, duration: widget.duration);
//     _scaleAnim = Tween<double>(begin: 1.0, end: widget.scaleTo).animate(
//       CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
//     );
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   void _onTapDown(TapDownDetails _) => _controller.forward();
//   void _onTapUp(TapUpDetails _) {
//     _controller.reverse();
//     widget.onTap();
//   }
//   void _onTapCancel() => _controller.reverse();
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTapDown: _onTapDown,
//       onTapUp: _onTapUp,
//       onTapCancel: _onTapCancel,
//       child: AnimatedBuilder(
//         animation: _scaleAnim,
//         builder: (_, child) => Transform.scale(
//           scale: _scaleAnim.value,
//           child: child,
//         ),
//         child: widget.child,
//       ),
//     );
//   }
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// /// FadeSlide entrance animation. Fades in while sliding up from offset.
// /// Used for staggered list/grid entries across screens.
// // ─────────────────────────────────────────────────────────────────────────────
// class FadeSlideIn extends StatefulWidget {
//   final Widget child;
//   final Duration delay;
//   final Duration duration;
//   final double slideOffset; // Pixels to slide from (downward)
//
//   const FadeSlideIn({
//     super.key,
//     required this.child,
//     this.delay = Duration.zero,
//     this.duration = const Duration(milliseconds: 500),
//     this.slideOffset = 30.0,
//   });
//
//   @override
//   State<FadeSlideIn> createState() => _FadeSlideInState();
// }
//
// class _FadeSlideInState extends State<FadeSlideIn>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _opacity;
//   late Animation<Offset> _slide;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(vsync: this, duration: widget.duration);
//     _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _controller, curve: Curves.easeOut),
//     );
//     _slide = Tween<Offset>(
//       begin: Offset(0, widget.slideOffset),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
//
//     // Wait for delay then play entrance
//     Future.delayed(widget.delay, () {
//       if (mounted) _controller.forward();
//     });
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _controller,
//       builder: (_, child) => Opacity(
//         opacity: _opacity.value,
//         child: Transform.translate(
//           offset: _slide.value,
//           child: child,
//         ),
//       ),
//       child: widget.child,
//     );
//   }
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// /// Category card used in the Educational Hub grid.
// /// Displays an SVG icon, label, and animated press state.
// // ─────────────────────────────────────────────────────────────────────────────
// class CategoryCard extends StatefulWidget {
//   final String title;
//   final String imageAsset;
//   final Color color;
//   final VoidCallback onTap;
//
//   const CategoryCard({
//     super.key,
//     required this.title,
//     required this.imageAsset,
//     required this.color,
//     required this.onTap,
//   });
//
//   @override
//   State<CategoryCard> createState() => _CategoryCardState();
// }
//
// class _CategoryCardState extends State<CategoryCard> {
//   bool _pressed = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Semantics(
//       label: '${widget.title} category. Tap to learn signs.',
//       button: true,
//       child: TapScaleWidget(
//         onTap: widget.onTap,
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 150),
//           decoration: BoxDecoration(
//             color: AppColors.surface,
//             borderRadius: BorderRadius.circular(24),
//             boxShadow: [
//               BoxShadow(
//                 color: widget.color.withOpacity(_pressed ? 0.25 : 0.12),
//                 blurRadius: _pressed ? 20 : 12,
//                 offset: Offset(0, _pressed ? 8 : 4),
//               ),
//             ],
//             border: Border.all(
//               color: widget.color.withOpacity(0.15),
//               width: 1.5,
//             ),
//           ),
//           child: GestureDetector(
//             onTapDown: (_) => setState(() => _pressed = true),
//             onTapUp: (_) => setState(() => _pressed = false),
//             onTapCancel: () => setState(() => _pressed = false),
//             child: Padding(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   // Icon container with soft background
//                   Container(
//                     width: 68,
//                     height: 68,
//                     decoration: BoxDecoration(
//                       color: widget.color.withOpacity(0.12),
//                       borderRadius: BorderRadius.circular(18),
//                     ),
//                     padding: const EdgeInsets.all(14),
//                     child: Image.asset(
//                         widget.imageAsset,
//                         fit: BoxFit.contain,
//                       ),
//                   ),
//                   const SizedBox(height: 12),
//                   Text(
//                     widget.title,
//                     textAlign: TextAlign.center,
//                     style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                       color: AppColors.textPrimary,
//                       fontWeight: FontWeight.w700,
//                     ),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// /// Small feature shortcut card (Practice Mode, Recent Signs, etc.)
// // ─────────────────────────────────────────────────────────────────────────────
// class SmallFeatureCard extends StatelessWidget {
//   final String title;
//   final IconData icon;
//   final Color color;
//   final VoidCallback onTap;
//
//   const SmallFeatureCard({
//     super.key,
//     required this.title,
//     required this.icon,
//     required this.color,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Semantics(
//       label: '$title. Tap to open.',
//       button: true,
//       child: TapScaleWidget(
//         onTap: onTap,
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
//           decoration: BoxDecoration(
//             color: color.withOpacity(0.10),
//             borderRadius: BorderRadius.circular(20),
//             border: Border.all(color: color.withOpacity(0.2), width: 1.5),
//           ),
//           child: Row(
//             children: [
//               Container(
//                 width: 44,
//                 height: 44,
//                 decoration: BoxDecoration(
//                   color: color.withOpacity(0.15),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Icon(icon, color: color, size: 24),
//               ),
//               const SizedBox(width: 12),
//               Text(
//                 title,
//                 style: Theme.of(context).textTheme.titleSmall?.copyWith(
//                   color: AppColors.textPrimary,
//                   fontWeight: FontWeight.w700,
//                   fontSize: 15,
//                 ),
//               ),
//               const Spacer(),
//               Icon(Icons.arrow_forward_ios_rounded,
//                   size: 14, color: AppColors.textSecondary),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// /// Typing indicator with animated pulsing dots (for chatbot screen)
// // ─────────────────────────────────────────────────────────────────────────────
// class TypingIndicator extends StatefulWidget {
//   const TypingIndicator({super.key});
//
//   @override
//   State<TypingIndicator> createState() => _TypingIndicatorState();
// }
//
// class _TypingIndicatorState extends State<TypingIndicator>
//     with TickerProviderStateMixin {
//   final List<AnimationController> _controllers = [];
//   final List<Animation<double>> _animations = [];
//
//   @override
//   void initState() {
//     super.initState();
//     for (int i = 0; i < 3; i++) {
//       final controller = AnimationController(
//         vsync: this,
//         duration: const Duration(milliseconds: 600),
//       );
//       final animation = Tween<double>(begin: 0.3, end: 1.0).animate(
//         CurvedAnimation(parent: controller, curve: Curves.easeInOut),
//       );
//       _controllers.add(controller);
//       _animations.add(animation);
//
//       // Stagger each dot's animation by 200ms
//       Future.delayed(Duration(milliseconds: i * 200), () {
//         if (mounted) controller.repeat(reverse: true);
//       });
//     }
//   }
//
//   @override
//   void dispose() {
//     for (final c in _controllers) {
//       c.dispose();
//     }
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: List.generate(3, (i) {
//         return AnimatedBuilder(
//           animation: _animations[i],
//           builder: (_, __) => Container(
//             margin: const EdgeInsets.symmetric(horizontal: 3),
//             width: 9,
//             height: 9,
//             decoration: BoxDecoration(
//               color: AppColors.primary.withOpacity(_animations[i].value),
//               shape: BoxShape.circle,
//             ),
//           ),
//         );
//       }),
//     );
//   }
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// /// Chat message bubble (supports both user and bot messages)
// // ─────────────────────────────────────────────────────────────────────────────
// class ChatBubble extends StatelessWidget {
//   final String message;
//   final bool isUser;
//   final bool isSign; // true if the message represents a sign
//   final DateTime timestamp;
//
//   const ChatBubble({
//     super.key,
//     required this.message,
//     required this.isUser,
//     this.isSign = false,
//     required this.timestamp,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Semantics(
//       label: isUser ? 'You said: $message' : 'Bot says: $message',
//       child: Align(
//         alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
//         child: Container(
//           constraints: BoxConstraints(
//             maxWidth: MediaQuery.of(context).size.width * 0.75,
//           ),
//           margin: EdgeInsets.only(
//             top: 4,
//             bottom: 4,
//             left: isUser ? 60 : 0,
//             right: isUser ? 0 : 60,
//           ),
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//           decoration: BoxDecoration(
//             color: isUser ? AppColors.userBubble : AppColors.botBubble,
//             borderRadius: BorderRadius.only(
//               topLeft: const Radius.circular(20),
//               topRight: const Radius.circular(20),
//               bottomLeft: isUser ? const Radius.circular(20) : const Radius.circular(4),
//               bottomRight: isUser ? const Radius.circular(4) : const Radius.circular(20),
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: (isUser ? AppColors.primary : AppColors.primary)
//                     .withOpacity(0.08),
//                 blurRadius: 8,
//                 offset: const Offset(0, 2),
//               )
//             ],
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Sign badge
//               if (isSign) ...[
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//                   margin: const EdgeInsets.only(bottom: 6),
//                   decoration: BoxDecoration(
//                     color: (isUser ? Colors.white : AppColors.primary)
//                         .withOpacity(0.15),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(Icons.sign_language_rounded,
//                         size: 12,
//                         color: isUser
//                             ? AppColors.textOnPrimary.withOpacity(0.8)
//                             : AppColors.primary,
//                       ),
//                       const SizedBox(width: 4),
//                       Text(
//                         'Sign Detected',
//                         style: TextStyle(
//                           fontSize: 10,
//                           fontWeight: FontWeight.w600,
//                           color: isUser
//                               ? AppColors.textOnPrimary.withOpacity(0.8)
//                               : AppColors.primary,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//               Text(
//                 message,
//                 style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                   color: isUser
//                       ? AppColors.userBubbleText
//                       : AppColors.botBubbleText,
//                   fontSize: 15,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
