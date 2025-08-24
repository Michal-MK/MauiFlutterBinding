import 'package:flutter_app/main_page.dart';
import 'package:flutter_app/main_component_one.dart';
import 'package:flutter_app/main_component_two.dart';

void main() {
  main_page();
}

@pragma('vm:entry-point')
void main_component_one() {
  print("~LOG~ main_component_one() called from main.dart");
  main_component_one_impl();
}

@pragma('vm:entry-point')
void main_component_two() {
  print("~LOG~ main_component_two() called from main.dart");
  main_component_two_impl();
}