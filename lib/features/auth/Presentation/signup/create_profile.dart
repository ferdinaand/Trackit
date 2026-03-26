import 'dart:ui';

import 'package:TrackIt/Resources/res.dart';
import 'package:TrackIt/core/Helpers/Helper_class.dart';
import 'package:TrackIt/features/Navbar/nav_bar.dart';
import 'package:TrackIt/features/auth/Presentation/providers/Authethication_provider.dart';
import 'package:TrackIt/features/auth/Presentation/signin/signin_screen.dart';
import 'package:TrackIt/features/auth/domain/profile_entity.dart';
import 'package:TrackIt/global_widgets/appbar.ui.dart';
import 'package:TrackIt/global_widgets/button.ui.dart';
import 'package:TrackIt/global_widgets/gap.ui.dart';
import 'package:TrackIt/global_widgets/notification_snackbar.dart';
import 'package:TrackIt/global_widgets/text.ui.dart';
import 'package:TrackIt/global_widgets/textfield.ui.dart';
import 'package:TrackIt/global_widgets/widgets/transaction_list.dart';
import 'package:TrackIt/utils/format_currency.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({
    super.key,
  });

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _salaryController = TextEditingController();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _SignupFormKey = GlobalKey<FormState>();
  // Future<AuthResponse>
  bool showPassword = false;
  bool showConfirmPassword = false;
  bool stayLoggedIn = false;
  @override
  Widget build(BuildContext context) {
    stayLoggedIn = context.watch<AuthProvider>().rememberMe;
    final colorScheme = Theme.of(context).colorScheme;
    final authProvider = context.watch<AuthProvider>();
    final userId = Supabase.instance.client.auth.currentUser!.id;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        // forceMaterialTransparency: true,
        scrolledUnderElevation: 0,
        // backgroundColor: Colors.transparent,
        leading: Container(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              // print("back");
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, size: 30),
          ),
        ),
      ),
      body:
          //   SafeArea(
          // child:
          //   SingleChildScrollView(
          // child:
          Container(
        decoration: BoxDecoration(
            // color: Colors.transparent,
            image: DecorationImage(
                colorFilter: ColorFilter.mode(
                  colorScheme.onSurfaceVariant
                      .withOpacity(1.0), // Apply red tint with 50% opacity
                  BlendMode.srcATop, // Blends color with image
                ),
                // opacity: 1.0,
                image: AssetImage("assets/png/backgroundImg.png"),
                fit: BoxFit.fill)),
        padding: EdgeInsets.only(left: 0, right: 0, bottom: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 130.verticalSpace,
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
            136.verticalSpace,

            // Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurStyle: BlurStyle.outer,
                          blurRadius: 3,
                          offset: const Offset(0, 0),
                        )
                      ],
                      color: Theme.of(context).cardColor.withOpacity(
                          0.2), // Lower opacity for a frosted glass effect
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: Colors.white
                              .withOpacity(0.2)), // Soft white border
                    ),
                    child: ClipRRect(
                      // Clip the blur effect to match border radius
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter.grouped(
                        filter: ImageFilter.blur(
                            sigmaX: 2,
                            sigmaY: 2), // Increase blur for more glass effect
                        child: Container(
                          width: double.infinity,
                          // height: 200,
                          // margin: const EdgeInsets.all(16),
                          padding: const EdgeInsets.all(16),
                          // padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: colorScheme.outline
                                .withOpacity(0.1), // Slight white overlay
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Form(
                            key: _SignupFormKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Hi, Welcome",
                                  style: bodyXLBold.copyWith(fontSize: 24),
                                ),
                                0.verticalSpace,
                                Text(
                                  "Create an account to start using our platform",
                                  style: bodyNorm,
                                ),
                                20.verticalSpace,

                                /// Firstname
                                TextFieldUi(
                                  fillColor: colorScheme.surfaceDim,
                                  isFilled: true,
                                  hintText: 'Firstname',
                                  controller: _firstnameController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your first name';
                                    } else if (!RegExp(r'^[a-zA-Z]+$')
                                        .hasMatch(value)) {
                                      return 'Only alphabetic characters are allowed';
                                    }
                                    return null;
                                  },
                                ),

                                /// Lastname
                                TextFieldUi(
                                  fillColor: colorScheme.surfaceDim,
                                  isFilled: true,
                                  hintText: 'Lastname',
                                  controller: _lastnameController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your last name';
                                    } else if (!RegExp(r'^[a-zA-Z]+$')
                                        .hasMatch(value)) {
                                      return 'Only alphabetic characters are allowed';
                                    }
                                    return null;
                                  },
                                ),

                                /// Phone Number (+234)
                                TextFieldUi(
                                  fillColor: colorScheme.surfaceDim,
                                  isFilled: true,
                                  hintText: 'Phone number',
                                  controller: _phoneNumberController,
                                  inputFormatter: [PhoneNumberInputFormatter()],
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your phone number';
                                    } else if (!RegExp(r'^\+234\d{10}$')
                                        .hasMatch(value)) {
                                      return 'Enter a valid Nigerian number (e.g., +2349012345678)';
                                    }
                                    return null;
                                  },
                                ),

                                /// Monthly Income
                                TextFieldUi(
                                  fillColor: colorScheme.surfaceDim,
                                  isFilled: true,
                                  hintText: 'Monthly Income',
                                  controller: _salaryController,
                                  inputFormatter: [IncomeInputFormatter()],
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your monthly income';
                                    } else if (!RegExp(r'^[0-9,]+$')
                                        .hasMatch(value)) {
                                      return 'Only numbers are allowed';
                                    }
                                    return null;
                                  },
                                ),

                                20.verticalSpace,
                                PrimaryButtonUi(
                                  size: 54,
                                  onPressed: () async {
                                    if (_SignupFormKey.currentState!
                                        .validate()) {
                                      bool success = await authProvider
                                          .createProfile(Profile(
                                              userId: userId,
                                              email: _emailController.text,
                                              firstname:
                                                  _firstnameController.text,
                                              lastname:
                                                  _lastnameController.text,
                                              phone:
                                                  _phoneNumberController.text,
                                              income: double.parse(
                                                  _salaryController.text
                                                      .replaceAll(',', '')
                                                      .trim())))
                                          .catchError((e) {
                                        ShowNotificationSnack.showError(
                                            context, 'Error', e);
                                      });

                                      if (success) {
                                        Navigator.push(context,
                                            CupertinoPageRoute(builder:
                                                (BuildContext context) {
                                          return SigninScreen();
                                        }));
                                      }
                                    }
                                  },
                                  text: "Continue",
                                  loading: authProvider.isLoading,
                                  textColor:
                                      Theme.of(context).colorScheme.onSecondary,
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                  borderR: Radius.circular(15),
                                  textStyle: bodyMed,
                                ),
                                20.verticalSpace,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  20.verticalSpace,
                ],
              ),
            ),
            20.verticalSpace,
          ],
        ),
      ),
      // )
      // )
    );
  }
}
