import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:TrackIt/Resources/colors.res.dart';
import 'package:TrackIt/global_widgets/text.ui.dart';
import 'package:TrackIt/Resources/typograhy.res.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'gap.ui.dart';

class TextFieldUi extends StatefulWidget {
  const TextFieldUi({
    super.key,
    required this.hintText,
    required this.controller,
    this.disabledBorder,
    this.enabledBorder,
    this.focusedBorder,
    this.errorBorder,
    this.helperText,
    this.onChanged,
    this.decoration,
    this.radius,
    this.prefixIcon,
    this.errorStyle,
    this.hintStyle,
    this.suffixIcon,
    this.isFilled = false,
    this.fillColor,
    this.maxLength,
    this.initalValue,
    this.prefixContainerColor,
    this.showPrefixIcon = true,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.alwaysShowHelperText = false,
    this.validator,
    this.inputFormatter,
    this.maxLines = 1,
    this.isTextFieldEnabled = true,
    this.textStyle,
    this.textFieldHeight,
    this.textFieldWidth,
    this.textInputAction,
    this.focusNode,
    this.onTap,
    this.autofocus = false,
  });

  final String hintText;
  final TextInputType keyboardType;
  final bool obscureText;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final TextStyle? errorStyle;
  final ValueChanged<String?>? onChanged;
  final FormFieldValidator<String?>? validator;
  final int maxLines;
  final List<TextInputFormatter>? inputFormatter;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final InputBorder? focusedBorder;
  final InputBorder? disabledBorder;
  final InputBorder? enabledBorder;
  final InputBorder? errorBorder;
  final double? textFieldHeight;
  final double? textFieldWidth;
  final double? radius;
  final String? initalValue;
  final InputDecoration? decoration;
  final int? maxLength;
  final Color? fillColor;
  final bool isFilled;
  final TextInputAction? textInputAction;
  final bool autofocus;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final VoidCallback? onTap;
  final bool showPrefixIcon;
  final Color? prefixContainerColor;
  final String? helperText;
  final bool alwaysShowHelperText;
  final bool isTextFieldEnabled;

  @override
  State<TextFieldUi> createState() => _TextFieldUiState();
}

class _TextFieldUiState extends State<TextFieldUi> {
  late FocusNode focusNode;
  late GlobalKey<FormFieldState<String>> _formFieldKey;
  final _showClearButton = false.obs;
  final _hasFocus = false.obs;

  void showBorderMethod() {
    if (focusNode.hasPrimaryFocus && mounted) {
      _hasFocus.value = true;
    } else {
      _hasFocus.value = false;
    }
  }

  @override
  void initState() {
    super.initState();
    _formFieldKey = GlobalKey<FormFieldState<String>>();
    focusNode = widget.focusNode ?? FocusNode();
    focusNode.addListener(showBorderMethod);
    widget.controller.addListener(() {
      _showClearButton.value = widget.controller.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: widget.textFieldHeight ?? 70.h,
          width: double.infinity,
          // decoration: BoxDecoration(
          //   boxShadow: [
          //     BoxShadow(
          //       color: Colors.black.withOpacity(0.1),
          //       blurStyle: BlurStyle.outer,
          //       blurRadius: 10,
          //       offset: const Offset(0, 0),
          //     )
          //   ],
          //   color: Theme.of(context)
          //       .cardColor
          //       .withOpacity(0.2), // Lower opacity for a frosted glass effect
          //   borderRadius: BorderRadius.circular(20),
          //   border: Border.all(
          //       color: Colors.white.withOpacity(0.2)), // Soft white border
          // ),
          child: TextFormField(
            key: _formFieldKey,
            maxLines: widget.maxLines,
            maxLength: widget.maxLength,
            autofocus: widget.autofocus,
            validator: widget.validator,
            controller: widget.controller,
            onChanged: (val) {
              focusNode.requestFocus();
              widget.onChanged?.call(val);
            },
            onTap: widget.onTap,

            keyboardType: widget.keyboardType,
            initialValue: widget.initalValue,
            autocorrect: false,

            focusNode: focusNode,
            inputFormatters: widget.inputFormatter,
            obscureText: widget.obscureText,
            style: bodyNorm,
            // cursorColor:,
            cursorWidth: 1,
            textInputAction: widget.textInputAction,
            obscuringCharacter: '●',
            decoration: widget.decoration ??
                InputDecoration(
                  filled: widget.isFilled,
                  fillColor: widget.fillColor,
                  counterText: '',
                  enabled: widget.isTextFieldEnabled,
                  border: OutlineInputBorder(
                    gapPadding: 10,
                    borderRadius:
                        BorderRadius.all(Radius.circular(widget.radius ?? 15)),
                  ),
                  focusedBorder: widget.focusedBorder ??
                      OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                        borderRadius: BorderRadius.all(
                            Radius.circular(widget.radius ?? 15)),
                      ),
                  errorBorder: widget.errorBorder,
                  enabledBorder: widget.enabledBorder ??
                      OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        borderRadius: BorderRadius.all(
                            Radius.circular(widget.radius ?? 15)),
                      ),
                  disabledBorder: widget.disabledBorder,
                  hintStyle: widget.hintStyle ??
                      bodySmall.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .outline
                              .withOpacity(0.8)),
                  errorStyle: widget.errorStyle,
                  prefixIcon: widget.prefixIcon,
                  // ??
                  //     Container(
                  //       width: 50,
                  //       height: 50,
                  //       margin: EdgeInsets.all(8),
                  //       decoration: BoxDecoration(
                  //           color: widget.prefixContainerColor ??
                  //               Theme.of(context).colorScheme.primary,
                  //           borderRadius: BorderRadius.circular(7.5)),
                  //     ),
                  suffixIcon: widget.suffixIcon,
                  prefixIconConstraints: const BoxConstraints(
                    minHeight: 20,
                    minWidth: 32,
                  ),
                  suffixIconConstraints: const BoxConstraints(
                    minHeight: 32,
                    minWidth: 20,
                  ),
                  hintText: widget.hintText,
                ),
          ),
        ),
        if (widget.helperText != null && _hasFocus.value) ...[
          const Gap(4),
          TextUi.bodySmall(
            widget.helperText!,
            fontSize: 12,
            color: inActive,
          ),
          const Gap(4),
        ]
      ],
    );
  }
}
