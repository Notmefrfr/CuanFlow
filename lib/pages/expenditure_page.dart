import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'expense_provider.dart'; // Adjust path if necessary

class ExpenditurePage extends StatefulWidget {
  const ExpenditurePage({super.key});

  @override
  _ExpenditurePageState createState() => _ExpenditurePageState();
}

class _ExpenditurePageState extends State<ExpenditurePage> {
  bool showIncome = false;
  bool showExpenses = false;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ExpenseProvider>(context);
    final transactions = provider.allTransactions;

    final filteredTransactions = showIncome
        ? transactions.where((t) => t.type == 'income').toList()
        : showExpenses
        ? transactions.where((t) => t.type == 'expense').toList()
        : transactions;

    final totalIncome = provider.incomes.fold(0.0, (sum, e) => sum + e.amount);
    final totalExpenses =
    provider.expenses.fold(0.0, (sum, e) => sum + e.amount);
    final balance = totalIncome - totalExpenses;

    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1C1C),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Expenditure',
          style: TextStyle(color: Colors.white),
        ),
        actions: const [
          CircleAvatar(
            backgroundImage: AssetImage('assets/avatar.png'),
            radius: 18,
          ),
          SizedBox(width: 12),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2D2D2D),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Text(
                    'Total Balance',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${balance.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              showIncome = true;
                              showExpenses = false;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: showIncome
                                  ? Colors.orange
                                  : const Color(0xFF3A3A3A),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                const Icon(Icons.arrow_downward,
                                    color: Colors.white),
                                const SizedBox(height: 4),
                                Text(
                                  'Income\n\$${totalIncome.toStringAsFixed(2)}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              showExpenses = true;
                              showIncome = false;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: showExpenses
                                  ? Colors.orange
                                  : const Color(0xFF3A3A3A),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                const Icon(Icons.arrow_upward,
                                    color: Colors.white),
                                const SizedBox(height: 4),
                                Text(
                                  'Expense\n\$${totalExpenses.toStringAsFixed(2)}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: const [
                Icon(Icons.calendar_today, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Transaction History',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: filteredTransactions.length,
                itemBuilder: (context, index) {
                  final t = filteredTransactions[index];
                  final formatter = DateFormat('HH:mm - MMMM dd');
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2D2D2D),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.orangeAccent,
                        child: Icon(
                          t.type == 'income'
                              ? Icons.arrow_downward
                              : Icons.arrow_upward,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        t.title,
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        '${formatter.format(t.date)} · ${t.category}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                      trailing: Text(
                        (t.type == 'income' ? '+' : '-') +
                            '\$${t.amount.abs().toStringAsFixed(2)}',
                        style: TextStyle(
                          color: t.type == 'income'
                              ? Colors.greenAccent
                              : Colors.redAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: Colors.transparent,
        elevation: 0,
        notchMargin: 6.0,
        child: Container(
          height: 60,
          decoration: const BoxDecoration(
            color: Color(0xFFD97941),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            currentIndex: 1, // Adjust if you want to control current tab index
            onTap: (index) {
              // Add navigation logic here if needed
            },
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white70,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
              BottomNavigationBarItem(icon: Icon(Icons.swap_vert), label: ""),
              BottomNavigationBarItem(icon: Icon(Icons.notifications), label: ""),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
            ],
          ),
        ),
      ),
    );
  }
}
