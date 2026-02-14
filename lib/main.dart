// lib/main.dart
// ISL Connect – Indian Sign Language Detection App
// Entry point: wires theme, routes, and app-level configuration.
//
// Architecture overview:
//   • SplashScreen → auto-navigates to MainNavigation after 2.8s
//   • MainNavigation holds 3 tabs: Home | Educational Hub | Chatbot
//   • Named routes used throughout for clean separation from backend routes
//
// Accessibility commitments:
//   • textScaleFactor clamped to prevent layout overflow on large fonts
//   • Semantic labels on all interactive widgets
//   • High-contrast theme tokens in AppColors
//   • All tap targets ≥ 48×48dp (Material minimum)

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/main_navigation.dart';
import 'screens/educational_hub_screen.dart';
import 'screens/placeholder_screens.dart';
import 'screens/record_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ── Initialize Hive ────────────────────────────────────────────────
  await Hive.initFlutter();
  await Hive.openBox('progressBox');

  // ── Lock to portrait mode for consistent hand-detection experience ─
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // ── Transparent status bar so gradients bleed to the top edge ───────
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

class ISLConnectApp extends StatelessWidget {
  const ISLConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ISL Connect',
      debugShowCheckedModeBanner: false,

      // ── Theme ────────────────────────────────────────────────────────
      theme: AppTheme.lightTheme,

      // ── Accessibility: clamp text scale ──────────────────────────────
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

      // ── Initial route ────────────────────────────────────────────────
      initialRoute: '/splash',

      // ── Routes ───────────────────────────────────────────────────────
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/splash':
            return _fadeRoute(const SplashScreen(), settings);

          case '/main':
            return _fadeRoute(const MainNavigation(), settings);

