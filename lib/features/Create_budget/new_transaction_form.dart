import 'dart:ui';

import 'package:TrackIt/Resources/res.dart';
import 'package:TrackIt/Resources/typograhy.res.dart';
import 'package:TrackIt/features/home/domain/expense_entity.dart';
import 'package:TrackIt/features/home/presentation/providers/Home_provider.dart';
import 'package:TrackIt/global_widgets/appbar.ui.dart';
import 'package:TrackIt/global_widgets/button.ui.dart';
import 'package:TrackIt/global_widgets/gap.ui.dart';
import 'package:TrackIt/global_widgets/notification_snackbar.dart';
import 'package:TrackIt/global_widgets/textfield.ui.dart';
import 'package:TrackIt/global_widgets/widgets/transaction_list.dart';
import 'package:TrackIt/features/models/transaction.dart';
import 'package:TrackIt/features/providers/category_provider.dart';
import 'package:TrackIt/features/providers/transaction_provider.dart';
import 'package:TrackIt/utils/format_currency.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NewTransactionForm extends StatefulWidget {
  const NewTransactionForm(
      {super.key, this.isVisible = false, required this.onClose});
  final bool isVisible;
  final VoidCallback onClose;

  @override
  State<NewTransactionForm> createState() => _NewTransactionFormState();
}

