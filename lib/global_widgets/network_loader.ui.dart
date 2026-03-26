import 'package:flutter/material.dart';
import 'package:TrackIt/global_widgets/text.ui.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:TrackIt/Resources/res.dart';
import 'gap.ui.dart';

class NetworkLoaderUi extends StatelessWidget {
  const NetworkLoaderUi({super.key, required this.message});
  final String message;

  Future<bool> _onWillPop() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop, //Disable back button when loader is up
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SpinKitRipple(
              color: successDark,
              size: 40,
            ),
            const Gap(
              10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: TextUi(
                message,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
