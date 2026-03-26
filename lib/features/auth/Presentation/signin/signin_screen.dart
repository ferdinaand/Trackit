import 'dart:ui';

import 'package:TrackIt/Resources/res.dart';
import 'package:TrackIt/features/Navbar/nav_bar.dart';
import 'package:TrackIt/features/auth/Presentation/providers/Authethication_provider.dart';
import 'package:TrackIt/global_widgets/appbar.ui.dart';
import 'package:TrackIt/global_widgets/button.ui.dart';
import 'package:TrackIt/global_widgets/gap.ui.dart';
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

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _signinFormKey = GlobalKey<FormState>();
  // Future<AuthResponse>
  bool doNotShowPassword = true;
  bool stayLoggedIn = false;
  String? _authError;
  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    stayLoggedIn = context.watch<AuthProvider>().rememberMe;

    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        forceMaterialTransparency: true,
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            // print("back");
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back, size: 30),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
            // color: Colors.transparent,
            image: DecorationImage(
                colorFilter: ColorFilter.mode(
                  colorScheme.onSurfaceVariant
                      .withOpacity(1.0), // Apply red tint with 50% opacity
                  BlendMode.srcATop, // Blends color with image
                ),
                image: AssetImage("assets/png/backgroundImg.png"),
                fit: BoxFit.cover)),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height * 0.9,
            ),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

                  // Spacer(),
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurStyle: BlurStyle.outer,
                              blurRadius: 3,
                              offset: const Offset(2, 2),
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
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                                sigmaX: 0,
                                sigmaY:
                                    2), // Increase blur for more glass effect
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
                                key: _signinFormKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Hi, Welcome Back",
                                      style: bodyXLBold.copyWith(fontSize: 24),
                                    ),
                                    0.verticalSpace,
                                    Text(
                                      " Login to continue using our platform",
                                      style: bodyNorm,
                                    ),
                                    20.verticalSpace,

                                    TextFieldUi(
                                      // fillColor: colorScheme.surfaceBright,
                                      fillColor: colorScheme.surfaceDim,
                                      isFilled: true,
                                      hintText: 'Email',
                                      controller: _emailController,
                                      suffixIcon: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 20),
                                        child: SvgPicture.asset(
                                          userIcon,
                                          height: 20,
                                          width: 20,
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your email';
                                        }
                                        if (_authError != null) {
                                          return _authError;
                                        }
                                        return null;
                                      },
                                    ),
                                    // 20.verticalSpace,

                                    TextFieldUi(
                                      obscureText: doNotShowPassword,
                                      suffixIcon: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            doNotShowPassword =
                                                !doNotShowPassword;
                                          });
                                        },
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 15),
                                          child: SvgPicture.asset(
                                            doNotShowPassword
                                                ? eyeIcon
                                                : slashedEyeIcon,
                                            height: 20,
                                            width: 20,
                                          ),
                                        ),
                                      ),
                                      isFilled: true,
                                      // fillColor: colorScheme.surfaceBright,
                                      fillColor: colorScheme.surfaceDim,
                                      hintText: 'Password',
                                      controller: _passwordController,
                                      // decoration: const InputDecoration(labelText: 'Amount'),
                                      // keyboardType: TextInput,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your password';
                                        }
                                        if (!value.contains(RegExp(r'[0-9]'))) {
                                          return 'Please enter a valid password';
                                        }
                                        if (_authError != null) {
                                          return _authError;
                                        }
                                        return null;
                                      },
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Checkbox(
                                                visualDensity:
                                                    const VisualDensity(
                                                  horizontal: VisualDensity
                                                      .minimumDensity,
                                                  vertical: VisualDensity
                                                      .minimumDensity,
                                                ),
                                                value: stayLoggedIn,
                                                onChanged: (val) {
                                                  context
                                                      .read<AuthProvider>()
                                                      .shouldRememberMe(
                                                          !stayLoggedIn);
                                                  setState(() {
                                                    stayLoggedIn =
                                                        !stayLoggedIn;
                                                  });
                                                }),
                                            TextUi.bodySmall(
                                                "Keep me logged in")
                                          ],
                                        ),
                                        TextUi.bodySmall(
                                          "Forgot password",
                                          color: colorScheme.primary,
                                        )
                                      ],
                                    ),
                                    20.verticalSpace,
                                    PrimaryButtonUi(
                                      size: 54,
                                      onPressed: () async {
                                        setState(() {
                                          _authError = null;
                                        });

                                        if (!_signinFormKey.currentState!
                                            .validate()) {
                                          return;
                                        }

                                        try {
                                          final response =
                                              await authProvider.signIn(
                                            _emailController.text.trim(),
                                            _passwordController.text.trim(),
                                          );

                                          if (response?.id != null) {
                                            Navigator.push(context,
                                                CupertinoPageRoute(builder:
                                                    (BuildContext context) {
                                              return NavBar();
                                            }));
                                          }
                                        } catch (e) {
                                          setState(() {
                                            _authError = e
                                                .toString()
                                                .replaceFirst(
                                                    'Exception: ', '');
                                          });
                                          _signinFormKey.currentState!
                                              .validate();
                                        }
                                      },
                                      text: "Login",
                                      loading: authProvider.isLoading,
                                      textColor: Theme.of(context)
                                          .colorScheme
                                          .onSecondary,
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
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      // )
      // )
    );
  }
}
