import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';

class AnimationContainer extends StatelessWidget {
  final String lottie;
  const AnimationContainer({super.key, required this.lottie});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: SizedBox()),
        Lottie.asset(lottie,
            fit: BoxFit.contain, height: 300),
        Expanded(child: SizedBox())
      ],
    );
  }
}
