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

extension FontSizeExtension on num {
  /// Font size default extension [fs], it's provides responsive font size, according to fontSizeRange of [SfsInitBuilder] builder.
  double get s => SFS.font(this);

  /// Font size with key extension [fsKey], helps access custom-created [multiFontSizeRange] font size by passing the key.
  double fsKey(String k) => SFS.fontK(k, this);

  /// Font size with key extension [font], if you want to also define text size for Desktop and Tablet, you can pass for all text sizes by [fontMulti] extension.
  /// t: for Tablet
  double fs(String k, {double? t, double? d}) =>
      SFS.fontMulti(k, this, t: t, d: d);
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
  final Size? mobileSize;
  final Size? tabletSize;
  final Size? desktopSize;

  /// * Minimum and Maximum font size [fontSizeRange]
  final Range? fontSizeRange;
  final Map<String, Range>? multiFontSizeRange;

  /// Range Divder for Mobile, Tablete, and Desktop
  final DivideRange? divideRange;

  /// * Card range
  // final CardRange? cardWidgetRange;

  //
  SizeRange({
    this.screenMinSize,
    this.screenMaxSize,
    this.mobileSize,
    this.tabletSize,
    this.desktopSize,
    this.fontSizeRange,
    this.multiFontSizeRange,
    // this.cardWidgetRange,
    this.divideRange,
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

// Range Divder for Mobile, Tablete, and Desktop
class DivideRange {
  final Range? pergMob; // for mobile
  final Range? pergTab; // for tablet
  final Range? pergDesk; // for desktop
  DivideRange({this.pergMob, this.pergTab, this.pergDesk});
}
