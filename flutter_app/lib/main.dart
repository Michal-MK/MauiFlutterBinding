// ignore_for_file: non_constant_identifier_names

import 'package:flutter_app/helpers.dart';
import 'package:flutter_app/main_page.dart';
import 'package:flutter_app/main_component_one.dart';
import 'package:flutter_app/main_component_two.dart';

void main() {
  print("~LOG~ main() called from main.dart");

  main_page();
}

@pragma('vm:entry-point')
void main_component_one(List<String> args) {
  print("~LOG~ main_component_one() called from main.dart with args: $args");

  final constraints = parseConstraints(args);

  main_component_one_impl(constraints.width, constraints.height);
}

@pragma('vm:entry-point')
void main_component_two(List<String> args) {
  print("~LOG~ main_component_two() called from main.dart with args: $args");

  final constraints = parseConstraints(args);

  main_component_two_impl(constraints.width, constraints.height);
}
