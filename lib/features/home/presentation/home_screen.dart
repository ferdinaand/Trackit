import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:TrackIt/Resources/colors.res.dart';
import 'package:TrackIt/Resources/typograhy.res.dart';
import 'package:TrackIt/core/Helpers/Helper_class.dart';
import 'package:TrackIt/features/auth/Presentation/providers/Authethication_provider.dart';
import 'package:TrackIt/features/auth/domain/profile_entity.dart';
import 'package:TrackIt/features/home/domain/expense_entity.dart';
import 'package:TrackIt/features/home/presentation/providers/Home_provider.dart';
import 'package:TrackIt/global_widgets/gap.ui.dart';
import 'package:TrackIt/global_widgets/text.ui.dart';
import 'package:TrackIt/features/models/transaction.dart';
import 'package:TrackIt/core/theme/theme_selector.dart';
import 'package:TrackIt/global_widgets/widgets/balance_card.dart';
import 'package:TrackIt/features/Create_budget/new_transaction_form.dart';
import 'package:TrackIt/global_widgets/widgets/transaction_list.dart';
import 'package:TrackIt/utils/format_currency.dart';
// import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../providers/transaction_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum TimeFilter { daily, weekly, monthly, quarterly, yearly, hourly }

class _HomeScreenState extends State<HomeScreen> {
  bool isVisible = false;

//home screen widget config

  String appGroupId = "group.TrackitMobileApp";
  String iosWidgetName = "TrackItWidget";
  String androidWidgetName = "TrackItWidget";
  String dataKey = "text_from_flutter_app";

  Profile? _profile;
  bool _isProfileLoading = true;
  List<Expense>? _expense = [];
  String? _profileError;

  void togglePopWidget(bool value) {
    setState(() {
      isVisible = value;
    });
  }

