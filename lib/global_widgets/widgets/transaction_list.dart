import 'dart:ui';

import 'package:TrackIt/Resources/res.dart';
import 'package:TrackIt/Resources/typograhy.res.dart';
import 'package:TrackIt/features/providers/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../utils/format_currency.dart';
import 'package:intl/intl.dart';

/// Enum to represent transaction categories
enum TransactionCategory {
  food,
  transportation,
  entertainment,
  shopping,
  bills,
  healthcare,
  education,
  travel,
  savings,
  income,
  other,
}

/// Function to map category names to enums
TransactionCategory getCategoryEnum(String category) {
  switch (category.toLowerCase()) {
    case 'food':
      return TransactionCategory.food;
    case 'transportation':
      return TransactionCategory.transportation;
    case 'entertainment':
      return TransactionCategory.entertainment;
    case 'shopping':
      return TransactionCategory.shopping;
    case 'bills':
      return TransactionCategory.bills;
    case 'healthcare':
      return TransactionCategory.healthcare;
    case 'education':
      return TransactionCategory.education;
    case 'travel':
      return TransactionCategory.travel;
    case 'savings':
      return TransactionCategory.savings;
    case 'income':
      return TransactionCategory.income;
    default:
      return TransactionCategory.other;
  }
}

/// Function to get icon based on transaction category
String getCategoryIcon(TransactionCategory category) {
  switch (category) {
    case TransactionCategory.food:
      return food;
    case TransactionCategory.transportation:
      return transportation;
    case TransactionCategory.entertainment:
      return entertainment;
    case TransactionCategory.shopping:
      return shopping;
    case TransactionCategory.bills:
      return bills;
    case TransactionCategory.healthcare:
      return health;
    case TransactionCategory.education:
      return school;
    case TransactionCategory.travel:
      return travel;
    case TransactionCategory.savings:
      return savings;
    case TransactionCategory.income:
      return income;
    case TransactionCategory.other:
      return categories;
  }
}

class TransactionList extends StatelessWidget {
  const TransactionList({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Consumer<TransactionProvider>(
      builder: (context, transactionProvider, _) {
        final transactions = transactionProvider.transactions.reversed.toList();

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
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.onSurface.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: transactions.isEmpty
                    ? Center(
                        child: Text(
                          'No transactions yet!',
                          style: bodyNorm.copyWith(color: white),
                        ),
                      )
                    : ListView.builder(
                        itemCount: transactions.length,
                        itemBuilder: (context, index) {
                          final transaction = transactions[index];
                          final categoryEnum =
                              getCategoryEnum(transaction.category);
                          final icon = getCategoryIcon(categoryEnum);

                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: transaction.isExpense
                                  ? Colors.red[100]!.withOpacity(0.5)
                                  : Colors.green[100]!.withOpacity(0.5),
                              child: Image.asset(
                                icon,
                              ),
                            ),
                            title: Text(
                              transaction.title,
                              style: bodyNormBold.copyWith(color: grayScale50),
                            ),
                            subtitle: Text(
                              style: bodySmall.copyWith(color: grayScale100),
                              '${transaction.category} • ${DateFormat.yMMMd().format(transaction.date)}',
                            ),
                            trailing: Text(
                              formatCurrency(transaction.amount),
                              style: bodySmallBold.copyWith(
                                color: transaction.isExpense
                                    ? Colors.red[300]
                                    : Colors.green[100],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}