          case '/detection':
            return _slideRoute(const RecordScreen(), settings);

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
              const GenericPlaceholderScreen(
                title: 'Recent Signs',
                icon: Icons.history_rounded,
                color: AppColors.primary,
                description:
                'Your detected and practiced signs will be\nlogged and displayed here.',
              ),
              settings,
            );

          case '/lessons/alphabets':
          case '/lessons/numbers':
          case '/lessons/daily_actions':
          case '/lessons/emotions':
          case '/lessons/emergency':
          case '/lessons/greetings':
            final args = settings.arguments as Map<String, dynamic>?;
            final title = args?['title'] as String? ?? 'Lesson';
            final color = args?['color'] as Color? ?? AppColors.primary;
            return _slideRoute(
              LessonPlaceholderScreen(title: title, color: color),
              settings,
            );

          default:
            return _fadeRoute(
              const Scaffold(
                body: Center(child: Text('Page not found')),
              ),
              settings,
            );
        }
      },
    );
  }

  // ── Fade transition ────────────────────────────────────────────────
  static PageRoute _fadeRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, __, ___) => page,
      transitionDuration: const Duration(milliseconds: 350),
      reverseTransitionDuration: const Duration(milliseconds: 250),
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
          child: child,
        );
      },
    );
  }

  // ── Slide-up transition ────────────────────────────────────────────
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
          CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
        );

        final fade =
        CurvedAnimation(parent: animation, curve: Curves.easeOut);

        return SlideTransition(
          position: slide,
          child: FadeTransition(opacity: fade, child: child),
        );
      },
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// import 'theme/app_theme.dart';
// import 'screens/splash_screen.dart';
// import 'screens/main_navigation.dart';
// import 'screens/educational_hub_screen.dart';
// import 'screens/placeholder_screens.dart';
// // ── Your real sign-detection screen (camera + video recording) ──────────────
// import 'screens/record_screen.dart';
//
// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   // Lock to portrait mode for consistent hand-detection experience
//   SystemChrome.setPreferredOrientations([
//     DeviceOrientation.portraitUp,
//     DeviceOrientation.portraitDown,
//   ]);
//
//   // Transparent status bar so gradients bleed to the top edge
//   SystemChrome.setSystemUIOverlayStyle(
//     const SystemUiOverlayStyle(
//       statusBarColor: Colors.transparent,
//       statusBarIconBrightness: Brightness.light,
//       systemNavigationBarColor: Colors.white,
//       systemNavigationBarIconBrightness: Brightness.dark,
//     ),
//   );
//
//   runApp(const ISLConnectApp());
// }
//
// class ISLConnectApp extends StatelessWidget {
//   const ISLConnectApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'ISL Connect',
//       debugShowCheckedModeBanner: false,
//
//       // ── Theme ──────────────────────────────────────────────────────────
//       theme: AppTheme.lightTheme,
//
//       // ── Accessibility: clamp text scale so layouts don't break ─────────
//       builder: (context, child) {
//         final mediaQuery = MediaQuery.of(context);
//         return MediaQuery(
//           data: mediaQuery.copyWith(
//             textScaler: mediaQuery.textScaler.clamp(
//               minScaleFactor: 0.85,
//               maxScaleFactor: 1.25,
//             ),
//           ),
//           child: child!,
//         );
//       },
//
//       // ── Initial route: always start at splash ─────────────────────────
//       initialRoute: '/splash',
//
//       // ── Route table ────────────────────────────────────────────────────
//       onGenerateRoute: (settings) {
//         switch (settings.name) {
//
//         // ── Core screens ────────────────────────────────────────────────
//           case '/splash':
//             return _fadeRoute(const SplashScreen(), settings);
//
//           case '/main':
//             return _fadeRoute(const MainNavigation(), settings);
//
//         // ── Detection workflow → RecordScreen (camera + ISL recording) ────
//         // RecordScreen is your file: lib/screens/record_screen.dart
//         // It opens the front camera, records the sign, then pushes PreviewScreen.
//           case '/detection':
//             return _slideRoute(
//               const RecordScreen(),
//               settings,
//             );
//
//         // ── Practice mode ────────────────────────────────────────────────
//           case '/practice':
//             return _slideRoute(
//               const GenericPlaceholderScreen(
//                 title: 'Practice Mode',
//                 icon: Icons.play_circle_fill_rounded,
//                 color: AppColors.accent,
//                 description:
//                 'Interactive sign practice with real-time feedback\nwill be available here once the model is connected.',
//               ),
//               settings,
//             );
//
//         // ── Recent signs history ─────────────────────────────────────────
//           case '/recent':
//             return _slideRoute(
//               const GenericPlaceholderScreen(
//                 title: 'Recent Signs',
//                 icon: Icons.history_rounded,
//                 color: AppColors.primary,
//                 description:
//                 'Your detected and practiced signs will be\nlogged and displayed here.',
//               ),
//               settings,
//             );
//
//         // ── Individual lesson screens (all categories) ───────────────────
//           case '/lessons/alphabets':
//           case '/lessons/numbers':
//           case '/lessons/daily_actions':
//           case '/lessons/emotions':
//           case '/lessons/emergency':
//           case '/lessons/greetings':
//             final args = settings.arguments as Map<String, dynamic>?;
//             final title = args?['title'] as String? ?? 'Lesson';
//             final color = args?['color'] as Color? ?? AppColors.primary;
//             return _slideRoute(
//               LessonPlaceholderScreen(title: title, color: color),
//               settings,
//             );
//
//         // ── Fallback ─────────────────────────────────────────────────────
//           default:
//             return _fadeRoute(
//               const Scaffold(
//                 body: Center(
//                   child: Text('Page not found'),
//                 ),
//               ),
//               settings,
//             );
//         }
//       },
//     );
//   }
//
//   // ── Smooth fade transition ─────────────────────────────────────────────────
//   static PageRoute _fadeRoute(Widget page, RouteSettings settings) {
//     return PageRouteBuilder(
//       settings: settings,
//       pageBuilder: (_, __, ___) => page,
//       transitionDuration: const Duration(milliseconds: 350),
//       reverseTransitionDuration: const Duration(milliseconds: 250),
//       transitionsBuilder: (_, animation, __, child) {
//         return FadeTransition(
//           opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
//           child: child,
//         );
//       },
//     );
//   }
//
//   // ── Slide-up transition (for detail screens) ───────────────────────────────
//   static PageRoute _slideRoute(Widget page, RouteSettings settings) {
//     return PageRouteBuilder(
//       settings: settings,
//       pageBuilder: (_, __, ___) => page,
//       transitionDuration: const Duration(milliseconds: 380),
//       reverseTransitionDuration: const Duration(milliseconds: 280),
//       transitionsBuilder: (_, animation, __, child) {
//         final slide = Tween<Offset>(
//           begin: const Offset(0, 1),
//           end: Offset.zero,
//         ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
//         final fade = CurvedAnimation(parent: animation, curve: Curves.easeOut);
//         return SlideTransition(
//           position: slide,
//           child: FadeTransition(opacity: fade, child: child),
//         );
//       },
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'screens/record_screen.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'ISL App',
//       home: const RecordScreen(),
//     );
//   }
// }


// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // TRY THIS: Try running your application with "flutter run". You'll see
//         // the application has a purple toolbar. Then, without quitting the app,
//         // try changing the seedColor in the colorScheme below to Colors.green
//         // and then invoke "hot reload" (save your changes or press the "hot
//         // reload" button in a Flutter-supported IDE, or press "r" if you used
//         // the command line to start the app).
//         //
//         // Notice that the counter didn't reset back to zero; the application
//         // state is not lost during the reload. To reset the state, use hot
//         // restart instead.
//         //
//         // This works for code too, not just values: Most code changes can be
//         // tested with just a hot reload.
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//
//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.
//
//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".
//
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;
//
//   void _incrementCounter() {
//     setState(() {
//       // This call to setState tells the Flutter framework that something has
//       // changed in this State, which causes it to rerun the build method below
//       // so that the display can reflect the updated values. If we changed
//       // _counter without calling setState(), then the build method would not be
//       // called again, and so nothing would appear to happen.
//       _counter++;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       appBar: AppBar(
//         // TRY THIS: Try changing the color here to a specific color (to
//         // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
//         // change color while the other colors stay the same.
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: Column(
//           // Column is also a layout widget. It takes a list of children and
//           // arranges them vertically. By default, it sizes itself to fit its
//           // children horizontally, and tries to be as tall as its parent.
//           //
//           // Column has various properties to control how it sizes itself and
//           // how it positions its children. Here we use mainAxisAlignment to
//           // center the children vertically; the main axis here is the vertical
//           // axis because Columns are vertical (the cross axis would be
//           // horizontal).
//           //
//           // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
//           // action in the IDE, or press "p" in the console), to see the
//           // wireframe for each widget.
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
