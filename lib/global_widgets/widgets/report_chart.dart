import 'dart:ui';

import 'package:TrackIt/Resources/colors.res.dart';
import 'package:TrackIt/Resources/typograhy.res.dart';
import 'package:TrackIt/features/home/presentation/home_screen.dart';
import 'package:TrackIt/features/models/transaction.dart';
import 'package:TrackIt/utils/format_currency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ReportChart extends StatefulWidget {
  const ReportChart(
      {this.selectedFilter,
      required this.transactions,
      required this.colorScheme,
      super.key});

  final ColorScheme colorScheme;
  final String? selectedFilter;
  final List<Transaction> transactions;
  @override
  State<ReportChart> createState() => _ReportChartState();
}

class _ReportChartState extends State<ReportChart> {
  @override
  Widget build(BuildContext context) {
    Map<String, double> categoryTotals = {};
    bool isIncreased = true;
    double percentageChange = 0.0;
    for (var transaction in widget.transactions) {
      if (!transaction.isExpense)
        continue; // Ignore income, track only expenses

      String timeKey;
      switch (widget.selectedFilter) {
        case 'hourly':
          timeKey = DateFormat('d MMM h a').format(transaction.date);

          break;
        case 'yearly':
          timeKey = DateFormat.y().format(transaction.date); // "2025", "2026"
          break;
        case 'monthly':
          timeKey = DateFormat.yMMM().format(transaction.date); // "Mar 2025"
          break;
        case 'weekly':
          DateTime firstDayOfMonth =
              DateTime(transaction.date.year, transaction.date.month, 1);
          int weekOfMonth = ((transaction.date.day - 1) ~/ 7) + 1;
          timeKey =
              'Week $weekOfMonth of ${DateFormat.MMM().format(transaction.date)}, ${transaction.date.year}';
          break;
        case 'daily':
        default:
          timeKey =
              DateFormat.yMMMd().format(transaction.date); // "Mar 1, 2025"
      }

      // Sum up the expenses for each time frame
      categoryTotals[timeKey] =
          (categoryTotals[timeKey] ?? 0) + transaction.amount;

      final expenseTransactions = widget.transactions
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
    }

    // Convert to chart data
    List<_ChartData> chartData = categoryTotals.entries
        .map((entry) => _ChartData(entry.key, entry.value))
        .toList();

    // Calculate Total Expense
    double totalExpense =
        chartData.fold(0, (sum, data) => sum + data.totalExpense);

    // 🔹 Control Arrow Direction (true = up, false = down)

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.black.withOpacity(0.1),
            //     blurStyle: BlurStyle.outer,
            //     blurRadius: 10,
            //     offset: const Offset(0, 0),
            //   )
            // ],
            color: Theme.of(context).cardColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                width: double.infinity,
                height: 400,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: widget.colorScheme.onSurface.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SfCartesianChart(
                  borderColor: Colors.transparent,
                  plotAreaBackgroundColor: Colors.transparent,
                  plotAreaBorderColor: Colors.transparent,
                  primaryXAxis: CategoryAxis(
                    borderColor: Colors.transparent,
                  ),
                  primaryYAxis: NumericAxis(
                    plotOffset: 30,
                    borderColor: Colors.transparent,
                    isVisible: false,
                    labelFormat: '₦{value}',
                  ),
                  series: <CartesianSeries<dynamic, dynamic>>[
                    LineSeries<_ChartData, String>(
                      width: 3,
                      // spacing: 0.4,
                      dataSource: chartData,
                      xValueMapper: (_ChartData data, _) => data.timeFrame,
                      yValueMapper: (_ChartData data, _) => data.totalExpense,
                      color: widget.colorScheme.onSurface,
                      // borderRadius: BorderRadius.circular(8),
                      dataLabelSettings:
                          const DataLabelSettings(isVisible: true),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // 🔹 Positioned Expense Indicator Widget (Top-Right Corner)
        Positioned(
          top: 8,
          left: 8,
          child: ExpenseIndicator(
            totalExpense: totalExpense,
            isIncreased: isIncreased,
            increment: double.parse(percentageChange.toStringAsFixed(2)),
          ),
        ),
      ],
    );
  }
}

final List<ChartData> chartData = [
  ChartData(1, 35),
  ChartData(2, 23),
  ChartData(3, 34),
  ChartData(4, 25),
  ChartData(5, 40)
];

class ChartData {
  ChartData(this.x, this.y);
  final int x;
  final double y;
}

class _ChartData {
  final String timeFrame; // "2025", "Jan 2025", "Week 3 - 2025"
  final double totalExpense; // Sum of expenses

  _ChartData(this.timeFrame, this.totalExpense);
}
