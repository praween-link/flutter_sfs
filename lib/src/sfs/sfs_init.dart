import 'package:flutter/material.dart';
import 'package:flutter_sfs/flutter_sfs.dart';

typedef RebuildFactor = bool Function(
    MediaQueryData oldMediaQueryData, MediaQueryData newMediaQueryData);

typedef SfsBuilder = Widget Function(
  BuildContext context,
  Widget? child,
);

class RebuildFactors {
  const RebuildFactors._();

  static bool size(MediaQueryData old, MediaQueryData data) {
    return old.size != data.size;
  }
}

// Stateful widget
class SfsInitBuilder extends StatefulWidget {
  const SfsInitBuilder({
    super.key,
    required this.builder,
    this.child,
    this.rebuildFactor = RebuildFactors.size,
    this.mobileSize = const Size(350, 650),
    this.tabletSize = const Size(490, 890),
    this.desktopSize = const Size(1420, 820),
    this.scaleByHeight = false,
    this.fontSizeRange,
    this.multiFontSizeRange,
    this.screenMinSize, //const Size(350, 650),
    this.screenMaxSize, //const Size(920, 1024),
    this.divideRange,
    this.didChangeSfsMetrics,
  });
  final SfsBuilder builder;
  final Widget? child;
  final RebuildFactor rebuildFactor;
  final bool scaleByHeight;

  /// Define your fix [mobileSize], this size of device take your exact font size from code.
  final Size mobileSize;

  /// Define your fix [tabletSize], this size of device take your exact font size from code.
  final Size tabletSize;

  /// Define your fix [desktopSize], this size of device take your exact font size from code.
  final Size desktopSize;
  final Range? fontSizeRange;

  /// Create your custom different font size key, where pass data in map [multiFontSizeRange] required key and Range of your text size.
  final Map<String, Range>? multiFontSizeRange;
  final Size? screenMinSize;
  final Size? screenMaxSize;

  /// --[didChangeSfsMetrics] This callback listens for changes in the screen size.
  final void Function()? didChangeSfsMetrics;

  /// When you create an app for Mobile, Tablet, and Desktop for a better responsive app,
  /// you need to define this [percentUse] for the range of font size, get from your custom font size range by percentage.

  /// m: Mobile - (Range min: 0%, max: 60%)
  /// t: Tablet - (Range min: 5%, max: 80%)
  /// d: Desktop - (Range min: 15%, max: 100%)
  final DivideRange? divideRange;

  @override
  State<SfsInitBuilder> createState() => _SfsInitBuilderState();
}

class _SfsInitBuilderState extends State<SfsInitBuilder>
    with WidgetsBindingObserver {
  MediaQueryData? _mediaQueryData;

  WidgetsBinding get binding => WidgetsFlutterBinding.ensureInitialized();

  MediaQueryData get mediaQueryData => _mediaQueryData!;

  _updateTree(Element el) {
    el.markNeedsBuild();
    el.visitChildren(_updateTree);
  }

  MediaQueryData? getUpdatedMQ() {
    final view = View.maybeOf(context);
    if (view != null) return MediaQueryData.fromView(view);
    return null;
  }

  @override
  void initState() {
    super.initState();
    binding.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    final oldMediaQueryData = _mediaQueryData!;
    final newMediaQueryData = getUpdatedMQ();

    if (widget.scaleByHeight ||
        (newMediaQueryData != null &&
            widget.rebuildFactor(oldMediaQueryData, newMediaQueryData))) {
      if (widget.didChangeSfsMetrics != null) {
        widget.didChangeSfsMetrics!();
      }
      _mediaQueryData = newMediaQueryData;
      _updateTree(context as Element);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _mediaQueryData ??= getUpdatedMQ();
    didChangeMetrics();
  }

  @override
  void dispose() {
    binding.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    mq = _mediaQueryData; //newMQ();
    return MediaQuery(
      data: mediaQueryData,
      child: Builder(
        builder: (context) {
          final deviceData = MediaQuery.maybeOf(context);
          final deviceSize = deviceData?.size ?? widget.mobileSize;
          return Builder(builder: (context) {
            SFS.init(SizeRange(
              screenMinSize: widget.screenMinSize,
              screenMaxSize: widget.screenMaxSize,
              mobileSize: widget.mobileSize,
              fontSizeRange: widget.fontSizeRange,
              multiFontSizeRange: widget.multiFontSizeRange, // 8------18
              divideRange: widget.divideRange ??
                  DivideRange(
                    // 100% range of font size for mobile
                    pergMob: Range(min: 0.0, max: 100.0),
                    // 100% range of font size for For tablet
                    pergTab: Range(min: 0.0, max: 100.0),
                    // 100% range of font size for For desktop
                    pergDesk: Range(min: 0.0, max: 100.0),
                  ),
            ));
            return SizedBox(
                width: deviceSize.width,
                height: deviceSize.height,
                child: FittedBox(
                  fit: BoxFit.none,
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: widget.scaleByHeight
                        ? (deviceSize.height * widget.mobileSize.width) /
                            widget.mobileSize.height
                        : deviceSize.width,
                    height: deviceSize.height,
                    child: widget.builder.call(context, widget.child),
                  ),
                ));
          });
        },
      ),
    );
  }
}
