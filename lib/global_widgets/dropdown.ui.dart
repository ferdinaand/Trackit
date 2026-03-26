import 'package:flutter/material.dart';
import 'package:TrackIt/global_widgets/text.ui.dart';
import 'package:get/get.dart';
import 'package:TrackIt/Resources/res.dart';

class DropDownUi extends StatelessWidget {
  const DropDownUi({
    super.key,
    this.items = const <String>[],
    required this.onChanged,
    required this.hintText,
  });

  final List<String> items;
  final String hintText;
  final void Function(String?) onChanged;

  @override
  Widget build(BuildContext context) {
    final hasValue = false.obs;
    final dropdownValue = ''.obs;
    return Container(
      height: 48,
      padding: const EdgeInsets.only(
        left: 16,
        right: 8,
      ),
      decoration: const BoxDecoration(
        color: grayScale50,
        borderRadius: BorderRadius.all(
          smallRadius,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: Obx(
          () => DropdownButton<String>(
            hint: TextUi(
              hasValue.value ? dropdownValue.value : hintText,
              style: hasValue.value
                  ? hintTextStyle.copyWith(
                      fontWeight: FontWeight.w600,
                      color: grayScale900,
                      height: 1.5,
                    )
                  : hintTextStyle,
            ),
            style: hintTextStyle.copyWith(
              fontWeight: FontWeight.w600,
              color: grayScale900,
              height: 1.5,
            ),
            borderRadius: const BorderRadius.all(
              regularRadius,
            ),
            icon: const Icon(
              Icons.arrow_drop_down_rounded,
              size: 30,
            ),
            onChanged: (value) {
              if (value == null) {
                hasValue.value = false;
              } else {
                hasValue.value = true;
              }

              dropdownValue.value = value ?? '';
              onChanged(value);
            },
            items: items
                .map(
                  (item) => DropdownMenuItem<String>(
                    value: item,
                    child: TextUi(
                      item,
                      style: hintTextStyle.copyWith(
                        fontWeight: FontWeight.w600,
                        color: grayScale900,
                        height: 1.5,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
