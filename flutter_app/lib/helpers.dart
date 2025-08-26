import 'dart:ui';

Size parseConstraints(List<String> args) {
  double width = 0;
  double height = 0;

  for (String arg in args) {
    if (arg.startsWith('width=')) {
      width = double.tryParse(arg.substring(6)) ?? 0;
    } else if (arg.startsWith('height=')) {
      height = double.tryParse(arg.substring(7)) ?? 0;
    }
  }

  return Size(width, height);
}