class _NewTransactionFormState extends State<NewTransactionForm> {
  final _incomeFormKey = GlobalKey<FormState>();
  final _ExpenseFormKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  String _selectedCategory = 'Other';
  bool _isExpense = true;
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final homeProvider = context.watch<HomeProvider>();
    final isLoading = homeProvider.isLoading;
    final userId = Supabase.instance.client.auth.currentUser!.id;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: MainAppbarUi(
        backgroundColor: colorScheme.surface,
        title: "Add Expense",
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
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 16,
              ),
              child: Form(
                key: _ExpenseFormKey,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Row(
                    //   children: [
                    //     const Text('Transaction Type:'),
                    //     Switch(
                    //       value: _isExpense,
                    //       onChanged: (value) {
                    //         setState(() {
                    //           _isExpense = value;
                    //         });
                    //       },
                    //     ),
                    //     Text(_isExpense ? 'Expense' : 'Income'),
                    //   ],
                    // ),

                    AnimatedContainer(
                      duration: Duration(milliseconds: 1000),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            scale: 0.5,
                            image: AssetImage(
                              getCategoryIcon(
                                  getCategoryEnum(_selectedCategory)),
                            )),
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Colors.black.withOpacity(0.1),
                        //     blurStyle: BlurStyle.outer,
                        //     blurRadius: 10,
                        //     offset: const Offset(0, 0),
                        //   )
                        // ],
                        color: Theme.of(context).cardColor.withOpacity(
                            0.2), // Lower opacity for a frosted glass effect
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: white), // Soft white border
                      ),
                      child: ClipRRect(
                        // Clip the blur effect to match border radius
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                              sigmaX: 10,
                              sigmaY:
                                  10), // Increase blur for more glass effect
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
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Category",
                                  style: bodySmallBold.copyWith(
                                      color: grayScale50),
                                ),
                                5.verticalSpace,
                                Consumer<CategoryProvider>(
                                  builder: (context, categoryProvider, _) {
                                    return CustomDropdown<String>(
                                      initialItem: _selectedCategory,
                                      // value: _selectedCategory,
                                      items: categoryProvider.categories
                                          .map((category) => category)
                                          .toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedCategory = value!;
                                        });
                                      },
                                      decoration: CustomDropdownDecoration(
                                        prefixIcon: Container(
                                          height: 30,
                                          width: 30,
                                          margin: EdgeInsets.all(0),
                                          decoration: BoxDecoration(
                                              // color: colorScheme.primary,
                                              borderRadius:
                                                  BorderRadius.circular(7.5)),
                                          child: Image.asset(
                                            getCategoryIcon(getCategoryEnum(
                                                _selectedCategory)),
                                          ),
                                        ),
                                        listItemDecoration:
                                            ListItemDecoration(),
                                        expandedFillColor:
                                            colorScheme.surfaceBright,
                                        // colorScheme.surfaceBright,
                                        closedFillColor:
                                            colorScheme.surfaceBright,
                                        // colorScheme.surfaceBright,
                                        // closedFillColor: colorScheme.surface,
                                        hintStyle: bodySmallBold,
                                        closedBorderRadius:
                                            const BorderRadius.all(
                                                Radius.circular(15)),
                                        closedBorder: Border.all(
                                            color: colorScheme.outline),
                                        headerStyle: bodySmallBold,
                                        listItemStyle: bodySmallBold,
                                      ),
                                    );
                                  },
                                ),
                                20.verticalSpace,
                                Text(
                                  "Title",
                                  style: bodySmallBold.copyWith(
                                      color: grayScale50),
                                ),
                                5.verticalSpace,
                                TextFieldUi(
                                  // fillColor: colorScheme.surfaceBright,
                                  fillColor: colorScheme.surfaceBright,
                                  isFilled: true,
                                  hintText: 'Title',
                                  controller: _titleController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a title';
                                    }
                                    return null;
                                  },
                                ),
                                // 20.verticalSpace,
                                Text(
                                  "Amount",
                                  style: bodySmallBold.copyWith(
                                      color: grayScale50),
                                ),
                                5.verticalSpace,
                                TextFieldUi(
                                  isFilled: true,
                                  // fillColor: colorScheme.surfaceBright,
                                  fillColor: colorScheme.surfaceBright,
                                  hintText: formatCurrency(0.0),
                                  controller: _amountController,
                                  // decoration: const InputDecoration(labelText: 'Amount'),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter an amount';
                                    }
                                    if (double.tryParse(value) == null) {
                                      return 'Please enter a valid number';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    20.verticalSpace,
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
                        color: Theme.of(context).cardColor.withOpacity(
                            0.2), // Lower opacity for a frosted glass effect
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: white), // Soft white border
                      ),
                      child: ClipRRect(
                        // Clip the blur effect to match border radius
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                              sigmaX: 10,
                              sigmaY:
                                  10), // Increase blur for more glass effect
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
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Add a note",
                                  style: bodySmallBold.copyWith(
                                      color: grayScale50),
                                ),
                                5.verticalSpace,
                                TextFieldUi(
                                  textFieldHeight: 200,
                                  maxLines: 50,
                                  isFilled: true,
                                  fillColor: colorScheme.surfaceBright,
                                  hintText: "Add a few notes to help you later",
                                  controller: _noteController,
                                  // decoration: const InputDecoration(labelText: 'Amount'),
                                  keyboardType: TextInputType.text,
                                  // validator: (value) {
                                  //   if (value == null || value.isEmpty) {
                                  //     return 'Please enter an amount';
                                  //   }
                                  //   if (double.tryParse(value) == null) {
                                  //     return 'Please enter a valid number';
                                  //   }
                                  //   return null;
                                  // },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    40.verticalSpace,

                    Row(children: [
                      Expanded(
                        child: PrimaryButtonUi(
                          borderR: Radius.circular(15),
                          textColor: Theme.of(context).colorScheme.primary,
                          color: Theme.of(context).colorScheme.primary,

                          backgroundColor:
                              Theme.of(context).colorScheme.surfaceBright,
                          // backgroundColor:
                          //     Theme.of(context).colorScheme.onSecondaryFixed,
                          text: "Clear",
                          textStyle: bodyMed,
                          onPressed: () {
                            _amountController.clear();
                            _titleController.clear();
                            setState(() {
                              _selectedCategory = 'Other';
                            });
                          },
                        ),
                      ),
                      10.horizontalSpace,
                      Expanded(
                          child: PrimaryButtonUi(
                        borderR: Radius.circular(15),
                        color: Theme.of(context).colorScheme.primary,
                        textStyle: bodyMed,
                        textColor: Theme.of(context).colorScheme.secondaryFixed,
                        loading: isLoading,
                        backgroundColor:
                            Theme.of(context).colorScheme.onSecondaryFixed,
                        // backgroundColor:
                        //     Theme.of(context).colorScheme.onSecondaryFixed,
                        text: "Save",
                        onPressed: () async {
                          if (_ExpenseFormKey.currentState!.validate()) {
                            bool success = await homeProvider.saveExpense([
                              Expense(
                                id: '',
                                title: _titleController.text.trim(),
                                amount:
                                    double.parse(_amountController.text.trim()),
                                description: _noteController.text.trim(),
                                createdAt: DateTime.now().toString(),
                                userId: userId,
                                category: _selectedCategory,
                              )
                            ]).catchError((e) {
                              ShowNotificationSnack.showError(
                                  context, 'Error', e);
                            });
                            if (success) {
                              _titleController.clear();
                              _noteController.clear();
                              setState(() {
                                _selectedCategory = 'Other';
                              });
                              _amountController.clear();
                            }
                            // final transaction = Transaction(
                            //   title: _titleController.text,
                            //   amount: double.parse(_amountController.text),
                            //   date: _selectedDate,
                            //   category: _selectedCategory,
                            //   isExpense: true,
                            // );
                            // _titleController.clear();
                            // _noteController.clear();
                            // setState(() {
                            //   _selectedCategory = 'Other';
                            // });
                            // _amountController.clear();
                            // Provider.of<TransactionProvider>(context,
                            //         listen: false)
                            //     .addTransaction(transaction);
                            // widget.onClose;
                            // Navigator.pop(context);
                          }
                        },
                      ))
                    ]),
                    100.verticalSpace,
                    // ElevatedButton(

                    //   child: const Text('Add Transaction'),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }
}

