import 'package:flutter/material.dart';
import 'package:TrackIt/Resources/res.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextUi extends StatelessWidget {
  const TextUi(
    this.data, {
    super.key,
    this.color,
    this.fontSize,
    this.maxLines,
    this.fontWeight,
    this.textAlign = TextAlign.left,
    this.isSelectable = false,
    this.height,
    this.decoration,
    this.style = bodyMed,
  });

  const TextUi.heading1(
    this.data, {
    super.key,
    this.color,
    this.fontSize,
    this.maxLines,
    this.fontWeight,
    this.decoration,
    this.textAlign = TextAlign.center,
    this.style = heading1,
    this.isSelectable = false,
    this.height,
  });

  const TextUi.heading2(
    this.data, {
    super.key,
    this.color,
    this.fontSize,
    this.maxLines,
    this.fontWeight,
    this.textAlign = TextAlign.left,
    this.isSelectable = false,
    this.height,
    this.decoration,
    this.style = heading2,
  });

  const TextUi.heading3(
    this.data, {
    super.key,
    this.color,
    this.fontSize,
    this.maxLines,
    this.fontWeight,
    this.textAlign = TextAlign.center,
    this.isSelectable = false,
    this.height,
    this.decoration,
    this.style = heading3,
  });

  const TextUi.heading4(
    this.data, {
    super.key,
    this.color,
    this.fontSize,
    this.maxLines,
    this.fontWeight,
    this.textAlign = TextAlign.left,
    this.isSelectable = false,
    this.height,
    this.decoration,
    this.style = heading4,
  });
  const TextUi.heading5(
    this.data, {
    super.key,
    this.color,
    this.fontSize,
    this.maxLines,
    this.fontWeight,
    this.textAlign = TextAlign.left,
    this.isSelectable = false,
    this.height,
    this.decoration,
    this.style = heading5,
  });
  const TextUi.heading6(
    this.data, {
    super.key,
    this.color,
    this.fontSize,
    this.maxLines,
    this.fontWeight,
    this.textAlign = TextAlign.left,
    this.isSelectable = false,
    this.height,
    this.decoration,
    this.style = heading6,
  });

  const TextUi.bodyXL(
    this.data, {
    super.key,
    this.color,
    this.fontSize,
    this.maxLines,
    this.fontWeight,
    this.textAlign = TextAlign.left,
    this.isSelectable = false,
    this.height,
    this.decoration,
    this.style = bodyXL,
  });

  const TextUi.bodyLarge(
    this.data, {
    super.key,
    this.color,
    this.fontSize,
    this.maxLines,
    this.fontWeight,
    this.textAlign = TextAlign.left,
    this.isSelectable = false,
    this.height,
    this.decoration,
    this.style = bodyL,
  });

  const TextUi.bodyMed(
    this.data, {
    super.key,
    this.color,
    this.fontSize,
    this.maxLines,
    this.fontWeight,
    this.textAlign = TextAlign.left,
    this.isSelectable = false,
    this.height,
    this.decoration,
    this.style = bodyMed,
  });
  const TextUi.bodyNorm(
    this.data, {
    super.key,
    this.color,
    this.fontSize,
    this.maxLines,
    this.fontWeight,
    this.textAlign = TextAlign.left,
    this.isSelectable = false,
    this.height,
    this.decoration,
    this.style = bodyNorm,
  });
  const TextUi.bodySmall(
    this.data, {
    super.key,
    this.color,
    this.fontSize,
    this.maxLines,
    this.fontWeight,
    this.textAlign = TextAlign.left,
    this.isSelectable = false,
    this.height,
    this.decoration,
    this.style = bodySmall,
  });

  const TextUi.bodyXSmall(
    this.data, {
    super.key,
    this.color,
    this.fontSize,
    this.maxLines,
    this.fontWeight,
    this.textAlign = TextAlign.left,
    this.isSelectable = false,
    this.height,
    this.decoration,
    this.style = bodyXSmall,
  });

  const TextUi.headingBold1(
    this.data, {
    super.key,
    this.color,
    this.fontSize,
    this.maxLines,
    this.fontWeight,
    this.textAlign = TextAlign.left,
    this.isSelectable = false,
    this.height,
    this.decoration,
    this.style = headingBold1,
  });

  const TextUi.headingBold2(
    this.data, {
    super.key,
    this.color,
    this.fontSize,
    this.maxLines,
    this.fontWeight,
    this.textAlign = TextAlign.left,
    this.isSelectable = false,
    this.height,
    this.decoration,
    this.style = headingBold2,
  });

  const TextUi.headingBold3(
    this.data, {
    super.key,
    this.color,
    this.fontSize,
    this.maxLines,
    this.fontWeight,
    this.textAlign = TextAlign.left,
    this.isSelectable = false,
    this.height,
    this.decoration,
    this.style = headingBold3,
  });

  const TextUi.headingBold4(
    this.data, {
    super.key,
    this.color,
    this.fontSize,
    this.maxLines,
    this.fontWeight,
    this.textAlign = TextAlign.left,
    this.isSelectable = false,
    this.height,
    this.decoration,
    this.style = headingBold4,
  });

  const TextUi.headingBold5(
    this.data, {
    super.key,
    this.color,
    this.fontSize,
    this.maxLines,
    this.fontWeight,
    this.textAlign = TextAlign.left,
    this.isSelectable = false,
    this.height,
    this.decoration,
    this.style = headingBold5,
  });

  const TextUi.headingBold6(
    this.data, {
    super.key,
    this.color,
    this.fontSize,
    this.maxLines,
    this.fontWeight,
    this.textAlign = TextAlign.left,
    this.isSelectable = false,
    this.height,
    this.decoration,
    this.style = headingBold6,
  });

  const TextUi.bodyXLBold(
    this.data, {
    super.key,
    this.color,
    this.fontSize,
    this.maxLines,
    this.fontWeight,
    this.textAlign = TextAlign.left,
    this.isSelectable = false,
    this.height,
    this.decoration,
    this.style = bodyXLBold,
  });

  const TextUi.bodyLBold(
    this.data, {
    super.key,
    this.color,
    this.fontSize,
    this.maxLines,
    this.fontWeight,
    this.textAlign = TextAlign.left,
    this.isSelectable = false,
    this.height,
    this.decoration,
    this.style = bodyLBold,
  });

  const TextUi.bodyMedBold(
    this.data, {
    super.key,
    this.color,
    this.fontSize,
    this.maxLines,
    this.fontWeight,
    this.textAlign = TextAlign.left,
    this.isSelectable = false,
    this.height,
    this.decoration,
    this.style = bodyMedBold,
  });

  const TextUi.bodyNormBold(
    this.data, {
    super.key,
    this.color,
    this.fontSize,
    this.maxLines,
    this.fontWeight,
    this.textAlign = TextAlign.left,
    this.isSelectable = false,
    this.height,
    this.decoration,
    this.style = bodyNormBold,
  });

  const TextUi.bodySmallBold(
    this.data, {
    super.key,
    this.color,
    this.fontSize,
    this.maxLines,
    this.fontWeight,
    this.textAlign = TextAlign.left,
    this.isSelectable = false,
    this.height,
    this.decoration,
    this.style = bodySmallBold,
  });

  const TextUi.bodyXSmallBold(
    this.data, {
    super.key,
    this.color,
    this.fontSize,
    this.maxLines,
    this.fontWeight,
    this.textAlign = TextAlign.left,
    this.isSelectable = false,
    this.height,
    this.decoration,
    this.style = bodyXSmallBold,
  });
  final String data;
  final TextStyle style;
  final Color? color;
  final double? fontSize;
  final int? maxLines;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final bool isSelectable;
  final double? height;
  final TextDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    if (isSelectable) {
      return SelectableText(
        data,
        textAlign: textAlign,
        style: style.copyWith(
          color: color,
          fontSize: fontSize?.sp,
          fontWeight: fontWeight,
          height: height,
        ),
        maxLines: maxLines,
      );
    }

    return Text(
      data,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: TextOverflow.visible,
      softWrap: true,
      style: style.copyWith(
        color: color,
        decoration: decoration,
        fontSize: fontSize?.sp,
        height: height ?? 1.5,
        fontWeight: fontWeight,
      ),
    );
  }
}
