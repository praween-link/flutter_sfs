import 'package:flutter/material.dart';
import 'package:flutter_sfs/flutter_sfs.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SfsInitBuilder(
      mobileSize: const Size(360, 650),
      tabletSize: const Size(481, 890),
      desktopSize: const Size(1420, 820),
      fontSizeRange: Range(min: 10, max: 22),
      multiFontSizeRange: {
        's': Range(min: 8, max: 18),
        'n': Range(min: 14, max: 24),
        'm': Range(min: 16, max: 26),
        'h': Range(min: 16, max: 28),
        'xl': Range(min: 24, max: 38),
        'btn': Range(min: 14, max: 24),
      },
      divideRange: DivideRange(
        pergMob: Range(min: 0.0, max: 60.0),
        pergTab: Range(min: 20.0, max: 80.0),
        pergDesk: Range(min: 35.0, max: 100.0),
      ),
      builder: (context, child) {
        return MaterialApp(
          title: 'flutter_sfs example',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
            useMaterial3: true,
          ),
          home: const HomeScreen(),
        );
      },

      /// --[didChangeSfsMetrics] This callback listens for changes in the screen size.
      didChangeSfsMetrics: () {
        TextStyles.didChangeSfsMatrix();
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
          Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(18.r),
            ),
            height: 100.w,
            width: 100.w,
          ),
          15.hbox,
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
          Text(
            "From global TextStyle",
            style: TextStyles.medium,
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

class TextStyles {
  TextStyles.didChangeSfsMatrix() {
    _didChanged();
  }

  _didChanged() {
    normal = TextStyle(fontSize: 14.fs('n'));
    medium = TextStyle(fontSize: 14.fs('m'));
    button = TextStyle(fontSize: 14.fs('btn'));
    xlarge = TextStyle(fontSize: 14.fs('xl'));
  }

  static TextStyle normal = TextStyle(fontSize: 14.fs('n'));
  static TextStyle medium = TextStyle(fontSize: 14.fs('m'));
  static TextStyle button = TextStyle(fontSize: 14.fs('btn'));
  static TextStyle xlarge = TextStyle(fontSize: 14.fs('xl'));
}
