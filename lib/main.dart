// lib/main.dart
// ISL Connect – Indian Sign Language Detection App

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/main_navigation.dart';
import 'screens/educational_hub_screen.dart';
import 'screens/placeholder_screens.dart';
import 'screens/record_screen.dart';
import 'screens/isl_avatar_screen.dart';
import 'screens/recent_signs_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Hive
  await Hive.initFlutter();
  await Hive.openBox('progressBox');

  /// Lock portrait mode
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  /// System UI styling
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const ISLConnectApp());
}

class ISLConnectApp extends StatefulWidget {
  const ISLConnectApp({super.key});

  /// Called from LanguageSwitcher
  static void setLocale(BuildContext context, Locale locale) {
    final state =
    context.findAncestorStateOfType<_ISLConnectAppState>();
    state?.setLocale(locale);
  }

  @override
  State<ISLConnectApp> createState() => _ISLConnectAppState();
}

class _ISLConnectAppState extends State<ISLConnectApp> {
  Locale _locale = const Locale('en');

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ISL Connect',
      debugShowCheckedModeBanner: false,

      /// Theme
      theme: AppTheme.lightTheme,

      /// Localization
      locale: _locale,
      supportedLocales: const [
        Locale('en'),
        Locale('hi'),
        Locale('mr'),
        Locale('bn'),
      ],

      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      /// Accessibility: clamp text scale
      builder: (context, child) {
        final mediaQuery = MediaQuery.of(context);

        return MediaQuery(
          data: mediaQuery.copyWith(
            textScaler: mediaQuery.textScaler.clamp(
              minScaleFactor: 0.85,
              maxScaleFactor: 1.25,
            ),
          ),
          child: child!,
        );
      },

      /// Initial route
      initialRoute: '/splash',

      /// Routes
      onGenerateRoute: (settings) {
        final args = settings.arguments as Map<String, dynamic>?;

        switch (settings.name) {
          case '/splash':
            return _fadeRoute(const SplashScreen(), settings);

          case '/main':
            return _fadeRoute(const MainNavigation(), settings);

          case '/detection':
            return _slideRoute(const RecordScreen(), settings);

          case '/avatar':
            return _slideRoute(
              AvatarViewerScreen(
                initialCategory: args?['category'] ?? 'actions',
                initialSign: args?['sign'],
              ),
              settings,
            );

          case '/practice':
            return _slideRoute(
              const GenericPlaceholderScreen(
                title: 'Practice Mode',
                icon: Icons.play_circle_fill_rounded,
                color: AppColors.accent,
                description:
                'Interactive sign practice with real-time feedback\nwill be available here once the model is connected.',
              ),
              settings,
            );

          case '/recent':
            return _slideRoute(
              const RecentSignsScreen(),
              settings,
            );

          case '/lessons/alphabets':
          case '/lessons/numbers':
          case '/lessons/daily_actions':
          case '/lessons/emotions':
          case '/lessons/emergency':
          case '/lessons/greetings':
            final args = settings.arguments as Map<String, dynamic>?;
            final title = args?['title'] ?? 'Lesson';
            final color = args?['color'] ?? AppColors.primary;

            return _slideRoute(
              LessonPlaceholderScreen(
                title: title,
                color: color,
              ),
              settings,
            );

          default:
            return _fadeRoute(
              const Scaffold(
                body: Center(
                  child: Text('Page not found'),
                ),
              ),
              settings,
            );
        }
      },
    );
  }

  /// Fade transition
  static PageRoute _fadeRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, __, ___) => page,
      transitionDuration: const Duration(milliseconds: 350),
      reverseTransitionDuration: const Duration(milliseconds: 250),
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(
          opacity:
          CurvedAnimation(parent: animation, curve: Curves.easeOut),
          child: child,
        );
      },
    );
  }

  /// Slide transition
  static PageRoute _slideRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, __, ___) => page,
      transitionDuration: const Duration(milliseconds: 380),
      reverseTransitionDuration: const Duration(milliseconds: 280),
      transitionsBuilder: (_, animation, __, child) {
        final slide = Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          ),
        );

        final fade =
        CurvedAnimation(parent: animation, curve: Curves.easeOut);

        return SlideTransition(
          position: slide,
          child: FadeTransition(
            opacity: fade,
            child: child,
          ),
        );
      },
    );
  }
}