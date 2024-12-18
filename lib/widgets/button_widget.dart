import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:get/get.dart';
import 'package:gwc_customer_web/widgets/widgets.dart';
import 'constants.dart';

class ButtonWidget extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final Color? color;
  final Color? textColor;
  final Color? loadingColor;
  final double? radius;
  final double? buttonWidth;
  final String? font;
  const ButtonWidget({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.isLoading,
    this.color,
    this.textColor,
    this.loadingColor,
    this.radius,
    this.buttonWidth, this.font,
  }) : super(key: key);

  @override
  State<ButtonWidget> createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  @override
  Widget build(BuildContext context) {
    Color buttonColor = widget.color ?? gsecondaryColor;
    Color buttonTextColor = widget.textColor ?? gWhiteColor;
    Color loadingButtonColor = widget.loadingColor ?? gWhiteColor;
    double borRadius = widget.radius ?? 30.0;
    double buttonWidth = widget.buttonWidth ?? 30.w;
    String buttonFont = widget.font ??eUser().buttonTextFont;

    return SizedBox(
      width: buttonWidth,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 0.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borRadius),
          ),
        ),
        onPressed: widget.isLoading ? null : widget.onPressed,
        child: Center(
          child: widget.isLoading
              ? buildThreeBounceIndicator(color: loadingButtonColor)
              : Text(
                  widget.text,
                  style: TextStyle(
                    fontFamily: buttonFont,
                    color: buttonTextColor,
                    fontSize: eUser().buttonTextSize,
                  ),
                ),
        ),
      ),
    );
  }
}

class CommonButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final Color color;
  final Color textColor;

  const CommonButton({
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.color = Colors.blue,
    this.textColor = Colors.white,
    Key? key,
  }) : super(key: key);

  @override
  _CommonButtonState createState() => _CommonButtonState();
}

class _CommonButtonState extends State<CommonButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: widget.color,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: widget.isLoading
          ? null
          : widget.onPressed, // Disable button if loading
      child: widget.isLoading
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 2,
              ),
            )
          : Text(
              widget.text,
              style: TextStyle(color: widget.textColor, fontSize: 16),
            ),
    );
  }
}
