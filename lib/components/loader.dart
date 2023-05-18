import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:lottie/lottie.dart';

class LoaderBird extends StatelessWidget {
  const LoaderBird({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
              color: Colors.white,
              child: Center(
                  child:LottieBuilder.asset('animation/loader.json'),
                ),
            );
  }
}