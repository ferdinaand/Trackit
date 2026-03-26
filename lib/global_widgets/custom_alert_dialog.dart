import 'package:TrackIt/Resources/colors.res.dart';
import 'package:TrackIt/Resources/typograhy.res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:TrackIt/global_widgets/text.ui.dart';

class CustomAlertDialog extends StatefulWidget {
  const CustomAlertDialog({
    super.key,
    this.height,
    this.width,
    this.alertImagePath,
    this.alertText,
    this.duration,
  });
  final String? alertText;
  final String? alertImagePath;
  final double? height;
  final double? width;
  final double? duration;

  @override
  State<CustomAlertDialog> createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog> {
  // navigate(
  //   context,
  // ) {
  //   Future.delayed(Duration(seconds: 3), () {
  //     Navigator.push(context, CupertinoPageRoute(builder: (context) {
  //       return HomeUi();
  //     }));
  //   });
  // }

  @override
  void initState() {
    super.initState();
    // navigate(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
          height: widget.height ?? 154.h,
          width: widget.width ?? 306.h,
          decoration: BoxDecoration(
              color: white, borderRadius: BorderRadius.circular(30)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(widget.alertImagePath!),
              17.verticalSpace,
              TextUi.bodySmall(
                widget.alertText ?? "Biometric activated successfully",
                style: bodySmall.copyWith(fontWeight: FontWeight.w900),
                color: grayScale900,
              )
            ],
          )),
    );
  }
}
