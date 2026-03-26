import 'package:TrackIt/Resources/colors.res.dart';
import 'package:TrackIt/Resources/typograhy.res.dart';
import 'package:TrackIt/features/Extras/Widgets/family_bottom_sheet_shell.dart';
import 'package:TrackIt/features/Extras/Widgets/on_tap_scaler.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../Widgets/action_button.dart';

class DataScreen extends StatefulWidget {
  final String title;
  const DataScreen({super.key, required this.title});

  @override
  State<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  @override
  Widget build(BuildContext context) {
    return FamilyBottomSheetShell(headerText: widget.title, children: [
      ActionButton(
          icon: IconsaxPlusBold.import_3,
          color: Colors.blue,
          title: "Import data",
          subtitle: "Import your spending data"),
      ActionButton(
          icon: IconsaxPlusBold.export_3,
          color: Colors.orange,
          title: "Export data",
          subtitle: "Export your spending data"),
    ]);
  }
}
