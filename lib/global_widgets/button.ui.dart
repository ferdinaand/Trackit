// ignore_for_file: annotate_overrides, overridden_fields

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:TrackIt/global_widgets/text.ui.dart';
import 'package:TrackIt/Resources/colors.res.dart';
import 'package:TrackIt/Resources/radius.res.dart';
import 'package:TrackIt/Resources/typograhy.res.dart';

class ButtonUi extends TextButton {
  const ButtonUi({
    super.key,
    required this.style,
    required this.child,
    this.onPressed,
  }) : super(
          style: style,
          onPressed: onPressed,
          child: child,
        );

  final ButtonStyle style;
  final Widget child;
  final VoidCallback? onPressed;
}

class PrimaryButtonUi extends ButtonUi {
  PrimaryButtonUi({
    super.key,
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.textStyle,
    this.textColor,
    this.borderWidth,
    this.loaderColor,
    this.color,
    this.padding,
    this.size,
    this.enable = false,
    this.borderR,
    this.loading = false,
  }) : super(
          style: ButtonStyle(
            enableFeedback: enable,
            alignment: Alignment.center,
            elevation: WidgetStateProperty.all(0),
            minimumSize: WidgetStateProperty.all(
              Size.fromHeight(size ?? 50),
            ),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                side: BorderSide(
                  color: color ?? Colors.white,
                  width: borderWidth ?? 0,
                ),
                borderRadius: BorderRadius.all(
                  borderR ?? smallRadius,
                ),
              ),
            ),
            backgroundColor: WidgetStateProperty.resolveWith<Color>(
              (Set<WidgetState> states) {
                if (states.contains(WidgetState.pressed)) {
                  return backgroundColor ?? primary;
                } else if (states.contains(WidgetState.disabled)) {
                  return pgContrastDisabled;
                  // ??
                  //     primary.withOpacity(.3);
                }
                return backgroundColor ??
                    primary; // Use the component's default.
              },
            ),
          ),
          onPressed: onPressed,
          child: loading
              ? CupertinoActivityIndicator(
                  color: loaderColor ?? Colors.white,
                )
              : Center(
                  child: TextUi(
                    textAlign: TextAlign.center,
                    text,
                    color: textColor ?? white,
                    style: textStyle ?? buttonTypography,
                  ),
                ),
        );
  final double? size;
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final EdgeInsetsGeometry? padding;
  final bool loading;
  final bool enable;
  final TextStyle? textStyle;
  final Color? color;
  final Color? loaderColor;
  final double? borderWidth;
  final Radius? borderR;
}
