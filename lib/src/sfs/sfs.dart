import 'package:flutter/material.dart';

import '../../flutter_sfs.dart';

Size defaultMinScrSize = const Size(350, 650);
Size defaultMaxScrSize = const Size(920, 1024);
Size defaultFixedScrSize = const Size(350, 650);
double defaultFontSizeMin = 5;
double defaultFontSizeMax = 50;

class SFS {
  static SizeRange? _sizeRange;
  static late SfsCal _fsc;

  /// Initilize [SizeRange], it's required
  static init(SizeRange sizeRange) {
    _sizeRange = sizeRange;
    _fsc = SfsCal(sizeRange: SFS._sizeRange);
  }

  /// New font size
  static double font(num s) {
    if (_sizeRange != null) {
      double newSize =
          _fsc._fontSize(s.toDouble(), MediaQuery.of(sfsContext).size.width);
      return newSize;
    } else {
      // handle the exception here
      throw Exception("First you required to wrap MaterialApp with 'SFS'.");
    }
  }

  /// New deffirent font size
  static double fontK(String k, num s) {
    if (_sizeRange != null) {
      if (_sizeRange!.multiFontSizeRange != null &&
          _sizeRange!.multiFontSizeRange![k] != null) {
        double newSize = _fsc._fontSizeKey(
            s.toDouble(), MediaQuery.of(sfsContext).size.width, k);
        return newSize;
      } else {
        return s.toDouble();
      }
    } else {
      // handle the exception here
      throw Exception("First you required to wrap MaterialApp with 'SFS'.");
    }
  }
}

class SfsCal {
  final SizeRange? sizeRange;
  SfsCal({this.sizeRange}) {
    initRun();
  }

  late Size _scrMin;
  late Size _scrMax;
  late double _scrWidthPeg;

  ///
  initRun() {
    _scrMin = sizeRange!.screenMinSize ?? defaultMinScrSize;
    _scrMax = sizeRange!.screenMaxSize ?? defaultMaxScrSize;
  }

  double _fontSize(double size, double scr) {
    return _calculate(
      size,
      scr,
      Range(
        min: sizeRange!.fontSizeRange == null
            ? defaultFontSizeMin
            : sizeRange!.fontSizeRange!.min,
        max: sizeRange!.fontSizeRange == null
            ? defaultFontSizeMax
            : sizeRange!.fontSizeRange!.max,
      ),
    );
  }

  double _fontSizeKey(double size, double scr, String key) {
    return _calculate(
      size,
      scr,
      Range(
        min: sizeRange!.multiFontSizeRange![key] == null
            ? defaultFontSizeMin
            : sizeRange!.multiFontSizeRange![key]!.min,
        max: sizeRange!.multiFontSizeRange![key] == null
            ? defaultFontSizeMax
            : sizeRange!.multiFontSizeRange![key]!.max,
      ),
    );
  }

  ///
  double _calculate(double widthSize, double width, Range range) {
    //
    double min = range.min;
    double max = range.max;
    double currentSize = widthSize;

    /// Calculate text percentage
    double widthPeg = ((currentSize - min) * 100) / (max - min);
    //
    double extra = widthPeg - _scrWidthPeg;
    //
    // double newScrPeg = _scrWidthPeg + extra;

    //
    double scrPegX =
        ((width - _scrMin.width) * 100) / (_scrMax.width - _scrMin.width);
    double newScrPegX = scrPegX + extra;

    /// Return new generated font size according to font range (fontSizeRange [Size]) and screen size (screenSize [Range])
    if (newScrPegX >= 1 && newScrPegX <= 100) {
      return (((max - min) * newScrPegX) / 100) + min;
    } else {
      return newScrPegX <= 1 ? min : max;
    }
  }
}
