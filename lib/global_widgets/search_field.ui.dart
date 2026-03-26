import 'package:flutter/material.dart';
import 'package:TrackIt/global_widgets/textfield.ui.dart';
import 'package:TrackIt/Resources/colors.res.dart';
import 'package:TrackIt/Resources/icons.res.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchFieldUi extends StatelessWidget {
  const SearchFieldUi({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String hintText;
  final void Function(String?) onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFieldUi(
      controller: controller,
      hintText: hintText,
      onChanged: onChanged,
      prefixIcon: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: SvgPicture.asset(
          searchIcon,
          color: grayScale700,
        ),
      ),
    );
  }
}
