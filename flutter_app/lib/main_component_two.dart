import 'dart:isolate';

import 'package:flutter_app/size_reporter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:flutter/material.dart';

void main_component_two_impl([double? constraintWidth, double? constraintHeight]) {
  runApp(MyComponentTwo(constraintWidth: constraintWidth, constraintHeight: constraintHeight));
}

class MyComponentTwo extends StatefulWidget {
  const MyComponentTwo({
    super.key,
    this.constraintWidth,
    this.constraintHeight,
  });

  final double? constraintWidth;
  final double? constraintHeight;

  @override
  State<MyComponentTwo> createState() => _MyComponentTwoState();
}

class _MyComponentTwoState extends State<MyComponentTwo> {
  final List<Widget> dynamicChildren = [];

  void addChild() {
    setState(() {
      dynamicChildren.add(
        Container(
          height: 50,
          color: Colors.primaries[dynamicChildren.length % Colors.primaries.length],
        ),
      );
    });
  }

  void removeChild() {
    setState(() {
      if (dynamicChildren.isNotEmpty) {
        dynamicChildren.removeLast();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print("~LOG~ Building Component Two");
    final size = MediaQuery.sizeOf(context);
    return Material(
      type: MaterialType.transparency,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Localizations(
          locale: const Locale('en', 'US'),
          delegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          child: SizeReporter(
            viewType: "component_two",
            constraintWidth: widget.constraintWidth,
            constraintHeight: widget.constraintHeight,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 100,
                  color: Colors.red,
                ),
                Text("Component Two", style: TextStyle(fontSize: 24, color: Colors.black)),
                Text("${size.width.toStringAsFixed(2)}x${size.height.toStringAsFixed(2)}", style: TextStyle(fontSize: 24, color: Colors.black)),
                Row(
                  children: [
                    IconButton(onPressed: removeChild, icon: Icon(Icons.remove)),
                    IconButton(onPressed: addChild, icon: Icon(Icons.add)),
                  ],
                ),
                Container(
                  height: 50,
                  color: Colors.blue,
                ),
                ...dynamicChildren,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
