// ignore_for_file: avoid_print

import 'dart:async';

import 'package:copy/screen/home.dart';
import 'package:copy/service/hive_db.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'helpers/is_debug.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initializing the hive
  // await Hive.initFlutter();
  // Hive.registerAdapter<Todo>(TodoAdapter());
  // await Hive.openBox<Todo>('todo');

  await HiveService.instance.init();
  runApp(
    const MyApp(),
  );

  // This captures errors reported by the Flutter framework.
  FlutterError.onError = (FlutterErrorDetails details) async {
    final dynamic exception = details.exception;
    final StackTrace? stackTrace = details.stack;
    if (isInDebugMode) {
      print('Caught Framework Error!');
      // In development mode simply print to console.
      FlutterError.dumpErrorToConsole(details);
    } else {
      // In production mode report to the application zone
      Zone.current.handleUncaughtError(exception, stackTrace!);
    }
  };
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box>(
        valueListenable: HiveService.instance.getThemeMode().listenable(),
        builder: (context, box, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: HiveService.instance.isDarkTheme(false)
                ? ThemeMode.dark
                : ThemeMode.light,
            theme: ThemeData(
              primaryColor: Colors.lightBlue,
              splashColor: Colors.blueAccent,
              cardColor: Colors.grey.shade300,
              backgroundColor: Colors.white,
              textTheme: const TextTheme(
                titleLarge: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                titleMedium: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(92, 0, 0, 0),
                ),
                titleSmall: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
                bodyMedium: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            ),
            darkTheme: ThemeData(
              primaryColor: Colors.grey.shade900,
              splashColor: Colors.grey.shade600,
              cardColor: Colors.white38,
              backgroundColor: Colors.black,
              textTheme: TextTheme(
                titleLarge: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                titleMedium: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                titleSmall: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade100,
                ),
                bodyMedium: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey.shade100,
                ),
              ),
            ),
            home: const Home(),
          );
        });
  }
}
