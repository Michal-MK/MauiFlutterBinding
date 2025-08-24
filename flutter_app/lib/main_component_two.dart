import 'package:flutter_app/size_reporter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:flutter/material.dart';

void main_component_two_impl() {
  print("~LOG~ main_component_two_impl() called");
  runApp(const MyComponentTwo());
}

class MyComponentTwo extends StatelessWidget {
  const MyComponentTwo({super.key});

  @override
  Widget build(BuildContext context) {
    print("~LOG~ Building Component Two");
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
            child: Column(
              children: [
                Container(
                  height: 200,
                  color: Colors.red,
                ),
                Text("Component Two", style: TextStyle(fontSize: 30, color: Colors.black)),
                Container(
                  height: 100,
                  color: Colors.blue,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
