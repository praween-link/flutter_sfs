
# flutter_sfs (Flutter Screen Font Size)
---
It provides a simple and flexible way to adjust font sizes in Flutter apps based on screen size. The package allows developers to define a range of minimum and maximum font sizes, and automatically calculates the appropriate font size based on the screen size, making it easier to create responsive and adaptive UIs in Flutter.

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
      screenSize: const Size(360, 650), // Fix screen size
      fontSizeRange: Range(min: 8, max: 22), // Range of text size
      
       /// Add multiple range
      multiFontSizeRange: {
        's': Range(min: 6, max: 12), // Small text size
        'n': Range(min: 10, max: 16), // Normal text size
        'm': Range(min: 12, max: 18), // Medium text size
        'h': Range(min: 12, max: 22), // Header text size
        'b': Range(min: 14, max: 18), // Button text size
      },
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
  style: TextStyle(fontSize: 16.fs),
),
```

```dart
Text(
  "Hello, Flutter",
  style: TextStyle(fontSize: 16.fsKey('m')),// Medium text size
),

Text(
  "Hello, Flutter",
  style: TextStyle(fontSize: 16.fsKey('h')),// Header text size
),

Text(
  "Hello, Flutter",
  style: TextStyle(fontSize: 16.fsKey('n')),// Normal text size
),
```
Globle context: ```sfsContext```, screen width: ```sfsWidth```, screen height: ```sfsHeight```.


This ```flutter_sfs``` is a powerful package that simplifies font size handling in Flutter apps, making it easier to create responsive and adaptive UIs that look great.
