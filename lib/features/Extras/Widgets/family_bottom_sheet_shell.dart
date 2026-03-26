import 'package:TrackIt/Resources/res.dart';
import 'package:TrackIt/features/Extras/Widgets/custom_back_button.dart';
import 'package:flutter/material.dart';

class FamilyBottomSheetShell extends StatelessWidget {
  const FamilyBottomSheetShell({
    super.key,
    required this.headerText,
    required this.children,
  });

  final String headerText;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 386),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // -- Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  child: Text(
                    headerText,
                    style: bodyLBold.copyWith(color: grayScale50),
                    overflow: TextOverflow.clip,
                    maxLines: 1,
                  ),
                ),
                CustomBackButton(),
              ],
            ),
            const SizedBox(height: 20),

            // -- Divider
            Divider(
              color: grayScale50,
            ),
            const SizedBox(height: 20),

            // -- Content
            ...children,
          ],
        ),
      ),
    );
  }
}
