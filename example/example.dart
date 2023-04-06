import 'package:flutter/material.dart';
import 'package:flutter_sfs/flutter_sfs.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return SfsInitBuilder(
      screenSize: const Size(360, 650),
      fontSizeRange: Range(min: 8, max: 22),
      multiFontSizeRange: {
        's': Range(min: 6, max: 12), // Small text size
        'n': Range(min: 10, max: 16), // Normal text size
        'm': Range(min: 12, max: 18), // Medium text size
        'h': Range(min: 12, max: 24), // Header text size
        'btn': Range(min: 14, max: 22), // Button text size
      },
      builder: (context, child) {
        return MaterialApp(
          navigatorKey: sfsNavigatorKey,
          title: 'flutter_sfs App Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const HomeScreen(),
        );
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("flutter_sfs App Demo")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Divider(),
          Text(
            "Default text size",
            style: TextStyle(fontSize: 18.fs),
          ),
          const Divider(),
          Text(
            "Small text size",
            style: TextStyle(fontSize: 12.fsKey('s')),
          ),
          Text(
            "Normal text size",
            style: TextStyle(fontSize: 14.fsKey('n')),
          ),
          Text(
            "Medium text size",
            style: TextStyle(fontSize: 16.fsKey('m')),
          ),
          Text(
            "Header text size",
            style: TextStyle(fontSize: 16.fsKey('h')),
          ),
          const Divider(),
          ElevatedButton(
            onPressed: () {
              //
            },
            child: Text(
              "Button Text",
              style: TextStyle(fontSize: 16.fsKey('btn')),
            ),
          ),
        ],
      ),
    );
  }
}
