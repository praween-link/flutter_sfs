import 'package:flutter/material.dart';
import 'package:flutter_sfs/flutter_sfs.dart';

/// The default fallback minimum font size securely clamped if unconfigured.
double defaultFontSizeMin = 5;

/// The default fallback maximum font size securely clamped if unconfigured.
double defaultFontSizeMax = 50;

/// The core static execution layer mapping mathematical layout calculations.
/// Avoid invoking methods directly; utilize the `num` extensions instead (e.g., `16.s`).
class SFS {
  static SizeRange? _sizeRange;
  static late SfsCal _fsc;

  /// Initializes the foundational mapping engine dynamically utilizing config [SizeRange].
  static void init(SizeRange sizeRange) {
    _sizeRange = sizeRange;
    _fsc = SfsCal(sizeRange: SFS._sizeRange);
  }

  /// Extracts the scaled calculated font size mapping dynamically to `s`.
  static double font(num s) {
    if (_sizeRange != null) {
      double newSize = _fsc._fontSize(s.toDouble(), mq?.size.width ?? 0.0);
      return newSize;
    } else {
      // handle the exception here
      throw Exception("First you required to wrap MaterialApp with 'SFS'.");
    }
  }

  /// Extracts explicit font sizes structurally mapped under string key [k].
  static double fontK(String k, num s) {
    if (_sizeRange != null) {
      if (_sizeRange!.multiFontSizeRange != null &&
          _sizeRange!.multiFontSizeRange![k] != null) {
        double newSize = _fsc._fontSizeKey(s.toDouble(), mq?.size.width ?? 0.0,
            k, Range(min: 100.0, max: 100.0));
        return newSize;
      } else {
        return s.toDouble();
      }
    } else {
      // handle the exception here
      throw Exception("First you required to wrap MaterialApp with 'SFS'.");
    }
  }

  /// Allows developers to explicitly bypass scaled mathematics by defining
  /// exact font metrics matching the target device class globally.
  static double fontMulti(String k, num m, {double? t, double? d}) {
    double newFont = m.toDouble();
    if (t != null || d != null) {
      String screenType = _fsc._currentScreenType();
      if (t != null && screenType == 't') newFont = t;
      if (d != null && screenType == 'd') newFont = d;
    }
    //
    if (_sizeRange != null) {
      if (_sizeRange!.multiFontSizeRange != null &&
          _sizeRange!.multiFontSizeRange![k] != null) {
        double newSize = _fsc._fontSizeKey(
            newFont, mq?.size.width ?? 0.0, k, Range(min: 100.0, max: 100.0));
        return newSize;
      } else {
        return newFont.toDouble();
      }
    } else {
      // handle the exception here
      throw Exception("First you required to wrap MaterialApp with 'SFS'.");
    }
  }

  /// Dynamically maps width boundaries securely enforcing limits.
  static double w(num v) {
    if (_sizeRange != null) {
      return _fsc._getWidth(v.toDouble(), mq?.size.width ?? 0.0);
    } else {
      // handle the exception here
      throw Exception("First you required to wrap MaterialApp with 'SFS'.");
    }
  }

  /// Dynamically maps height boundaries securely enforcing limits.
  static double h(num v) {
    if (_sizeRange != null) {
      return _fsc._getHeight(v.toDouble(), mq?.size.width ?? 0.0);
    } else {
      // handle the exception here
      throw Exception("First you required to wrap MaterialApp with 'SFS'.");
    }
  }

  /// New width with multi-screen support
  static double wMulti(num v, {double? t, double? d}) {
    if (_sizeRange != null) {
      return _fsc._getWidthMulti(v.toDouble(), mq?.size.width ?? 0.0,
          t: t, d: d);
    } else {
      throw Exception("First you required to wrap MaterialApp with 'SFS'.");
    }
  }

  /// New height with multi-screen support
  static double hMulti(num v, {double? t, double? d}) {
    if (_sizeRange != null) {
      return _fsc._getHeightMulti(v.toDouble(), mq?.size.width ?? 0.0,
          t: t, d: d);
    } else {
      throw Exception("First you required to wrap MaterialApp with 'SFS'.");
    }
  }

  /// Get current screen type (m, t, or d)
  static String currentScreenType() {
    if (_sizeRange != null) {
      return _fsc._currentScreenType();
    } else {
      throw Exception("First you required to wrap MaterialApp with 'SFS'.");
    }
  }
}

/// Internal engine coordinating physical screen tracking and dimensional ratios.
class SfsCal {
  final SizeRange? sizeRange;
  SfsCal({this.sizeRange}) {
    initRun();
  }

  late Size _scrMin;
  late Size _scrMax;
  late Size _mobileCurr; //-m mobile
  late Size _tabletCurr; //-m tablet
  late Size _desktopCurr; //-m desktop
  // mobile
  late double _scrWidthPegM;
  // tablet
  late double _scrWidthPegT;
  // desktop
  late double _scrWidthPegD;
  //
  // mobile
  late Range defMobileSize = Range(min: 360, max: 414);
  // tablet
  late Range defTabletSize = Range(min: 768, max: 1024);
  // desktop
  late Range defDesktopSize = Range(min: 1280, max: 1920);

