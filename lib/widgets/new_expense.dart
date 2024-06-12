import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({required this.addExpense, super.key});

  final void Function(Expense expense) addExpense;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  void _openDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      firstDate: firstDate,
      lastDate: now,
    );

    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _submitExpense() {
    final enteredAmount = double.tryParse(_amountController.text);

    if (_titleController.text.trim().isEmpty ||
        enteredAmount == null ||
        enteredAmount <= 0 ||
        _selectedDate == null) {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                icon: const Icon(Icons.error_outline_rounded),
                iconColor: Colors.red,
                title: const Text(
                  'Invalid input!',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                content: const Text(
                  'Make sure all the fields are filled appropriately!',
                  textAlign: TextAlign.center,
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Okay')),
                ],
              ));
      return;
    }

    widget.addExpense(Expense(
      title: _titleController.text,
      amount: enteredAmount,
      date: _selectedDate!,
      category: _selectedCategory,
    ));
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // When a mobile device's keyboard is visible viewInsets.bottom corresponds to the top of the keyboard.
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    final titleWidget = TextField(
      maxLength: 50,
      autofocus: true,
      decoration: const InputDecoration(label: Text('Title')),
      controller: _titleController,
    );

    final amountWidget = TextField(
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        label: Text('Amount'),
        prefixText: '₹ ',
      ),
      controller: _amountController,
    );

    final categoryWidget = Expanded(
      child: DropdownButton(
          value: _selectedCategory,
          items: Category.values
              .map((category) => DropdownMenuItem(
                    value: category,
                    child: Text(category.name.toUpperCase()),
                  ))
              .toList(),
          onChanged: (val) {
            if (val == null) return;
            setState(() {
              _selectedCategory = val;
            });
          }),
    );

    final dateWidget = Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            _selectedDate == null ? 'Select Date' : dateFormatter.format(_selectedDate!),
          ),
          IconButton(
            onPressed: _openDatePicker,
            icon: const Icon(Icons.calendar_month_rounded),
          ),
        ],
      ),
    );

    return LayoutBuilder(builder: (ctx, constraints) {
      final width = constraints.maxWidth;

      return SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + keyboardSpace),
          child: Column(
            children: [
              if (width >= 600)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: titleWidget),
                    const SizedBox(
                      width: 24,
                    ),
                    Expanded(child: amountWidget),
                  ],
                )
              else
                titleWidget,
              if (width >= 600)
                Row(
                  children: [
                    categoryWidget,
                    const SizedBox(width: 24),
                    dateWidget,
                  ],
                )
              else
                Row(
                  children: [
                    Expanded(child: amountWidget),
                    const SizedBox(
                      width: 16,
                    ),
                    dateWidget,
                  ],
                ),
              const SizedBox(
                height: 16,
              ),
              if (width >= 600)
                Row(
                  children: [
                    const Spacer(),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel')),
                    ElevatedButton(onPressed: _submitExpense, child: const Text('Add expense')),
                  ],
                )
              else
                Row(
                  children: [
                    categoryWidget,
                    const Spacer(),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel')),
                    ElevatedButton(onPressed: _submitExpense, child: const Text('Add expense')),
                  ],
                )
            ],
          ),
        ),
      );
    });
  }
}
