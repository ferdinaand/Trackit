import 'package:TrackIt/Resources/colors.res.dart';
import 'package:TrackIt/Resources/typograhy.res.dart';
import 'package:TrackIt/features/Extras/Widgets/family_bottom_sheet_shell.dart';
import 'package:TrackIt/features/Extras/Widgets/on_tap_scaler.dart';
import 'package:TrackIt/features/auth/Presentation/getting_started.dart';
import 'package:TrackIt/features/auth/Presentation/providers/Authethication_provider.dart';
import 'package:TrackIt/features/auth/Presentation/signin/signin_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:provider/provider.dart';

import '../Widgets/action_button.dart';

class ProfileScreen extends StatefulWidget {
  final String title;
  const ProfileScreen({super.key, required this.title});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    return FamilyBottomSheetShell(headerText: widget.title, children: [
      ActionButton(
          icon: IconsaxPlusBold.money,
          color: Colors.green,
          title: "Update salary",
          subtitle: "Update your salary/recurring income amount"),
      ActionButton(
          icon: IconsaxPlusBold.calendar_1,
          color: Colors.orange,
          title: "Update payday",
          subtitle: "Update your  pay day"),
      ActionButton(
          icon: IconsaxPlusBold.money_add,
          color: Colors.blue,
          title: "Add income ",
          subtitle: "Add an income transaction"),
      ActionButton(
          icon: IconsaxPlusBold.profile_delete,
          color: Colors.redAccent,
          title: "Delete account",
          subtitle: "Clear all your data"),
      ActionButton(
          icon: IconsaxPlusBold.logout,
          color: Colors.red,
          title: "logout",
          onTap: () async {
            final response = await authProvider.signOut().whenComplete(() {
              Navigator.push(context,
                  CupertinoPageRoute(builder: (BuildContext context) {
                return SigninScreen();
              }));
            });
          },
          subtitle: "Log out from this account")
    ]);
  }
}