class IncomeFormWidget extends StatefulWidget {
  IncomeFormWidget({
    super.key,
    required GlobalKey<FormState> incomeFormKey,
    required this.colorScheme,
    required this.selectedCategory,
    // required TextEditingController titleController,
    // required TextEditingController amountController,
    // required TextEditingController noteController,
  }) : _incomeFormKey = incomeFormKey;
  // _titleController = titleController,
  // _amountController = amountController,
  // _noteController = noteController;

  final GlobalKey<FormState> _incomeFormKey;
  final ColorScheme colorScheme;
  String? selectedCategory;

  @override
  State<IncomeFormWidget> createState() => _IncomeFormWidgetState();
}

class _IncomeFormWidgetState extends State<IncomeFormWidget> {
  DateTime _selectedDate = DateTime.now();
  TextEditingController _titleController = TextEditingController();

  TextEditingController _amountController = TextEditingController();

  TextEditingController _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Form(
          key: widget._incomeFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurStyle: BlurStyle.outer,
                      blurRadius: 10,
                      offset: const Offset(0, 0),
                    )
                  ],
                  color: Theme.of(context).cardColor.withOpacity(
                      0.2), // Lower opacity for a frosted glass effect
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color:
                          Colors.white.withOpacity(0.2)), // Soft white border
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
                        color: widget.colorScheme.outline
                            .withOpacity(0.1), // Slight white overlay
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Title",
                            style: bodySmallBold,
                          ),
                          5.verticalSpace,
                          TextFieldUi(
                            // fillColor: colorScheme.surfaceBright,
                            fillColor: widget.colorScheme.surfaceDim,
                            isFilled: true,
                            hintText: 'Title',
                            controller: _titleController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a title';
                              }
                              return null;
                            },
                          ),
                          // 20.verticalSpace,
                          Text(
                            "Amount",
                            style: bodySmallBold,
                          ),
                          5.verticalSpace,
                          TextFieldUi(
                            isFilled: true,
                            // fillColor: colorScheme.surfaceBright,
                            fillColor: widget.colorScheme.surfaceDim,
                            hintText: formatCurrency(0.0),
                            controller: _amountController,
                            // decoration: const InputDecoration(labelText: 'Amount'),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter an amount';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Please enter a valid number';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              20.verticalSpace,
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurStyle: BlurStyle.outer,
                      blurRadius: 10,
                      offset: const Offset(0, 0),
                    )
                  ],
                  color: Theme.of(context).cardColor.withOpacity(
                      0.2), // Lower opacity for a frosted glass effect
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color:
                          Colors.white.withOpacity(0.2)), // Soft white border
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
                        color: widget.colorScheme.outline
                            .withOpacity(0.1), // Slight white overlay
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Add a note",
                            style: bodySmallBold,
                          ),
                          5.verticalSpace,
                          TextFieldUi(
                            textFieldHeight: 200,
                            maxLines: 50,
                            isFilled: true,
                            fillColor: widget.colorScheme.surfaceDim,
                            hintText: "Add a few notes to help you later",
                            controller: _noteController,
                            // decoration: const InputDecoration(labelText: 'Amount'),
                            keyboardType: TextInputType.text,
                            // validator: (value) {
                            //   if (value == null || value.isEmpty) {
                            //     return 'Please enter an amount';
                            //   }
                            //   if (double.tryParse(value) == null) {
                            //     return 'Please enter a valid number';
                            //   }
                            //   return null;
                            // },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              40.verticalSpace,

              Row(children: [
                Expanded(
                  child: PrimaryButtonUi(
                    borderR: Radius.circular(15),
                    textColor: Theme.of(context).colorScheme.onSecondary,
                    backgroundColor:
                        Theme.of(context).colorScheme.onSurfaceVariant,
                    // backgroundColor:
                    //     Theme.of(context).colorScheme.onSecondaryFixed,
                    text: "Clear",
                    textStyle: bodyMed,
                    onPressed: () {
                      _amountController.clear();
                      _titleController.clear();
                      _noteController.clear();
                      // setState(() {
                      //   widget.selectedCategory = 'Other';
                      // });
                    },
                  ),
                ),
                10.horizontalSpace,
                Expanded(
                    child: PrimaryButtonUi(
                  borderR: Radius.circular(15),
                  textStyle: bodyMed,
                  textColor: Theme.of(context).colorScheme.onSecondary,
                  backgroundColor:
                      Theme.of(context).colorScheme.onSurfaceVariant,
                  // backgroundColor:
                  //     Theme.of(context).colorScheme.onSecondaryFixed,
                  text: "Save",
                  onPressed: () {
                    if (widget._incomeFormKey.currentState!.validate()) {
                      final transaction = Transaction(
                        title: _titleController.text,
                        amount: double.parse(_amountController.text),
                        date: _selectedDate,
                        category: 'Other',
                        isExpense: false,
                      );
                      _titleController.clear();
                      // setState(() {
                      //   widget.selectedCategory = 'Other';
                      // });
                      _amountController.clear();
                      _noteController.clear();
                      Provider.of<TransactionProvider>(context, listen: false)
                          .addTransaction(transaction);
                      // widget.onClose;
                      // Navigator.pop(context);
                    }
                  },
                ))
              ]),
              40.verticalSpace,
              // ElevatedButton(

              //   child: const Text('Add Transaction'),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTab extends StatefulWidget {
  final String text1;
  final String text2;
  final Widget widget1;
  final Widget widget2;
  final ColorScheme colorScheme;

  const CustomTab({
    super.key,
    required this.text1,
    required this.text2,
    required this.widget1,
    required this.colorScheme,
    required this.widget2,
  });

  @override
  State<CustomTab> createState() => _CustomTabState();
}

