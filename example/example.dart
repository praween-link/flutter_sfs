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
      mobileSize: const Size(360, 650),
      tabletSize: const Size(481, 890),
      desktopSize: const Size(360, 650),
      fontSizeRange: Range(min: 10, max: 22),
      multiFontSizeRange: {
        's': Range(min: 8, max: 18), // Small text size
        'n': Range(min: 14, max: 24), // Normal text size
        'm': Range(min: 16, max: 26), // Medium text size
        'h': Range(min: 16, max: 28), // Header text size
        'btn': Range(min: 14, max: 24), // Button text size
      },
      divideRange: DivideRange(
        // Divided range for mobile
        pergMob: Range(min: 0.0, max: 60.0), // %
        // Divided range for tablet
        pergTab: Range(min: 20.0, max: 80.0), // %
        // Divided range for desktop
        pergDesk: Range(min: 35.0, max: 100.0), // %
      ),
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
            style: TextStyle(fontSize: 18.5.s),
          ),
          const Divider(),
          Text(
            "Small text size",
            style: TextStyle(fontSize: 12.fs('s')),
          ),
          Text(
            "Normal text size",
            style: TextStyle(fontSize: 14.fs('n', t: 14, d: 16)),
          ),
          Text(
            "Medium text size",
            style: TextStyle(fontSize: 16.fs('m')),
          ),
          Text(
            "Medium text size",
            style: TextStyle(fontSize: 16.fsKey('m')),
          ),
          Text(
            "Header text size",
            style: TextStyle(fontSize: 16.fsKey('hl')),
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
