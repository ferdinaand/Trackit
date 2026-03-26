import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:TrackIt/Resources/res.dart';

///This file contains other stylings used in the app
///Asides from font and textStyles

OutlineInputBorder border(Color color, {double width = 1}) {
  return OutlineInputBorder(
    borderRadius: const BorderRadius.all(smallRadius),
    borderSide: BorderSide(
      color: color,
      width: width,
    ),
  );
}

final baseViewPadding = EdgeInsets.symmetric(
  horizontal: 20.w,
);
