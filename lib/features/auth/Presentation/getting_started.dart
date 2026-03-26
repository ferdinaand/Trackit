import 'package:TrackIt/Resources/res.dart';
import 'package:TrackIt/features/auth/Presentation/signin/signin_screen.dart';
import 'package:TrackIt/features/auth/Presentation/signup/signup_screen.dart';
import 'package:TrackIt/global_widgets/button.ui.dart';
import 'package:TrackIt/global_widgets/gap.ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';

class GettingStartedScreen extends StatefulWidget {
  const GettingStartedScreen({super.key});

  @override
  State<GettingStartedScreen> createState() => _GettingStartedScreenState();
}

class _GettingStartedScreenState extends State<GettingStartedScreen> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body:
          //   SafeArea(
          // child:
          //       SingleChildScrollView(
          // child:
          Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                colorFilter: ColorFilter.mode(
                  colorScheme.onSurfaceVariant
                      .withOpacity(1.0), // Apply red tint with 50% opacity
                  BlendMode.srcATop, // Blends color with image
                ),
                image: AssetImage("assets/png/backgroundImg.png"),
                fit: BoxFit.fill)),
        padding: EdgeInsets.only(left: 24, right: 24, bottom: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            130.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  color: colorScheme.outline,
                  "assets/svg/trackItLogo.svg",
                  height: 60,
                  width: 100,
                ),
              ],
            ),
            // 136.verticalSpace,
            // Text(
            //   "Welcome Back!",
            //   style: bodyLBold,
            // ),
            // Spacer(),
            Column(
              children: [
                PrimaryButtonUi(
                  size: 54,
                  onPressed: () {
                    Navigator.push(context,
                        CupertinoPageRoute(builder: (BuildContext context) {
                      return SigninScreen();
                    }));
                  },
                  text: "Login",
                  borderR: Radius.circular(15),
                  textStyle: bodyMed,
                  textColor: Theme.of(context).colorScheme.onSecondary,
                  backgroundColor:
                      Theme.of(context).colorScheme.onSurfaceVariant,
                  // backgroundColor:
                  //     Theme.of(context).colorScheme.onSecondaryFixed,
                ),
                16.verticalSpace,
                PrimaryButtonUi(
                  size: 54,
                  onPressed: () {
                    Navigator.push(context,
                        CupertinoPageRoute(builder: (BuildContext context) {
                      return SignupScreen();
                    }));
                  },
                  text: "Create account",
                  borderR: Radius.circular(15),
                  textStyle: bodyMed,
                  textColor: Theme.of(context).colorScheme.onSecondary,
                  backgroundColor:
                      Theme.of(context).colorScheme.onSurfaceVariant,
                  // backgroundColor:
                  //     Theme.of(context).colorScheme.onSecondaryFixed,
                )
              ],
            )
          ],
        ),
      ),
      // )
      // )
    );
  }
}
