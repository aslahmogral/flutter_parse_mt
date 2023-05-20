import 'package:flutter/material.dart';
import 'package:flutter_parse/utils/colors.dart';
import 'package:flutter_parse/utils/dimens.dart';

class WBottomSheet extends StatelessWidget {
  final Widget child;
  const WBottomSheet({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    var decoration = BoxDecoration(
      boxShadow: [
        BoxShadow(
          spreadRadius: 1.0,
          blurRadius: 8.0,
          offset: const Offset(0, -3.0),
          color: WColors.brightColor.withOpacity(0.6),
        )
      ],
      color: WColors.dimWhiteColor,
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(Dimens.padding_3xl),
          topRight: Radius.circular(Dimens.padding_3xl)),
    );
    return Container(
      decoration: decoration,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(Dimens.paddingXl),
        child: child,
      ),
    );
  }
}
