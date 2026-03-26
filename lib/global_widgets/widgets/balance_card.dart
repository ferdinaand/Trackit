import 'dart:ui';

import 'package:TrackIt/Resources/colors.res.dart';
import 'package:TrackIt/Resources/res.dart';
import 'package:TrackIt/global_widgets/gap.ui.dart';
import 'package:TrackIt/global_widgets/text.ui.dart';
import 'package:TrackIt/features/providers/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../utils/format_currency.dart';

class BalanceCard extends StatelessWidget {
  final double balance;
  final double difference;
  final String spending;
  const BalanceCard(
      {super.key,
      required this.balance,
      required this.difference,
      required this.spending});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Consumer<TransactionProvider>(
      builder: (context, transactionProvider, _) {
        return Container(
          decoration: BoxDecoration(
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.black.withOpacity(0.1),
            //     blurStyle: BlurStyle.outer,
            //     blurRadius: 10,
            //     offset: const Offset(0, 0),
            //   )
            // ],
            color: Theme.of(context)
                .cardColor
                .withOpacity(0.2), // Lower opacity for a frosted glass effect
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white), // Soft white border
          ),
          child: ClipRRect(
            // Clip the blur effect to match border radius
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                  sigmaX: 10,
                  sigmaY: 10), // Increase blur for more glass effect
              child: Container(
                width: double.infinity,
                // height: 200,
                // margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                // padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.onSurface
                      .withOpacity(0.3), // Slight white overlay
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextUi.bodyXSmallBold(
                      color: white,
                      'Available Balance:',
                    ),
                    const SizedBox(height: 8),
                    TextUi.heading5(
                      formatCurrency(balance),
                      color: white,
                      // style: const TextStyle(
                      //   color: Colors.white,
                      //   fontSize: 24,
                      //   fontWeight: FontWeight.bold,
                      // ),
                    ),
                    10.verticalSpace,
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(2, 2),
                          )
                        ],
                        color: white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: SizedBox(
                        width: 50,
                        child: RichText(
                          text: TextSpan(
                            text: 'Today you spent ',
                            style: bodySmall.copyWith(
                                color: pgContrastHighEmphasis),
                            children: <TextSpan>[
                              TextSpan(
                                text:
                                    '${formatCurrency(difference)} $spending ',
                                style: bodySmallBold.copyWith(
                                    color: pgContrastHighEmphasis),
                              ),
                              TextSpan(
                                text: 'yesterday. ',
                                style: bodySmall.copyWith(
                                    color: pgContrastHighEmphasis),
                              ),
                              // TextSpan(
                              //   text: '\$510 less ',
                              //   style: bodySmallBold.copyWith(
                              //       color: pgContrastHighEmphasis),
                              // ),
                              // TextSpan(
                              //   text: 'compared to last month.',
                              //   style: bodySmall.copyWith(
                              //       color: pgContrastHighEmphasis),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        //
        // Container(
        //
        //   decoration: BoxDecoration(
        //     color: Theme.of(context).cardColor.withOpacity(0.90),
        //     borderRadius: BorderRadius.circular(20),
        //   ),
        //   child:
        // );
      },
    );
  }
}
