import 'package:flutter/material.dart';
import 'package:flutter_parse/components/bottom_sheet.dart';

class CustomTheme extends StatelessWidget {
  final Widget child1;
  final Widget child2;
  const CustomTheme({super.key, required this.child1, required this.child2});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: SizedBox()),
        Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: -300,
              right: 0,
              left: 0,
              child: child1,
            ),
            WBottomSheet(child: SingleChildScrollView(child: child2)),
          ],
        )
      ],
    );
  }
}
