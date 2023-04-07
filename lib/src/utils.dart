import 'package:flutter/material.dart';

import 'navigator_service.dart';
import 'sfs/sfs.dart';

/// Globle build context [sfsContext]
sfsCtx() {
  try {
    return NavigationService.navigatorKey.currentContext!;
  } catch (e) {
    throw Exception(
        "Required to add sfsNavigatorKey in MaterialApp (navigatorKey: sfsNavigatorKey),");
  }
}

BuildContext get sfsContext => sfsCtx();
double get sfsWidth => MediaQuery.of(sfsContext).size.width;
double get sfsHeight => MediaQuery.of(sfsContext).size.height;

/// GlobalKey NavigatorState
GlobalKey<NavigatorState> get sfsNavigatorKey => NavigationService.navigatorKey;

/// Font size default extension [fs]
/// Font size with key extension [fsKey]
extension FontSizeExtension on num {
  double get fs => SFS.font(this);
  double fsKey(String k) => SFS.fontK(k, this);
}

/// Without range
extension MqWidth on num {}

///=============---=============
class SizeRange {
  /// * Project will be run minimum size of screen [screenMinSize]
  final Size? screenMinSize;

  /// * Project will be run maximum size of screen [screenMaxSize]
  final Size? screenMaxSize;

  /// * Fixed screen size [screenSize]
  final Size? screenSize;

  /// * Minimum and Maximum font size [fontSizeRange]
  final Range? fontSizeRange;
  final Map<String, Range>? multiFontSizeRange;

  /// * Card range
  // final CardRange? cardWidgetRange;

  //
  SizeRange({
    this.screenMinSize,
    this.screenMaxSize,
    this.screenSize,
    this.fontSizeRange,
    this.multiFontSizeRange,
    // this.cardWidgetRange,
  });
}

class Range {
  final double min;
  final double max;
  Range({required this.min, required this.max});
}

class CardRange {
  final Range width;
  final Range height;
  CardRange({required this.width, required this.height});
}
