import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SizeReporter extends StatefulWidget {
  const SizeReporter({
    required this.viewType,
    required this.child,
    this.sizeReportDelay,
    this.constraintWidth,
    this.constraintHeight,
    super.key,
  });

  final String viewType;
  final Widget child;
  final int? sizeReportDelay;
  final double? constraintWidth;
  final double? constraintHeight;

  @override
  State<SizeReporter> createState() => _SizeReporterState();
}

class _SizeReporterState extends State<SizeReporter> with WidgetsBindingObserver {
  final GlobalKey _childKey = GlobalKey();
  final MethodChannel _channel = const MethodChannel('size_reporter');

  Size? _lastReportedSize;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _channel.setMethodCallHandler(null);
    super.dispose();
  }

  Future<void> _handleMethodCall(MethodCall call) async {
    print('~LOG~ SizeReporter received method call: ${call.method}');

    switch (call.method) {
      case 'containerSizeChanged':
        try {
          // Handle the arguments more safely
          final args = call.arguments;

          if (args is Map) {
            final String viewType = args['viewType']?.toString() ?? '';
            final double width = (args['width'] is num) ? (args['width'] as num).toDouble() : 0.0;
            final double height = (args['height'] is num) ? (args['height'] as num).toDouble() : 0.0;

            print('~LOG~ Container size changed: $viewType -> $width x $height');

            if (viewType == widget.viewType) {
              print('~LOG~ Storing container size and triggering widget rebuild');
              setState(() {});
            }
          } else {
            print('~LOG~ Invalid arguments type: ${args.runtimeType}');
          }
        } catch (e) {
          print('~LOG~ Error handling containerSizeChanged: $e');
        }
        break;
      default:
        print('~LOG~ Unknown method: ${call.method}');
    }
  }

  void _reportSize() {
    final RenderBox? renderBox = _childKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final actualSize = renderBox.size;

    print("~LOG~ Measuring widget ${widget.viewType}: actual size = ${actualSize.width}x${actualSize.height}");
    print("~LOG~ MAUI constraints: ${widget.constraintWidth}x${widget.constraintHeight}");

    Size sizeToReport;

    if (widget.constraintWidth != null && widget.constraintHeight != null && widget.constraintWidth! > 0 && widget.constraintHeight! > 0) {
      final constraints = BoxConstraints(
        minWidth: 0,
        maxWidth: widget.constraintWidth!,
        minHeight: 0,
        maxHeight: widget.constraintHeight!,
      );

      final drySize = renderBox.getDryLayout(constraints);
      sizeToReport = drySize;
      print("~LOG~ Using MAUI constraints for ${widget.viewType}: ${sizeToReport.width}x${sizeToReport.height} (constraints: ${widget.constraintWidth}x${widget.constraintHeight})");
    } else if (actualSize.width > 0 && actualSize.height > 0) {
      sizeToReport = actualSize;
      print("~LOG~ Using actual size for ${widget.viewType}: ${actualSize.width}x${actualSize.height}");
    } else {
      sizeToReport = Size.zero;
    }

    if (sizeToReport.width > 0 && sizeToReport.height > 0 && _lastReportedSize != sizeToReport) {
      _lastReportedSize = sizeToReport;

      print("~LOG~ Reporting size for ${widget.viewType}: ${sizeToReport.width}x${sizeToReport.height}");

      if (widget.sizeReportDelay == 0) {
        _channel.invokeMethod('reportSize', {
          'viewType': widget.viewType,
          'width': sizeToReport.width,
          'height': sizeToReport.height,
        });
      } else {
        Future.delayed(Duration(milliseconds: widget.sizeReportDelay ?? 2000), () {
          _channel.invokeMethod('reportSize', {
            'viewType': widget.viewType,
            'width': sizeToReport.width,
            'height': sizeToReport.height,
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _reportSize());

    return Container(
      key: _childKey,
      child: widget.child,
    );
  }
}
