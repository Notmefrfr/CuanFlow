import 'package:flutter/material.dart';

class Expense {
  final String title;
  final double amount;
  final String category;
  final DateTime date;
  final String type; // 'expense' or 'income'

  Expense({
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    required this.type,
  });
}


class ExpenseProvider with ChangeNotifier {
  final List<Expense> _expenses = [];
  final List<Expense> _incomes = [];

  List<Expense> get expenses => _expenses;
  List<Expense> get incomes => _incomes;

  List<Expense> get allTransactions {
    final all = [..._expenses, ..._incomes];
    all.sort((a, b) => b.date.compareTo(a.date)); // newest first
    return all;
  }

  void addExpense(Expense e) {
    if (e.type == 'expense') {
      _expenses.add(e);
    } else {
      _incomes.add(e);
    }
    notifyListeners();
  }
}


