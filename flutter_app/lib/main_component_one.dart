import 'package:flutter_app/size_reporter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:flutter/material.dart';

void main_component_one_impl() {
  print("~LOG~ main_component_one_impl() called");
  runApp(const MyComponentOne());
}

class MyComponentOne extends StatelessWidget {
  const MyComponentOne({super.key});

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
