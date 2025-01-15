
# flutter_sfs (Flutter Screen Font Size)
---
This Flutter package provides a simple and flexible way to adjust font sizes based on screen dimensions. Developers can define a range of minimum and maximum font sizes, and the package automatically calculates the optimal font size according to the screen size. This approach simplifies the creation of responsive and adaptive UIs in Flutter applications.

## Key Features:
* Effortlessly manage text sizes across Mobile, Tablet, and Desktop platforms.
* Set font sizes easily with: `fontSize:` `16.s`, `16.fs('m')`, `16.fs('n', t: 18, d: 20)`, `16.fs('h')`
* Adjust container dimensions with `.h` (height), `.w` (width), and `.r` (radius).
* Simplify spacing between components using `.wbox` and `.hbox`.

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
      desktopSize: const Size(1420, 820),
      fontSizeRange: Range(min: 10, max: 22),
      multiFontSizeRange: {
        's': Range(min: 8, max: 18), // Small text size
        'n': Range(min: 14, max: 24), // Normal text size
        'm': Range(min: 16, max: 26), // Medium text size
        'h': Range(min: 16, max: 28), // Header text size
        'xl': Range(min: 24, max: 38),  // Extra large text size
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
          title: 'flutter_sfs App Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: _
        );
      },
      didChangeSfsMetrics: () {
        TextStyles.didChangeSfsMatrix();
      },
    );
```

#### Use like this for text size:

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

#### Use like this for card height, width or radius:
```dart
Column(
  children: [
    Text(
      "Title",
      style: TextStyle(fontSize: 18.s),
    ),
    15.hbox,
    Container(
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(18.r),
      ),
      height: 100.h,
      width: 100.w,
    ),
  ],
)
```


This ```flutter_sfs``` package is a powerful tool that simplifies font size management in Flutter apps, making it easier to create responsive and adaptive UIs that look visually appealing.