  ///
  void initRun() {
    _scrMin = sizeRange!.screenMinSize ?? const Size(320, 560);
    _scrMax = sizeRange!.screenMaxSize ?? const Size(1920, 1080);
    // mobile
    _mobileCurr = sizeRange!.mobileSize ?? const Size(360, 620);
    // tablet
    _tabletCurr = sizeRange!.tabletSize ?? const Size(720, 860);
    // desktop
    _desktopCurr = sizeRange!.desktopSize ?? const Size(1220, 820);

    /// Calculate Screen width percentage
    // mobile
    _scrWidthPegM = ((_mobileCurr.width - _scrMin.width) * 100) /
        (_scrMax.width - _scrMin.width);
    // tablet
    _scrWidthPegT = ((_tabletCurr.width - _scrMin.width) * 100) /
        (_scrMax.width - _scrMin.width);
    // desktop
    _scrWidthPegD = ((_desktopCurr.width - _scrMin.width) * 100) /
        (_scrMax.width - _scrMin.width);
  }

  /// ======== Calculation of width and height ==============================
  double _getEffectiveWidth(double actualWidth) {
    if (sizeRange?.orientationAware == true &&
        mq?.orientation == Orientation.landscape) {
      double hX = mq?.size.height ?? 0.0;
      return actualWidth > hX ? hX : actualWidth;
    }
    return actualWidth;
  }

  double _getWidth(double v, double widthValue) {
    String type = _currentScreenType();
    double baseWidth = type == 'd'
        ? _desktopCurr.width
        : (type == 't' ? _tabletCurr.width : _mobileCurr.width);
    return v * (_getEffectiveWidth(widthValue) / baseWidth);
  }

  double _getHeight(double v, double heightValue) {
    String type = _currentScreenType();
    double baseHeight = type == 'd'
        ? _desktopCurr.height
        : (type == 't' ? _tabletCurr.height : _mobileCurr.height);
    return v * (_getEffectiveWidth(heightValue) / baseHeight);
  }

  double _getWidthMulti(double v, double widthValue, {double? t, double? d}) {
    String type = _currentScreenType();
    double baseWidth = type == 'd'
        ? _desktopCurr.width
        : (type == 't' ? _tabletCurr.width : _mobileCurr.width);
    double value = v;
    if (type == 't' && t != null) value = t;
    if (type == 'd' && d != null) value = d;
    return value * (_getEffectiveWidth(widthValue) / baseWidth);
  }

  double _getHeightMulti(double v, double heightValue, {double? t, double? d}) {
    String type = _currentScreenType();
    double baseHeight = type == 'd'
        ? _desktopCurr.height
        : (type == 't' ? _tabletCurr.height : _mobileCurr.height);
    double value = v;
    if (type == 't' && t != null) value = t;
    if (type == 'd' && d != null) value = d;
    return value * (_getEffectiveWidth(heightValue) / baseHeight);
  }

  /// =======================================================================

  /// ======== Calculation of text font sizes ===============================

  double _fontSize(double size, double scr) {
    return _calculate(
      size,
      scr,
      sizeRange!.fontSizeRange ??
          Range(min: defaultFontSizeMin, max: defaultFontSizeMax),
    );
  }

  double _fontSizeKey(
    double size,
    double scr,
    String key,
    Range prg,
  ) {
    return _calculate(
      size,
      scr,
      sizeRange!.multiFontSizeRange?[key] ??
          Range(min: defaultFontSizeMin, max: defaultFontSizeMax),
    );
  }

  ///
  double _calculate(double size, double width, Range range) {
    String screenType = _currentScreenType();

    Range pergRange;
    if (screenType == 'm') {
      pergRange =
          sizeRange!.divideRange!.pergMob ?? Range(min: 0.0, max: 100.0);
    } else if (screenType == 't') {
      pergRange =
          sizeRange!.divideRange!.pergTab ?? Range(min: 0.0, max: 100.0);
    } else {
      pergRange =
          sizeRange!.divideRange!.pergDesk ?? Range(min: 0.0, max: 100.0);
    }

    Range newRrange = _getRange(range, pergRange);

//
    double newFontSize = size <= newRrange.min
        ? newRrange.min
        : size >= newRrange.max
            ? newRrange.max
            : size;

    //
    double min = newRrange.min;
    double max = newRrange.max;

    /// Calculate text percentage
    double widthPeg = ((newFontSize - min) * 100.0) / (max - min);
    //
    double extra = widthPeg -
        (screenType == 'm'
            ? _scrWidthPegM
            : screenType == 't'
                ? _scrWidthPegT
                : _scrWidthPegD);
    // double newScrPeg = _scrWidthPeg + extra;

    double effectiveWidth = _getEffectiveWidth(width);
    double scrPegX = ((effectiveWidth - _scrMin.width) * 100.0) /
        (_scrMax.width - _scrMin.width);
    double newScrPegX = scrPegX + extra;

    /// Return new generated font size according to font range (fontSizeRange [Size]) and screen size (screenSize [Range])
    double finalSize;
    if (newScrPegX >= 1 && newScrPegX <= 100.0) {
      finalSize = (((max - min) * newScrPegX) / 100.0) + min;
    } else {
      finalSize = newScrPegX <= 1 ? min : max;
    }

    if (sizeRange?.respectSystemTextScale == true) {
      // ignore: deprecated_member_use
      finalSize *= (mq?.textScaleFactor ?? 1.0);
    }

    return finalSize;
  }

  /// ======================================================================

  String _currentScreenType() {
    double width = _getEffectiveWidth(mq?.size.width ?? 0.0);
    if (width <= 1080 && width >= 720) {
      return 't';
    } else if (width > 1080) {
      return 'd';
    }
    return 'm';
  }

  Range _getRange(Range rangeData, Range perg) => Range(
      min: (((rangeData.max - rangeData.min) * perg.min) / 100) + rangeData.min,
      max:
          (((rangeData.max - rangeData.min) * perg.max) / 100) + rangeData.min);
}
