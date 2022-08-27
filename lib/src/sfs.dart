import 'package:flutter/material.dart';
///-----///
class ScreenFontSize {
  final BuildContext context;
  final ScreenSize screenSize;
  RangeFontSize? rangeFontSize;
  RangeHV? rangeHV;

  ScreenFontSize(this.context,
      {required this.screenSize, this.rangeFontSize, this.rangeHV});
  double fontsize(double fontSize) {
    if (rangeFontSize != null) {
      double w = MediaQuery.of(context).size.width;
      double persentage = (fontSize / screenSize.width) * w;
      double newFontSize =
          (((rangeFontSize!.max - rangeFontSize!.min) * persentage) / 100) +
              rangeFontSize!.min;
      return newFontSize;
    } else {
      return 0;
    }
  }

  double horizontal(double size) {
    if (rangeHV != null) {
      double w = MediaQuery.of(context).size.width;
      double persentage = (size / screenSize.width) * w;
      double pw =
          (((rangeHV!.max - rangeHV!.min) * persentage) / 100) +
              rangeHV!.min;
      return pw;
    } else {
      return 0;
    }
  }

  double vertical(double size) {
    if (rangeHV != null) {
      double h = MediaQuery.of(context).size.height;
      double persentage = (size / screenSize.width) * h;
      double ph =
          (((rangeHV!.max - rangeHV!.min) * persentage) / 100) +
              rangeHV!.min;
      return ph;
    } else {
      return 0;
    }
  }
}

///
class ScreenSize {
  final double hight, width;
  ScreenSize({required this.hight, required this.width});
}

class RangeFontSize {
  final double min, max;
  RangeFontSize({required this.min, required this.max});
}

class RangeHV {
  final double min;
  final double max;
  RangeHV({required this.min, required this.max});
}
