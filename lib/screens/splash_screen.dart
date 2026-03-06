// ─────────────────────────────────────────────────────────────────────────────
// lib/screens/splash_screen.dart  (localized)
// ─────────────────────────────────────────────────────────────────────────────
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/localization_ext.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoOpacity, _logoScale, _subtitleOpacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 2200));
    _logoOpacity    = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.45, curve: Curves.easeOut)));
    _logoScale      = Tween<double>(begin: 0.78, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.50, curve: Curves.easeOutBack)));
    _subtitleOpacity= Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.40, 0.80, curve: Curves.easeOut)));
    _controller.forward();
    Future.delayed(const Duration(milliseconds: 2800), () { if (mounted) Navigator.of(context).pushReplacementNamed('/main'); });
  }

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity, height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
              colors: [Color(0xFF1E5ED4), Color(0xFF3F6AF6), Color(0xFF00B4D8)], stops: [0.0, 0.55, 1.0]),
        ),
        child: SafeArea(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 3),
                Opacity(
                  opacity: _logoOpacity.value,
                  child: Transform.scale(
                    scale: _logoScale.value,
                    child: Container(
                      width: 320, height: 320,
                      decoration: BoxDecoration(
                        color: Colors.white, borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 20, offset: const Offset(0, 10))],
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Image.asset('assets/images/gespy_logo_final.png', fit: BoxFit.contain),
                    ),
                  ),
                ),
                const Spacer(flex: 3),
                Opacity(
                  opacity: _subtitleOpacity.value,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Text(
                      context.l10n.splashBranding,
                      style: TextStyle(fontFamily: 'Nunito', fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white.withOpacity(0.5), letterSpacing: 2),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}