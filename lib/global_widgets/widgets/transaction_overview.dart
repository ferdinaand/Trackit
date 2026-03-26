import 'dart:ui';

import 'package:TrackIt/Resources/typograhy.res.dart';
import 'package:TrackIt/features/providers/transaction_provider.dart';
import 'package:flutter/material.dart';
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
    default:
      return TransactionCategory.other;
  }
}

/// Function to get icon based on transaction category
IconData getCategoryIcon(TransactionCategory category) {
  switch (category) {
    case TransactionCategory.food:
      return Icons.fastfood;
    case TransactionCategory.transportation:
      return Icons.directions_bus;
    case TransactionCategory.entertainment:
      return Icons.movie;
    case TransactionCategory.shopping:
      return Icons.shopping_bag;
    case TransactionCategory.bills:
      return Icons.receipt;
    case TransactionCategory.healthcare:
      return Icons.local_hospital;
    case TransactionCategory.education:
      return Icons.school;
    case TransactionCategory.travel:
      return Icons.flight;
    case TransactionCategory.savings:
      return Icons.savings;
    case TransactionCategory.other:
      return Icons.category;
  }
}

class TransactionOverview extends StatelessWidget {
  const TransactionOverview({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Consumer<TransactionProvider>(
      builder: (context, transactionProvider, _) {
        final transactions = transactionProvider.transactions;

        if (transactions.isEmpty) {
          return const Center(
            child: Text('No transactions yet!'),
          );
        }

        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context)
                .cardColor
                .withOpacity(0.2), // Lower opacity for a frosted glass effect
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white), // Soft white border
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.onSurface.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = transactions[index];
                    final categoryEnum = getCategoryEnum(transaction.category);
                    final iconData = getCategoryIcon(categoryEnum);

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: transaction.isExpense
                            ? Colors.red[100]!.withOpacity(0.5)
                            : Colors.green[100]!.withOpacity(0.5),
                        child: Icon(
                          iconData,
                          color:
                              transaction.isExpense ? Colors.red : Colors.green,
                        ),
                      ),
                      title: Text(
                        transaction.title,
                        style: bodySmall,
                      ),
                      subtitle: Text(
                        style: bodyXSmall,
                        '${transaction.category} • ${DateFormat.yMMMd().format(transaction.date)}',
                      ),
                      trailing: Text(
                        formatCurrency(transaction.amount),
                        style: bodyXSmallBold.copyWith(
                          color:
                              transaction.isExpense ? Colors.red : Colors.green,
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