  @override
  void initState() {
    HomeWidget.setAppGroupId(appGroupId);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserProfile();
    });

    super.initState();
  }

  Future<void> _loadUserProfile() async {
    log('loaded profile');
    final userId = Supabase.instance.client.auth.currentUser?.id;

    if (userId == null) {
      setState(() {
        _profileError = "User not authenticated";
        _isProfileLoading = false;
      });
      return;
    }

    try {
      final profileMap = await context.read<AuthProvider>().getProfile(userId);
      getExpenses();
      if (profileMap != null) {
        setState(() {
          _profile = Profile.fromMap(profileMap);
          _isProfileLoading = false;
        });
        double totalIncome = _profile?.income ?? 0.0;
        final transaction = Transaction(
          title: 'Income',
          amount: totalIncome,
          date: DateTime.now(),
          category: 'income',
          isExpense: false,
        );
        final transactionProvider =
            Provider.of<TransactionProvider>(context, listen: false);

        // Clear previous income transactions
        transactionProvider.transactions
            .where((t) => t.category == 'income' || t.isExpense == false)
            .toList()
            .forEach((t) => transactionProvider.removeTransaction(t.id));

        // Add new income transaction
        transactionProvider.addTransaction(transaction);
      } else {
        setState(() {
          _profileError = "Profile not found";
          _isProfileLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _profileError = e.toString();
        _isProfileLoading = false;
      });
    }
  }

  Future<void> getExpenses() async {
    log('loaded profile');
    final userId = Supabase.instance.client.auth.currentUser?.id;

    if (userId == null) {
      setState(() {
        // _profileError = "User not authenticated";
        // _isProfileLoading = false;
      });
      return;
    }

    try {
      final expenseListMap =
          await context.read<HomeProvider>().getExpense(userId);
      if (expenseListMap != null) {
        final expenses =
            expenseListMap.map<Expense>((e) => Expense.fromMap(e)).toList();

        // Update UI
        setState(() {
          _expense = expenses;
        });

        final transactionProvider =
            Provider.of<TransactionProvider>(context, listen: false);

        // Clear previous income transactions
        transactionProvider.transactions
            .where((t) => t.isExpense == true)
            .toList()
            .forEach((t) => transactionProvider.removeTransaction(t.id));

        // Convert each Expense to a Transaction and add it
        for (final expense in expenses) {
          final transaction = Transaction.fromExpense(expense);
          transactionProvider.addTransaction(transaction);
        }
      }
    } catch (e) {
      setState(() {
        // _profileError = e.toString();
        // _isProfileLoading = false;
      });
    }
  }

  TimeFilter selectedFilter = TimeFilter.hourly;
  double todayTotal = 0;
  double yesterdayTotal = 0;
  String spending = "";
  double difference = 0;
  List<Transaction> _filterTransactions(List<Transaction> transactions) {
    DateTime now = DateTime.now();

    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime yesterday = today.subtract(const Duration(days: 1));

// Filter only expenses
    final expenses = transactions.where((t) => t.isExpense);

// Sum today’s expenses
    todayTotal = expenses
        .where((t) => isSameDay(t.date, today))
        .fold(0, (sum, t) => sum + t.amount);

// Sum yesterday’s expenses
    yesterdayTotal = expenses
        .where((t) => isSameDay(t.date, yesterday))
        .fold(0, (sum, t) => sum + t.amount);

// Compare
    if (todayTotal > yesterdayTotal) {
      spending = "more than";
      difference = todayTotal - yesterdayTotal;
    } else if (todayTotal < yesterdayTotal) {
      spending = "less than";
      difference = yesterdayTotal - todayTotal;
    } else {
      spending = "same as";
      difference = 0;
    }

    return transactions.where((transaction) {
      DateTime transactionDate = transaction.date;
      switch (selectedFilter) {
        case TimeFilter.hourly:
          return DateFormat.H().format(transactionDate) ==
              DateFormat.H().format(now);
        case TimeFilter.daily:
          return DateFormat.yMd().format(transactionDate) ==
              DateFormat.yMd().format(now);
        case TimeFilter.weekly:
          return transactionDate.isAfter(now.subtract(const Duration(days: 7)));
        case TimeFilter.monthly:
          return transactionDate.month == now.month &&
              transactionDate.year == now.year;
        case TimeFilter.quarterly:
          int currentQuarter = ((now.month - 1) ~/ 3) + 1;
          int transactionQuarter = ((transactionDate.month - 1) ~/ 3) + 1;
          return currentQuarter == transactionQuarter &&
              transactionDate.year == now.year;
        case TimeFilter.yearly:
          return transactionDate.year == now.year;
      }
    }).toList();
  }

  List<_ChartData> _getFilteredData(
      List<Transaction> transactions, String filter) {
    final Map<String, double> groupedData = {};

    for (var transaction in transactions) {
      double totalIncome = _profile?.income ?? 0.0;
      if (!transaction.isExpense) {
        totalIncome = totalIncome + transaction.amount;
      }

      // Ignore income, only track expenses

      String timeKey;
      switch (filter) {
        case 'Yearly':
          timeKey = DateFormat.y().format(transaction.date); // "2025", "2026"
          break;
        case 'Monthly':
          timeKey = DateFormat.yMMM()
              .format(transaction.date); // "Jan 2025", "Feb 2025"
          break;
        case 'Weekly':
          timeKey =
              'Week ${DateFormat('w').format(transaction.date)} - ${DateFormat.y().format(transaction.date)}';
          break;
        case 'Daily':
        default:
          timeKey =
              DateFormat.yMMMd().format(transaction.date); // "Mar 1, 2025"
      }

      // Sum up the expenses for each time frame
      groupedData[timeKey] = (groupedData[timeKey] ?? 0) + transaction.amount;
    }

    // Convert the map to a list of _ChartData objects
    return groupedData.entries
        .map((entry) => _ChartData(entry.key, entry.value))
        .toList();
  }

  // late TransactionProvider? transactionProvider;
  void updateIncome() async {
    double totalIncome = _profile?.income ?? 0.0;
    String data = "";
    setState(() {
      data = " ${formatCurrency(totalIncome)}";
    });
    if (Platform.isIOS) {
      await HomeWidget.saveWidgetData(dataKey, data);
      await HomeWidget.updateWidget(
          iOSName: iosWidgetName, androidName: androidWidgetName);
    }
  }

  Widget _buildFilterDropdown() {
    return SizedBox(
      height: 22,
      child: CupertinoButton(
        color: Theme.of(context).highlightColor.withOpacity(0.4),
        padding: EdgeInsets.all(4),
        child: Center(
          child: Row(
            children: [
              Text(
                selectedFilter.name.toUpperCase(),
                style: Theme.of(context).textTheme.bodySmall,

                // .copyWith(color: pgContrastHighEmphasis)
              ),
              Icon(
                Icons.keyboard_arrow_down,
                color: Theme.of(context).hintColor,
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

  @override
  Widget build(BuildContext context) {
    updateIncome();
    final transactions = context.read<TransactionProvider>();
    final transaction = context.read<TransactionProvider>().transactions;
    final balance = transactions.totalBalance;
    final colorScheme = Theme.of(context).colorScheme;

    final filteredTransactions = _filterTransactions(transaction);
    return Scaffold(
      appBar: AnimatedAppBar(
        userName: _profile?.firstname ?? '',
      ),
      // AppBar(
      //   scrolledUnderElevation: 0,
      //   title: Stack(
      //     clipBehavior: Clip.none,
      //     children: [
      //       Positioned(
      //         child:
      //             // Row(
      //             //   // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //             //   children: [
      //             Row(
      //           // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //           children: [
      //             CircleAvatar(
      //               child: Icon(Icons.notifications),
      //             ),
      //             4.horizontalSpace,
      //             // SizedBox(width: 10),
      //             CircleAvatar(
      //               child: ThemeSelector(),
      //             )
      //           ],
      //         ),
      //         //   ],
      //         // ),
      //       ),
      //       Positioned(
      //         child: CircleAvatar(
      //           child: Image.asset('assets/png/Trainers.png'),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
      body: GestureDetector(
        onTap: () {
          setState(() {
            isVisible = false;
          });
        },
        child: _isProfileLoading
            ? Center(child: CircularProgressIndicator())
            : _profileError != null
                ? Center(child: Text("Error: $_profileError"))
                : AnimatedContainer(
                    margin: EdgeInsets.only(top: 20),
                    duration: Duration(milliseconds: 600),
                    decoration: BoxDecoration(
                      color: colorScheme.onSecondaryContainer
                          .withOpacity(0.2), // Slight white overlay
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.only(top: 24),
                    child: SingleChildScrollView(
                      // child: Container(
                      //   // decoration: BoxDecoration(
                      //   //     gradient: RadialGradient(
                      //   //   colors: [
                      //   //     colorScheme.surface,
                      //   //     colorScheme.onPrima,
                      //   //   ],
                      //   //   stops: [0.0, 2.0],
                      //   // )),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 24, right: 24, top: 0, bottom: 200),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [],
                            ),
                            BalanceCard(
                              spending: spending,
                              difference: difference,
                              balance: _profile?.income ?? 0.0,
                            ),
                            30.verticalSpace,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextUi.bodySmall('Recent transactions'),
                                GestureDetector(
                                    onTap: () {},
                                    child: TextUi.bodySmallBold('View more')),
                              ],
                            ),
                            8.verticalSpace,
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.2,
                              child: TransactionList(),
                            ),
                            30.verticalSpace,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextUi.bodySmall('Transactions  overview'),
                                _buildFilterDropdown(),
                              ],
                            ),
                            8.verticalSpace,
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.4,
                              child: _buildTransactionsChart(transaction,
                                  colorScheme, context, selectedFilter.name),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // floatingActionButton: Stack(
      //   alignment: Alignment.bottomCenter,
      //   clipBehavior: Clip.none,
      //   children: [
      //     popWidget(
      //       onVisibilityChange: togglePopWidget,
      //       isVisible: isVisible,
      //     ),
      //     FloatingActionButton(
      //       onPressed: () {
      //         // showModalBottomSheet(
      //         //   context: context,
      //         //   isScrollControlled: true,
      //         //   builder: (context) => const
      //         // );
      //         setState(() {
      //           isVisible = !isVisible;
      //         });
      //       },
      //       child: const Icon(Icons.add),
      //     ),
      //   ],
      // ),
    );
  }
}

Widget _buildTransactionsChart(List<Transaction> transactions,
    ColorScheme colorScheme, BuildContext context, String selectedFilter) {
  // Group transactions by category
  bool isIncreased = true;
  double percentageChange = 0.0;
  Map<String, double> categoryTotals = {};
  for (var transaction in transactions) {
    if (!transaction.isExpense) continue; // Ignore income, track only expenses

    String timeKey;
    switch (selectedFilter) {
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
        timeKey = DateFormat.yMMMd().format(transaction.date); // "Mar 1, 2025"
    }

    // Sum up the expenses for each time frame
    categoryTotals[timeKey] =
        (categoryTotals[timeKey] ?? 0) + transaction.amount;

    final expenseTransactions = transactions.where((t) => t.isExpense).toList()
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

  return Stack(
    children: [
      Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.black.withOpacity(0.1),
          //     blurStyle: BlurStyle.outer,
          //     blurRadius: 10,
          //     offset: const Offset(0, 0),
          //   )
          // ],
          border: Border.all(color: Colors.white),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              width: double.infinity,
              height: 300,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.onSurface.withOpacity(0.3),
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
                  plotOffset: 10,
                  borderColor: Colors.transparent,
                  isVisible: false,
                  labelFormat: '\${value}',
                ),
                series: <CartesianSeries<dynamic, dynamic>>[
                  ColumnSeries<_ChartData, String>(
                    width: 0.1,
                    spacing: 0.3,
                    dataSource: chartData,
                    xValueMapper: (_ChartData data, _) => data.timeFrame,
                    yValueMapper: (_ChartData data, _) => data.totalExpense,
                    color: colorScheme.onSurface,
                    borderRadius: BorderRadius.circular(10),
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
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

/// Expense Indicator Widget
class ExpenseIndicator extends StatelessWidget {
  final double totalExpense;
  final bool isIncreased;
  final double increment;

  const ExpenseIndicator({
    super.key,
    required this.totalExpense,
    required this.isIncreased,
    required this.increment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white, // 🔹 White Background
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(2, 2),
          )
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(formatCurrency(totalExpense),
              style:
                  bodyLBold.copyWith(height: 1, color: pgContrastHighEmphasis)),
          8.horizontalSpace,
          Row(
            children: [
              Text(
                '% $increment',
                style: bodyXSmall.copyWith(color: pgContrastHighEmphasis),
              ),
              2.horizontalSpace,
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isIncreased ? Colors.green[400] : Colors.red[400],
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
// floatingActionButton: FloatingActionButton(
//   onPressed: () {

//   },
//   child: const Icon(Icons.add),

class AnimatedAppBar extends StatefulWidget implements PreferredSizeWidget {
  const AnimatedAppBar({super.key, required this.userName});
  final String userName;
  @override
  _AnimatedAppBarState createState() => _AnimatedAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _AnimatedAppBarState extends State<AnimatedAppBar> {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        _isVisible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      scrolledUnderElevation: 0,
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: AnimatedSlide(
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOut,
                offset: _isVisible ? Offset.zero : const Offset(-0.3, 0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Theme.of(context).splashColor,
                      child: const CircleAvatar(
                        radius: 18,
                        backgroundImage: AssetImage('assets/png/Trainers.png'),
                      ),
                    ),
                    10.horizontalSpace,
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextUi.bodyNorm('Good ${getGreeting()},'),
                        TextUi.bodyMedBold(widget.userName),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [],
            ),
          ],
        ),
      ),
    );
  }
}

String getGreeting() {
  final time = DateTime.now().hour;

  switch (time) {
    case >= 0 && < 12:
      return 'Morning';
    case >= 12 && < 16:
      return 'Afternoon';

    case >= 16 && < 23:
      return 'Evening';
    default:
      return "Morning";
  }
}
