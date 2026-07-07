# 🌍 flutter_sfs (Flutter Screen Font Size)
---
A simple, highly performant, and flexible package to create **Responsive Flutter UIs** with zero boilerplate.


Say goodbye to injecting `MediaQuery.of(context)` into every widget! `flutter_sfs` uses elegant Dart extensions (`.s`, `.w`, `.h`, `.p`) to automatically scale text, dimensions, and padding across Mobile, Tablet, and Desktop screens dynamically.


## 💡 Why choose `flutter_sfs`?
* **O(1) Memory Performance:** Computes simple mathematical ratios instead of generating massive `InheritedWidget` wrapper trees found in other layout packages.
* **Debounced Window Resizing:** Optimizes desktop and web resizing out-of-the-box so your app never freezes or drops frames when users drag the window.
* **Incredible Syntax Brevity:** Writing `padding: 16.p` is massively faster and cleaner than writing `EdgeInsets.all(MediaQuery.of(context).size.width * 0.05)`.
* **Accessibility Native:** Built-in `respectSystemTextScale` safely multiply outputs against system accessibility sliders ensuring visually impaired users aren't left behind.


---


## 🚀 Getting Started (It's this easy!)


### 1. Install
Add `flutter_sfs` to your `pubspec.yaml`:
```yaml
dependencies:
 flutter_sfs: latest
```


### 2. Initialize (Wrap your App once)
Wrap your `MaterialApp` with `SfsInitBuilder`. This sets the baseline dimensions for scaling!
```dart
import 'package:flutter_sfs/flutter_sfs.dart';


void main() => runApp(const MyApp());


class MyApp extends StatelessWidget {
 @override
 Widget build(BuildContext context) {
   return SfsInitBuilder(
     mobileSize: const Size(360, 650),     // Baseline mobile scope
     tabletSize: const Size(481, 890),     // Baseline tablet scope
     desktopSize: const Size(1420, 820),   // Baseline desktop scope
     respectSystemTextScale: true,         // Allows phone accessibility to scale text
     orientationAware: true,               // Safely calculates sideways screen dimensions
     builder: (context, child) {
       return MaterialApp(
         title: 'flutter_sfs App',
         home: HomeScreen(),
       );
     },
     didChangeSfsMetrics: () {
       // Callback functionality when window rescales
     },
   );
 }
}
```


### 3. Use Extensions Anywhere safely
You can now use responsive extensions globally:
```dart
Container(
 padding: 16.p, // Responsive EdgeInsets.all
 width: 100.w, // Responsive width
 height: 50.h, // Responsive height
 decoration: BoxDecoration(
   borderRadius: BorderRadius.circular(12.r), // Responsive corner radius
 ),
 child: Text(
   "Hello World",
   style: TextStyle(fontSize: 18.s), // Responsive text size!
 ),
)
```


---


## 🛠 Extension Cheat Sheet


Here are all the powerful `num` extensions available instantly:


| Extension | Returns | Description |
|-----------|---------|-------------|
| **`16.s`** | `double` | Automatic auto-scaled **font size**. |
| **`16.w`** | `double` | Auto-scaled screen **width / radius**. |
| **`16.fw(t, d)`** | `double` | Scaled **width** with explicit tablet/desktop size. |
| **`16.h`** | `double` | Auto-scaled screen **height**. |
| **`16.fh(t, d)`** | `double` | Scaled **height** with explicit tablet/desktop size. |
| **`16.p`** | `EdgeInsets` | Scaled `EdgeInsets.all()`. |
| **`16.ph`** | `EdgeInsets` | Scaled `EdgeInsets.symmetric(horizontal: 16.w)`. |
| **`16.pv`** | `EdgeInsets` | Scaled `EdgeInsets.symmetric(vertical: 16.h)`. |
| **`16.wbox`** | `Widget` | Empty structured `SizedBox(width: 16.w)`. |
| **`16.hbox`** | `Widget` | Empty structured `SizedBox(height: 16.h)`. |


### Advanced Features


**Custom Breakpoint Text Keys `.fs()`**
If you defined custom text sizes in the `SfsInitBuilder`, reference them by key:
```dart
Text("Medium text", style: TextStyle(fontSize: 16.fs('m')));
Text("Huge text", style: TextStyle(fontSize: 16.fs('xl')));
```


**Explicit Device Constraints `.v()`**
Sometimes, you just want to completely skip math and hardcode layout responses per device:
```dart
// Returns 100 on Mobile, 150 on Tablet, 200 on Desktop universally
Container(height: 100.v(m: 100, t: 150, d: 200));
```

**Explicit Dimension Constraints `.fw()` and `.fh()`**
Similar to `.v()`, but specifically for width/height scaling where you can fallback to the auto-scaled dimension if the tablet/desktop explicit size isn't provided:
```dart
// Auto-scales width from 100 on mobile, but uses exactly 150 on tablet and 200 on desktop
Container(width: 100.fw(t: 150, d: 200));
```


**Sliver Adapters**
Responsive spacing straight into your `CustomScrollView`:
```dart
SliverList(delegate: ...)
20.hSliverBox, // SliverToBoxAdapter(SizedBox(height...))
SliverList(delegate: ...)
```


---


## 👑 Pro Tip: Global ThemeData Integration


To make scaling automatic across an entire app, define an `AppTheme` and inject it inside the `SfsInitBuilder`. This causes your global UI to dynamically recalculate instantly every time window sizes pivot!


```dart
class AppTheme {
 static ThemeData get lightTheme {
   return ThemeData(
     // Configure everything responsive centrally
     textTheme: TextTheme(
       displayLarge: TextStyle(fontSize: 32.s, fontWeight: FontWeight.bold),
       bodyLarge: TextStyle(fontSize: 16.s),
       labelLarge: TextStyle(fontSize: 16.fs('btn')),
     ),
     elevatedButtonTheme: ElevatedButtonThemeData(
       style: ElevatedButton.styleFrom(
         padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
       )
     )
   );
 }
}


// In main.dart -> builder:
return MaterialApp(
 theme: AppTheme.lightTheme, // Theme dynamically reacts to resized screens automatically!
 home: ...,
);
```


Enjoy building beautiful, ultra-fast, responsive UIs easily!



