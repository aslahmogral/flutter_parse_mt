import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoaderBird extends StatelessWidget {
  final String? message1;
  final String? message2;
  const LoaderBird({super.key, this.message1 = '', this.message2 = ''});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LottieBuilder.asset('animation/loader.json'),
              SizedBox(
                height: 16,
              ),
              Text(message1.toString()),
              Text(message2.toString())
            ],
          ),
        ),
      ),
    );
  }
}
