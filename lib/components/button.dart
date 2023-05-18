import 'package:flutter/material.dart';
import 'package:flutter_parse/utils/apptheme.dart';
import 'package:flutter_parse/utils/colors.dart';

class WButton extends StatefulWidget {
  final void Function()? onPressed;
  final String label;
  final Color? buttonColor;
  final Color? textColor;
  final bool gradient;
  const WButton(
      {super.key,
      this.onPressed,
      required this.label,
      this.buttonColor,
      this.textColor,
      required this.gradient});

  @override
  State<WButton> createState() => W_ButtonState();
}

class W_ButtonState extends State<WButton> {
  var offsetBoxShadow = [
    BoxShadow(
      offset: Offset(-8.0, -8.0),
      color: WColors.brightColor,
      blurRadius: 10.0,
    ),
    BoxShadow(
      offset: Offset(8.0, 8.0),
      color: WColors.darkColor,
      blurRadius: 10.0,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          boxShadow: offsetBoxShadow,
          gradient: widget.gradient ? FTheme.primaryGradient : null,
          color: widget.gradient
              ? null
              : widget.buttonColor ?? WColors.primaryColor,
          borderRadius: BorderRadius.circular(20)),
      child: Material(
        child: InkWell(
            onTap: widget.onPressed,
            child: Container(
              height: 60,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Text(
                  widget.label,
                  style: TextStyle(
                      color: widget.textColor ?? WColors.dimWhiteColor),
                ),
              ),
            )),
        color: Colors.transparent,
      ),
    );
  }
}
