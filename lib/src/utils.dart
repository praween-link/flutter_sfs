import 'package:flutter/material.dart';

import 'sfs/sfs.dart';

/// Global reference to the current [MediaQueryData] tracked by `SfsInitBuilder`.
MediaQueryData? mq;

/// Quickly provides the current screen width. Returns 0.0 if SFS is uninitialized.
double get sfsWidth => mq?.size.width ?? 0.0;

/// Quickly provides the current screen height. Returns 0.0 if SFS is uninitialized.
double get sfsHeight => mq?.size.height ?? 0.0;

extension FontSizeExtension on num {
  /// Font size default extension [s], it's provides responsive font size, according to fontSizeRange of [SfsInitBuilder] builder.
  double get s => SFS.font(this);

  /// Font size with key extension [fsKey], helps access custom-created [multiFontSizeRange] font size by passing the key.
  double fsKey(String k) => SFS.fontK(k, this);

  /// Font size with key extension [sf], if you want to also define text size for Desktop and Tablet, you can pass for all text sizes by [fontMulti] extension.
  /// t: for Tablet
  double fs(String k, {double? t, double? d}) =>
      SFS.fontMulti(k, this, t: t, d: d);
}

/// Provides responsive scaling for standard layout dimensions like width, height, and radius.
extension CardSizeExtension on num {
  /// Responsive mapped width [w].
  double get w => SFS.w(this);

  /// Responsive mapped height [h].
  double get h => SFS.h(this);

  /// Responsive mapped radius [r]. Functions identically to [w].
  double get r => SFS.w(this);

  /// Empty [SizedBox] scaled mapped width.
  Widget get wbox => SizedBox(width: SFS.w(this));

  /// Empty [SizedBox] scaled mapped height.
  Widget get hbox => SizedBox(height: SFS.h(this));
}

/// =======================================================================
/// Configuration parameters defining the boundaries for layout scaling.
class SizeRange {
  /// The absolute minimum bounds limit the app window operates in.
  final Size? screenMinSize;

  /// The absolute maximum bounds limit the app window operates in.
  final Size? screenMaxSize;

  /// The baseline width / height that mobile designs use statically.
  final Size? mobileSize;

  /// The baseline width / height that tablet designs use statically.
  final Size? tabletSize;

  /// The baseline width / height that desktop designs use statically.
  final Size? desktopSize;

  /// Boundary restriction mapping for general undefined text scaling.
  final Range? fontSizeRange;

  /// Dictionary associating unique named keys (e.g., 'btn', 'h1') to unique font ranges.
  final Map<String, Range>? multiFontSizeRange;

  /// Structural thresholds determining mapping rules between devices.
  final DivideRange? divideRange;

  /// Flag to multiply output font size with the system font scaling overrides (accessibility).
  final bool? respectSystemTextScale;

  /// Flag to treat landscape sizing securely without blowing scaling logic upward.
  final bool? orientationAware;

  SizeRange({
    this.screenMinSize,
    this.screenMaxSize,
    this.mobileSize,
    this.tabletSize,
    this.desktopSize,
    this.fontSizeRange,
    this.multiFontSizeRange,
    this.divideRange,
    this.respectSystemTextScale,
    this.orientationAware,
  });
}

/// A simple domain class representing a min / max restriction pair.
class Range {
  final double min;
  final double max;
  Range({required this.min, required this.max});
}

/// A simple domain defining width and height restrictions.
class CardRange {
  final Range width;
  final Range height;
  CardRange({required this.width, required this.height});
}

/// Percentage-based divisions isolating font scales across different device types.
class DivideRange {
  /// Range boundary threshold for mobile forms
  final Range? pergMob;

  /// Range boundary threshold for tablet forms
  final Range? pergTab;

  /// Range boundary threshold for desktop forms
  final Range? pergDesk;
  DivideRange({this.pergMob, this.pergTab, this.pergDesk});
}

extension PaddingExtension on num {
  /// Font size default padding extension [p], returns [EdgeInsets.all] with responsive width scale
  EdgeInsets get p => EdgeInsets.all(w);

  /// Responsive padding horizontal extension [ph], returns [EdgeInsets.symmetric(horizontal:)]
  EdgeInsets get ph => EdgeInsets.symmetric(horizontal: w);

  /// Responsive padding vertical extension [pv], returns [EdgeInsets.symmetric(vertical:)]
  EdgeInsets get pv => EdgeInsets.symmetric(vertical: h);
}

extension DeviceValueExtension on num {
  /// Responsive explicitly defined device value mapping based on platform breakpoint.
  double v({double? m, double? t, double? d}) {
    String type = SFS.currentScreenType();
    if (type == 'm') return m ?? toDouble();
    if (type == 't') return t ?? m ?? toDouble();
    if (type == 'd') return d ?? t ?? m ?? toDouble();
    return toDouble();
  }
}

extension SliverSizeExtension on num {
  /// Responsive sized SliverToBoxAdapter element with scaled widths.
  Widget get wSliverBox => SliverToBoxAdapter(child: SizedBox(width: w));

  /// Responsive sized SliverToBoxAdapter element with scaled heights.
  Widget get hSliverBox => SliverToBoxAdapter(child: SizedBox(height: h));
}
