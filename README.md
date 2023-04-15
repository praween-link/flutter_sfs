
# flutter_sfs (Flutter Screen Font Size)
---
It provides a simple and flexible way to adjust font sizes in Flutter apps based on screen size. The package allows developers to define a range of minimum and maximum font sizes, and automatically calculates the appropriate font size based on the screen size, making it easier to create responsive and adaptive UIs in Flutter.

And you can easily manage text size on `Mobile`, `Tablet`, and `Desktop`.

## Installing
Add ```flutter_sfs``` to your ```pubspec.yaml``` file:
```dart
dependencies:
  flutter_sfs:
```
Import ```flutter_sfs``` in files that it will be used:
```dart
import 'package:flutter_sfs/flutter_sfs.dart';
```
## Getting started
---
* First wrap MaterialApp with ```SfsInitBuilder```
```dart
SfsInitBuilder(
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
          navigatorKey: sfsNavigatorKey, // Add this, it's required
          title: 'flutter_sfs App Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: 
        );
      },
    );
```

```dart
Text(
  "Hello, Flutter",
  style: TextStyle(fontSize: 16.s),
),
```

```dart
Text(
  "Hello, Flutter",
  style: TextStyle(fontSize: 16.fs('m')),// Medium text size
),

Text(
  "Text side for all Mobile, Tablate and Desktop",
  style: TextStyle(fontSize: 16.fs('n', t: 18, d: 20)),
  // Normal text size (16-> for mobile, 18-> for tablet, 20-> for desktop)
),

Text(
  "Hello, Flutter",
  style: TextStyle(fontSize: 16.fs('h')),// Header text size
),
```
Globle context: ```sfsContext```, screen width: ```sfsWidth```, screen height: ```sfsHeight```.


This ```flutter_sfs``` is a powerful package that simplifies font size handling in Flutter apps, making it easier to create responsive and adaptive UIs that look great.
