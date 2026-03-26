import 'package:TrackIt/Resources/colors.res.dart';
import 'package:TrackIt/Resources/typograhy.res.dart';
import 'package:TrackIt/features/Extras/Widgets/family_bottom_sheet_shell.dart';
import 'package:TrackIt/features/Extras/Widgets/on_tap_scaler.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../Widgets/action_button.dart';

class PrivacyScreen extends StatefulWidget {
  final String title;
  const PrivacyScreen({super.key, required this.title});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  @override
  Widget build(BuildContext context) {
    return FamilyBottomSheetShell(headerText: widget.title, children: [
      ActionButton(
          icon: IconsaxPlusBold.notification_status,
          color: Colors.green,
          title: "Notification permissions",
          subtitle: "Allow the app to send notification"),
      ActionButton(
          icon: IconsaxPlusBold.security_safe,
          color: Colors.orange,
          title: "App lock",
          subtitle: "Set or update your app lock pin"),
      ActionButton(
          icon: IconsaxPlusBold.password_check,
          color: Colors.blue,
          title: "Change password",
          subtitle: "Change your password"),
      ActionButton(
          icon: IconsaxPlusBold.security,
          color: Colors.deepOrange,
          title: "Set privacy mode",
          subtitle: "Blur balances and transaction amounts"),
      ActionButton(
          icon: Icons.privacy_tip,
          color: Colors.blueGrey,
          title: "Privacy policy",
          subtitle: "View privacy policy")
    ]);
  }
}