class _CustomTabState extends State<CustomTab> {
  @override
  Widget build(BuildContext context) {
    // final bool isDarkMode = ref.watch(themeSwitchProvider);
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              // left: 40,
              // right: 40,
              top: 20,
              bottom: 15,
            ),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  height: 40.h,
                  // width: double.infinity,

                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurStyle: BlurStyle.outer,
                        blurRadius: 10,
                        offset: const Offset(0, 0),
                      )
                    ],
                    color: Theme.of(context).cardColor.withOpacity(
                        0.2), // Lower opacity for a frosted glass effect
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color:
                            Colors.white.withOpacity(0.2)), // Soft white border
                  ),
                  child: ClipRRect(
                    // Clip the blur effect to match border radius
                    borderRadius: BorderRadius.circular(10),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                          sigmaX: 10,
                          sigmaY: 10), // Increase blur for more glass effect
                      child: Container(
                        width: double.infinity,
                        // height: 200,
                        // margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.all(0),
                        // padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: widget.colorScheme.outline
                              .withOpacity(0.1), // Slight white overlay
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: TabBar(
                              dividerColor: Colors.transparent,
                              indicator: BoxDecoration(
                                  color: widget.colorScheme.surfaceBright,
                                  borderRadius: BorderRadius.circular(7.r)),
                              indicatorSize: TabBarIndicatorSize.tab,
                              unselectedLabelColor:
                                  widget.colorScheme.outlineVariant,
                              labelColor: widget.colorScheme.surfaceTint,
                              splashFactory: NoSplash.splashFactory,
                              splashBorderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              tabs: [
                                Tab(
                                  child: Text(widget.text1, style: bodyMedBold),
                                ),
                                Tab(
                                  child: Text(widget.text2, style: bodyMedBold),
                                )
                              ]),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          4.verticalSpace,
          Expanded(
            child: TabBarView(
              children: [widget.widget1, widget.widget2],
            ),
          ),
        ],
      ),
    );
  }
}
