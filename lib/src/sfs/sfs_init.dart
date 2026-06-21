import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_sfs/flutter_sfs.dart';

typedef RebuildFactor = bool Function(
  MediaQueryData oldMediaQueryData,
  MediaQueryData newMediaQueryData,
);

/// A custom builder function exposing the [BuildContext] required for [MaterialApp].
typedef SfsBuilder = Widget Function(
  BuildContext context,
  Widget? child,
);

/// Defines caching strategies to avoid unnecessary widget tree rebuilds.
class RebuildFactors {
  const RebuildFactors._();

  static bool size(MediaQueryData old, MediaQueryData data) {
    return old.size != data.size;
  }
}

/// A structural wrapper that initializes the `flutter_sfs` mathematical scaling engine.
///
/// Extremely important: [SfsInitBuilder] must wrap your [MaterialApp] or [CupertinoApp]
/// in order to correctly hook into the [WidgetsBindingObserver] for mapping window resizes.
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
    this.respectSystemTextScale = false,
    this.orientationAware = false,
    this.foldableAware = false,
    this.splitScreenAware = false,
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

  /// Mapping overrides assigning string keys (like 'btn') to specifically bounded text scopes.
  final Map<String, Range>? multiFontSizeRange;

  /// The absolute minimal resolution width/height mapped.
  final Size? screenMinSize;

  /// The absolute maximum resolution width/height mapped.
  final Size? screenMaxSize;

  /// Callback executed exactly when the screen metrics map correctly triggers a recalculation.
  final void Function()? didChangeSfsMetrics;

  /// Configuration adjusting mathematical breakpoint triggers:
  /// - `m`: Mobile (Range min: 0%, max: 60%)
  /// - `t`: Tablet (Range min: 5%, max: 80%)
  /// - `d`: Desktop (Range min: 15%, max: 100%)
  final DivideRange? divideRange;

  /// Multiplies output font scales efficiently against system accessibility font-size sliders.
  final bool respectSystemTextScale;

  /// Flags dimension parsing to clamp scaling maps safely to the short axis under landscape
  final bool orientationAware;

  /// Flags dimension parsing to clamp scaling maps safely to (0.5 * height) axis under unfolded (device become a square #Google Pixel 10)
  final bool? foldableAware;

  /// Flags dimension parsing to clamp scaling maps safely to (width < (0.5 * height) ? width : (0.5 * height)) under split screen
  final bool? splitScreenAware;

  @override
  State<SfsInitBuilder> createState() => _SfsInitBuilderState();
}

class _SfsInitBuilderState extends State<SfsInitBuilder>
    with WidgetsBindingObserver {
  MediaQueryData? _mediaQueryData;
  Size? _sfsDisplaySize;
  Timer? _debounceTimer;

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

  Size? getUpdatedSfsDisplaySize() {
    final view = View.maybeOf(context);
    if (view != null) return view.display.size / view.devicePixelRatio;
    return null;
  }

  @override
  void initState() {
    super.initState();
    binding.addObserver(this);
  }

  void _handleMetricsChange() {
    if (!mounted) return;

    final oldMediaQueryData = _mediaQueryData!;
    final newMediaQueryData = getUpdatedMQ();
    final oldSfsDisplaySize = _sfsDisplaySize;
    final newSfsDisplaySize = getUpdatedSfsDisplaySize();

    if (widget.scaleByHeight ||
        oldSfsDisplaySize != newSfsDisplaySize ||
        (newMediaQueryData != null &&
            widget.rebuildFactor(oldMediaQueryData, newMediaQueryData))) {
      if (widget.didChangeSfsMetrics != null) {
        widget.didChangeSfsMetrics!();
      }
      setState(() {
        _mediaQueryData = newMediaQueryData;
        _sfsDisplaySize = newSfsDisplaySize;
      });
      _updateTree(context as Element);
    }
  }

  @override
  void didChangeMetrics() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer =
        Timer(const Duration(milliseconds: 150), _handleMetricsChange);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bool isFirstLoad = _mediaQueryData == null;
    _mediaQueryData ??= getUpdatedMQ();
    _sfsDisplaySize = getUpdatedSfsDisplaySize();
    if (!isFirstLoad) {
      _handleMetricsChange();
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    binding.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    mq = _mediaQueryData; //newMQ();
    sfsDisplaySize = _sfsDisplaySize;
    return MediaQuery(
      data: mediaQueryData,
      child: Builder(
        builder: (context) {
          final deviceData = MediaQuery.maybeOf(context);
          final deviceSize = deviceData?.size ?? widget.mobileSize;

          SFS.init(SizeRange(
            screenMinSize: widget.screenMinSize,
            screenMaxSize: widget.screenMaxSize,
            mobileSize: widget.mobileSize,
            tabletSize: widget.tabletSize,
            desktopSize: widget.desktopSize,
            fontSizeRange: widget.fontSizeRange,
            multiFontSizeRange: widget.multiFontSizeRange,
            divideRange: widget.divideRange ??
                DivideRange(
                  pergMob: Range(min: 0.0, max: 100.0),
                  pergTab: Range(min: 0.0, max: 100.0),
                  pergDesk: Range(min: 0.0, max: 100.0),
                ),
            respectSystemTextScale: widget.respectSystemTextScale,
            orientationAware: widget.orientationAware,
            foldableAware: widget.foldableAware,
            splitScreenAware: widget.splitScreenAware,
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
            ),
          );
        },
      ),
    );
  }
}
