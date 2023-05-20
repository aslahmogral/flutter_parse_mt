import 'package:flutter/material.dart';
import 'package:flutter_parse/utils/dimens.dart';

class FTheme {
  static LinearGradient get primaryGradient {
    return const LinearGradient(colors: [
      Color.fromARGB(255, 141, 106, 230),
      Color.fromARGB(255, 162, 136, 227),
      Color.fromARGB(255, 169, 145, 230),
      Color.fromARGB(255, 174, 153, 227),
      Color.fromARGB(255, 176, 157, 225),
    ], begin: Alignment.bottomRight, end: Alignment.topLeft);
  }

  static TextStyle get primaryHeaderStyle {
    return const TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  }

  static TextStyle get primaryHeaderStyle2 {
    return const TextStyle(fontSize: 26, fontWeight: FontWeight.bold);
  }

  static BoxDecoration get dialogDecoration {
    return BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimens.borderRadiusSmall));
  }
}
