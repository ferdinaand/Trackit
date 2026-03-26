import 'package:TrackIt/Resources/res.dart';
import 'package:TrackIt/global_widgets/family_modal_sheet.dart';

import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
        FamilyModalSheet.of(context).popPage();
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colors.secondary.withOpacity(0.2),
        ),
        height: 32,
        width: 32,
        child: Icon(Icons.close, size: 22, color: grayScale50),
      ),
    );
  }
}
