import 'package:flutter_app/size_reporter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:flutter/material.dart';

void main_component_one_impl([double? constraintWidth, double? constraintHeight]) {
  runApp(MyComponentOne(constraintWidth: constraintWidth, constraintHeight: constraintHeight));
}

class MyComponentOne extends StatelessWidget {
  const MyComponentOne({
    super.key,
    this.constraintWidth,
    this.constraintHeight,
  });

  final double? constraintWidth;
  final double? constraintHeight;

  @override
  Widget build(BuildContext context) {
    print("~LOG~ Building Component One");
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
            viewType: "component_one",
            constraintWidth: constraintWidth,
            constraintHeight: constraintHeight,
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: RadialGradient(colors: [
                  Colors.blue,
                  Colors.red,
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
