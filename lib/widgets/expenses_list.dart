import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/expenses_item.dart';
import 'package:flutter/material.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList(
      {required this.expenses, required this.removeExpense, super.key});

  final List<Expense> expenses;
  final Function(Expense) removeExpense;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (context, index) => Dismissible(
        key: ValueKey(expenses[index]),
        onDismissed: (_) {
          removeExpense(expenses[index]);
        },
        background: Container(
          color: Theme.of(context).colorScheme.error.withOpacity(0.5),
          margin: Theme.of(context).cardTheme.margin,
        ),
        child: ExpensesItem(
          expense: expenses[index],
        ),
      ),
    );
  }
}
