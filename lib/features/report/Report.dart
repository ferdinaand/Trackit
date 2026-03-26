import 'dart:ui';

import 'package:TrackIt/Resources/colors.res.dart';
import 'package:TrackIt/Resources/typograhy.res.dart';
import 'package:TrackIt/features/home/presentation/home_screen.dart';
import 'package:TrackIt/features/models/transaction.dart';
import 'package:TrackIt/features/providers/transaction_provider.dart';
import 'package:TrackIt/global_widgets/appbar.ui.dart';
import 'package:TrackIt/global_widgets/gap.ui.dart';
import 'package:TrackIt/global_widgets/widgets/report_chart.dart';
import 'package:TrackIt/utils/format_currency.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class Report extends StatefulWidget {
  const Report({super.key});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  TimeFilter selectedFilter = TimeFilter.hourly;

  Widget _buildFilterDropdown() {
    return SizedBox(
      height: 22,
      child: CupertinoButton(
        color: Colors.white,
        padding: EdgeInsets.all(4),
        child: Center(
          child: Row(
            children: [
              Text(
                selectedFilter.name.toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(height: 1, color: pgContrastHighEmphasis),

                // .copyWith(color: pgContrastHighEmphasis)
              ),
              Icon(
                Icons.keyboard_arrow_down,
                color: pgContrastHighEmphasis,
                size: 15,
              ),
            ],
          ),
        ),
        onPressed: () {
          showCupertinoModalPopup(
            context: context,
            builder: (_) => CupertinoActionSheet(
              title: const Text("Select Time Filter"),
              actions: TimeFilter.values.map((filter) {
                return CupertinoActionSheetAction(
                  onPressed: () {
                    setState(() {
                      selectedFilter = filter;
                    });
                    Navigator.pop(context);
                  },
                  child: Text(
                    filter.name.toUpperCase(),
                    style: bodySmall,
                  ),
                );
              }).toList(),
              cancelButton: CupertinoActionSheetAction(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
            ),
          );
        },
      ),
    );
  }
  //   double _progress = 0.10;

  // void incrementProgress() {
  //   setState(() {
  //     _progress = (_progress + 0.01).clamp(0.0, 1.0);
  // //   });
  // }

  @override
  Widget build(BuildContext context) {
    final allTransactions = context.read<TransactionProvider>();
    final transactions = context.read<TransactionProvider>().transactions;
    final balance = allTransactions.totalBalance;
    final colorScheme = Theme.of(context).colorScheme;
    // Map<String, double> categoryTotals = {};
    double totalExpense = 0;
    double totalIncome = 0;
    double percentageChange = 0.0;
    List expenses = [];

    Transaction? highestExpense;
    Transaction? lowestExpense;

    Transaction? highestLastMonthExpense;
    Transaction? lowestLastMonthExpense;
    bool isIncreased = true;
    for (var transaction in transactions) {
      if (!transaction.isExpense) {
        totalIncome = totalIncome + transaction.amount;
      } // Ignore income, track only expenses
      else if (transaction.isExpense) {
        // Sum up the expenses for each time frame
        totalExpense = totalExpense + transaction.amount;
      }
      // String timeKey;
      // switch (widget.selectedFilter) {
      //   case 'hourly':
      //     timeKey = DateFormat('E d MMM h a').format(transaction.date);

      //     break;
      //   case 'yearly':
      //     timeKey = DateFormat.y().format(transaction.date); // "2025", "2026"
      //     break;
      //   case 'monthly':
      //     timeKey = DateFormat.yMMM().format(transaction.date); // "Mar 2025"
      //     break;
      //   case 'weekly':
      //     DateTime firstDayOfMonth =
      //         DateTime(transaction.date.year, transaction.date.month, 1);
      //     int weekOfMonth = ((transaction.date.day - 1) ~/ 7) + 1;
      //     timeKey =
      //         'Week $weekOfMonth of ${DateFormat.MMM().format(transaction.date)}, ${transaction.date.year}';
      //     break;
      //   case 'daily':
      //   default:
      //     timeKey =
      //         DateFormat.yMMMd().format(transaction.date); // "Mar 1, 2025"
      // }

      final expenseTransactions = transactions
          .where((t) => t.isExpense)
          .toList()
        ..sort((a, b) => b.date.compareTo(a.date)); // Sort by date descending

      if (expenseTransactions.length >= 2) {
        final mostRecent = expenseTransactions[0];
        final secondMostRecent = expenseTransactions[1];

        if (mostRecent.amount > secondMostRecent.amount) {
          isIncreased = true;

          // Calculate percentage change: ((new - old) / old) * 100
          percentageChange = ((mostRecent.amount - secondMostRecent.amount) /
                  secondMostRecent.amount) *
              100;
        } else {
          isIncreased = false;

          // Optional: still calculate drop
          percentageChange = ((secondMostRecent.amount - mostRecent.amount) /
                  secondMostRecent.amount) *
              100;
        }
      }

      List<Transaction> expenses =
          transactions.where((t) => t.isExpense).toList();

      DateTime now = DateTime.now();
      DateTime firstDayOfLastMonth = DateTime(now.year, now.month - 1, 1);
      DateTime firstDayOfThisMonth = DateTime(now.year, now.month, 1);

// 🔹 Highest & Lowest (All time)
      if (expenses.isNotEmpty) {
        expenses.sort((a, b) => b.amount.compareTo(a.amount)); // Descending
        highestExpense = expenses.first;

        expenses.sort((a, b) => a.amount.compareTo(b.amount)); // Ascending
        lowestExpense = expenses.first;
      }

// 🔹 Filter last month's expenses
      List<Transaction> lastMonthExpenses = expenses.where((t) {
        return t.date.isAfter(
                firstDayOfLastMonth.subtract(const Duration(seconds: 1))) &&
            t.date.isBefore(firstDayOfThisMonth);
      }).toList();

// 🔹 Highest & Lowest (Last month)
      if (lastMonthExpenses.isNotEmpty) {
        lastMonthExpenses.sort((a, b) => b.amount.compareTo(a.amount));
        highestLastMonthExpense = lastMonthExpenses.first;

        lastMonthExpenses.sort((a, b) => a.amount.compareTo(b.amount));
        lowestLastMonthExpense = lastMonthExpenses.first;
      }
    }

    // Convert to chart data
    // expenses = categoryTotals.entries.map((entry) => entry).toList();

    // // Calculate Total Expense
    // double totalExpense =
    //     expenses.fold(0, (sum, data) => sum + data.totalExpense);

    // final filteredTransactions = _filterTransactions(transaction);
    return Scaffold(
        appBar: MainAppbarUi(
          backgroundColor: colorScheme.surface,
          title: "Report",
          titleColor: colorScheme.inverseSurface,
          showBackButton: false,
        ),
        body: SafeArea(
            bottom: false,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 600),
              decoration: BoxDecoration(
                color: colorScheme.onSecondaryContainer
                    .withOpacity(0.2), // Slight white overlay
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.only(top: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 24, right: 24, top: 24, bottom: 24),
                      child: Stack(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.3,
                            child: ReportChart(
                              transactions: transactions,
                              colorScheme: colorScheme,
                              selectedFilter: selectedFilter.name,
                            ),
                          ),
                          Positioned(
                              top: 10, right: 10, child: _buildFilterDropdown())
                        ],
                      ),
                    ),
                    20.verticalSpace,
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      // Remove fixed height to let it expand naturally
                      child: SizedBox(
                        height:
                            160, // Keep height constraint here to allow horizontal scroll
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap:
                              true, // ensures size wraps around children
                          clipBehavior: Clip.hardEdge,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          children: [
                            expenseWidget(
                              balance: highestExpense!.amount,
                              isIncreased: isIncreased,
                              amountSpent: totalExpense,
                              title: "Highest Expense",
                            ),
                            10.horizontalSpace,
                            expenseWidget(
                              color: Colors.purple.withOpacity(0.07),
                              Icon: "assets/png/lowExpenseSvg.svg",
                              balance: lowestExpense!.amount,
                              isIncreased: false,
                              amountSpent: totalExpense,
                              title: "Lowest Expense",
                            ),
                          ],
                        ),
                      ),
                    ),
                    40.verticalSpace,
                    transactionTypeWidget(
                        colorScheme: colorScheme,
                        isIncome: true,
                        totalIncome: totalIncome),
                    20.verticalSpace,
                    transactionTypeWidget(
                        totalExpense: totalExpense,
                        colorScheme: colorScheme,
                        transactionType: "Expense",
                        isIncome: false,
                        totalIncome: totalIncome),
                    100.verticalSpace,
                  ],
                ),
              ),
            )));
  }
}

