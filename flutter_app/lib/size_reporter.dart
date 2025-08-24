import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SizeReporter extends StatefulWidget {
  const SizeReporter({
    required this.viewType,
    required this.child,
    super.key,
  });

  final String viewType;
  final Widget child;

  @override
  State<SizeReporter> createState() => _SizeReporterState();
}

class _SizeReporterState extends State<SizeReporter> {
  final GlobalKey _key = GlobalKey();
  final MethodChannel _channel = const MethodChannel('size_reporter');

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox renderBox = _key.currentContext?.findRenderObject() as RenderBox;
      final size = renderBox.size;

      print("~LOG~ Reporting size for ${widget.viewType}: $size");

      _channel.invokeMethod('reportSize', {
        'viewType': widget.viewType,
        'width': size.width,
        'height': size.height,
      });
    });
    return Container(
      key: _key,
      child: widget.child,
    );
  }
}
