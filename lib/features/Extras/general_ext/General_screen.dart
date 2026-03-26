import 'package:TrackIt/Resources/colors.res.dart';
import 'package:TrackIt/Resources/typograhy.res.dart';
import 'package:TrackIt/features/Extras/Widgets/family_bottom_sheet_shell.dart';
import 'package:TrackIt/features/Extras/Widgets/on_tap_scaler.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../Widgets/action_button.dart';

class GeneralScreen extends StatefulWidget {
  final String title;
  const GeneralScreen({super.key, required this.title});

  @override
  State<GeneralScreen> createState() => _GeneralScreenState();
}

class _GeneralScreenState extends State<GeneralScreen> {
  @override
  Widget build(BuildContext context) {
    return FamilyBottomSheetShell(headerText: widget.title, children: [
      ActionButton(
          icon: IconsaxPlusBold.dollar_circle,
          color: Colors.blue,
          title: "Default currency",
          subtitle: "Set your default currency"),
      ActionButton(
          icon: IconsaxPlusBold.profile_delete,
          color: Colors.red,
          title: "Clear cache",
          subtitle: "Clear your app cache "),
    ]);
  }
}