class transactionTypeWidget extends StatelessWidget {
  transactionTypeWidget(
      {super.key,
      required this.colorScheme,
      required this.isIncome,
      required this.totalIncome,
      this.totalExpense,
      this.transactionType});

  final ColorScheme colorScheme;
  final bool isIncome;
  final double totalIncome;
  final String? transactionType;
  final double? totalExpense;
  num progress = 0;

  @override
  Widget build(BuildContext context) {
    double progress = (totalIncome > 0 && totalExpense != null)
        ? (totalExpense! / totalIncome)
        : 0.0;

    progress = progress.clamp(0.0, 1.0);

    if (totalExpense == null) {
      progress = totalIncome;
    }

    return Container(
      margin: EdgeInsets.only(
        left: 24,
        right: 24,
      ),
      padding: EdgeInsets.all(0),
      // height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.1),
        //     blurStyle: BlurStyle.outer,
        //     blurRadius: 10,
        //     offset: const Offset(0, 0),
        //   )
        // ],
        // color: colorScheme.inverseSurface.withOpacity(0.12) ?? white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white),
      ),

      child: ClipRRect(
        // Clip the blur effect to match border radius
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(
              sigmaX: 10, sigmaY: 10), // Increase blur for more glass effect
          child: Container(
            // width: 100,
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                isIncome ? Colors.green[400] : Colors.red[400],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Image.asset(
                              isIncome
                                  ? "assets/png/priceUp.png"
                                  : "assets/png/priceDown.png",
                              // color:
                              //     isIncome ? Colors.green : Colors.red, // 🔹 Arrow Color
                              height: 8, width: 8,
                            ),
                          ),
                        ),
                        5.horizontalSpace,
                        Text(
                          transactionType ?? 'Income',
                          style: bodySmallBold.copyWith(),
                        ),
                      ],
                    ),
                    Text(
                      formatCurrency(totalExpense ?? totalIncome ?? 0),
                      style: bodySmallBold.copyWith(
                        color: isIncome ? Colors.green[200] : Colors.red[700],
                      ),
                    ),
                  ],
                ),
                20.verticalSpace,
                LinearProgressIndicator(
                  semanticsValue: progress.toString(),
                  value: progress.toDouble(),
                  borderRadius: BorderRadius.circular(10),
                  minHeight: 15,
                  color: isIncome ? Colors.green[400] : Colors.red[400],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class expenseWidget extends StatelessWidget {
  const expenseWidget({
    super.key,
    required this.balance,
    required this.isIncreased,
    this.percentChange,
    this.amountSpent,
    this.color,
    this.Icon,
    this.title,
  });

  final double balance;
  final String? title;
  final bool isIncreased;
  final double? amountSpent;
  final Color? color;
  final String? Icon;
  final String? percentChange;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.all(0),
      // height: 150,
      // width: 280,
      decoration: BoxDecoration(
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.1),
        //     blurStyle: BlurStyle.outer,
        //     blurRadius: 10,
        //     offset: const Offset(0, 0),
        //   )
        // ],
        // color: colorScheme.inverseSurface.withOpacity(0.12) ?? white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white),
      ),

      child: ClipRRect(
        // Clip the blur effect to match border radius
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(
              sigmaX: 10, sigmaY: 10), // Increase blur for more glass effect
          child: Container(
            // width: 100,
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                          color: color ?? Colors.pink.withOpacity(0.07),
                          borderRadius: BorderRadius.circular(10)),
                      padding: EdgeInsets.all(12),
                      child: SvgPicture.asset(
                          Icon ?? "assets/png/highExpenseSvg.svg"),
                    ),
                    10.horizontalSpace,
                    Text(
                      title ?? 'Highest Expense',
                      style: bodyNorm.copyWith(
                        color: grayScale50,
                        fontWeight: FontWeight.w900,
                      ),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("- ${formatCurrency(balance)}",
                            style: heading5.copyWith(
                              color: grayScale50,
                              height: 1,
                            )),
                        10.horizontalSpace,
                        Row(
                          children: [
                            // Text(
                            //   percentChange ?? '2.4%',
                            //   style: bodySmallBold.copyWith(
                            //     color: isIncreased
                            //         ? Colors.green[400]
                            //         : Colors.red[400],
                            //   ),
                            // ),
                            5.horizontalSpace,
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isIncreased
                                    ? Colors.green[400]
                                    : Colors.red[400],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Image.asset(
                                  isIncreased
                                      ? "assets/png/priceUp.png"
                                      : "assets/png/priceDown.png",
                                  // color:
                                  //     isIncreased ? Colors.green : Colors.red, // 🔹 Arrow Color
                                  height: 8, width: 8,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    5.horizontalSpace,
                    RichText(
                        text: TextSpan(
                            text: " Last month you spent  ",
                            style: bodySmall.copyWith(
                                color: grayScale50, fontSize: 12),
                            children: [
                          TextSpan(
                              text: formatCurrency(amountSpent ?? 500),
                              style: bodySmall.copyWith(color: grayScale700))
                        ]))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
