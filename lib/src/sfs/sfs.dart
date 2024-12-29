import 'package:flutter/material.dart';
import 'package:flutter_sfs/flutter_sfs.dart';

double defaultFontSizeMin = 5;
double defaultFontSizeMax = 50;

class SFS {
  // static SFS _sfs = SFS();
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
          _fsc._fontSize(s.toDouble(), mq?.size.width ?? 0.0);
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
            s.toDouble(),
            mq?.size.width ?? 0.0,
            k,
            Range(min: 100.0, max: 100.0));
        return newSize;
      } else {
        return s.toDouble();
      }
    } else {
      // handle the exception here
      throw Exception("First you required to wrap MaterialApp with 'SFS'.");
    }
  }

  /// New deffirent font size
  static double fontMulti(String k, num m, {double? t, double? d}) {
    double newFont = m.toDouble();
    if (t != null) {
      newFont = _fsc._currentScreenType() == 't' ? t : newFont;
    }
    if (d != null) {
      newFont = _fsc._currentScreenType() == 'd' ? d : newFont;
    }
    //
    if (_sizeRange != null) {
      if (_sizeRange!.multiFontSizeRange != null &&
          _sizeRange!.multiFontSizeRange![k] != null) {
        double newSize = _fsc._fontSizeKey(
            newFont,
            mq?.size.width ?? 0.0,
            k,
            Range(min: 100.0, max: 100.0));
        return newSize;
      } else {
        return newFont.toDouble();
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
  initRun() {
    _scrMin = sizeRange!.screenMinSize ?? const Size(320, 560);
    _scrMax = sizeRange!.screenMaxSize ?? const Size(1920, 1080);
    // mobile
    _mobileCurr = sizeRange!.mobileSize == null
        ? const Size(360, 620)
        : sizeRange!.mobileSize!;
    // tablet
    _tabletCurr = sizeRange!.tabletSize == null
        ? const Size(720, 860)
        : sizeRange!.tabletSize!;
    // desktop
    _desktopCurr = sizeRange!.desktopSize == null
        ? const Size(1220, 820)
        : sizeRange!.desktopSize!;

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

  double _fontSizeKey(
    double size,
    double scr,
    String key,
    Range prg,
  ) {
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
  double _calculate(double size, double width, Range range) {
    Range newRrange = _currentScreenType() == 'm'
        ? _getRange(range,
            sizeRange!.divideRange!.pergMob ?? Range(min: 0.0, max: 100.0))
        : _currentScreenType() == 't'
            ? _getRange(range,
                sizeRange!.divideRange!.pergTab ?? Range(min: 0.0, max: 100.0))
            : _getRange(
                range,
                sizeRange!.divideRange!.pergDesk ??
                    Range(min: 0.0, max: 100.0));

//
    double newFontSize = size <= newRrange.min
        ? newRrange.min
        : size >= newRrange.max
            ? newRrange.max
            : size;

    //
    double min = newRrange.min;
    double max = newRrange.max;
    double currentSize = newFontSize;

    /// Calculate text percentage
    double widthPeg = ((currentSize - min) * 100.0) / (max - min);
    //
    double extra = widthPeg -
        (_currentScreenType() == 'm'
            ? _scrWidthPegM
            : _currentScreenType() == 't'
                ? _scrWidthPegT
                : _scrWidthPegD);
    // double newScrPeg = _scrWidthPeg + extra;

    double scrPegX =
        ((width - _scrMin.width) * 100.0) / (_scrMax.width - _scrMin.width);
    double newScrPegX = scrPegX + extra;

    /// Return new generated font size according to font range (fontSizeRange [Size]) and screen size (screenSize [Range])
    if (newScrPegX >= 1 && newScrPegX <= 100.0) {
      return (((max - min) * newScrPegX) / 100.0) + min;
    } else {
      return newScrPegX <= 1 ? min : max;
    }
  }

  String _currentScreenType() {
    double width = mq?.size.width ?? 0.0;
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
