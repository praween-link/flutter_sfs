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
    this.screenSize = const Size(350, 650),
    this.scaleByHeight = false,
    this.fontSizeRange,
    this.multiFontSizeRange,
    this.screenMinSize = const Size(350, 650),
    this.screenMaxSize = const Size(920, 1024),
  });
  final SfsBuilder builder;
  final Widget? child;
  final RebuildFactor rebuildFactor;
  final bool scaleByHeight;
  final Size screenSize;
  final Range? fontSizeRange;
  final Map<String, Range>? multiFontSizeRange;
  final Size? screenMinSize;
  final Size? screenMaxSize;

  @override
  State<SfsInitBuilder> createState() => _SfsInitBuilderState();
}

class _SfsInitBuilderState extends State<SfsInitBuilder>
    with WidgetsBindingObserver {
  MediaQueryData? _mediaQueryData;
  bool _wrappedInMediaQuery = false;

  WidgetsBinding get binding => WidgetsFlutterBinding.ensureInitialized();

  MediaQueryData get mediaQueryData => _mediaQueryData!;
  bool get wrappedInMediaQuery => _wrappedInMediaQuery;

  MediaQueryData get getMediaQueryData {
    final mediaQueryData = MediaQuery.maybeOf(context);

    if (mediaQueryData != null) {
      _wrappedInMediaQuery = true;
      return mediaQueryData;
    }

    return MediaQueryData.fromWindow(binding.window);
  }

  _updateTree(Element el) {
    el.markNeedsBuild();
    el.visitChildren(_updateTree);
  }

  @override
  void initState() {
    super.initState();
    binding.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    final oldMediaQueryData = _mediaQueryData!;
    final newMediaQueryData = getMediaQueryData;

    if (widget.scaleByHeight ||
        widget.rebuildFactor(oldMediaQueryData, newMediaQueryData)) {
      _mediaQueryData = newMediaQueryData;
      _updateTree(context as Element);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _mediaQueryData ??= getMediaQueryData;
    didChangeMetrics();
  }

  @override
  void dispose() {
    binding.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: mediaQueryData,
      child: Builder(
        builder: (context) {
          final deviceData = MediaQuery.maybeOf(context);
          final deviceSize = deviceData?.size ?? widget.screenSize;
          return Builder(builder: (context) {
            SFS.init(SizeRange(
              screenMinSize: widget.screenMinSize,
              screenMaxSize: widget.screenMaxSize,
              screenSize: widget.screenSize,
              fontSizeRange: widget.fontSizeRange,
              multiFontSizeRange: widget.multiFontSizeRange,
            ));
            return SizedBox(
                width: deviceSize.width,
                height: deviceSize.height,
                child: FittedBox(
                  fit: BoxFit.none,
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: widget.scaleByHeight
                        ? (deviceSize.height * widget.screenSize.width) /
                            widget.screenSize.height
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
