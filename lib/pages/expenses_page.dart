import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'expense_provider.dart';

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({super.key});

  @override
  State<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _selectedCategory = 'Food';
  String _selectedType = 'expense'; // or 'income'

  final categories = [
    {"label": "Food", "icon": Icons.restaurant},
    {"label": "Transport", "icon": Icons.local_taxi},
    {"label": "Medicine", "icon": Icons.medication},
    {"label": "Groceries", "icon": Icons.shopping_cart},
    {"label": "Rent", "icon": Icons.house},
    {"label": "Gift", "icon": Icons.card_giftcard},
    {"label": "Savings", "icon": Icons.savings},
    {"label": "Entertainment", "icon": Icons.movie},
    {"label": "More", "icon": Icons.add},
  ];

  void _showCategorySelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2A2A2E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 3,
            children: categories.map((cat) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCategory = cat['label'] as String;
                  });
                  Navigator.pop(context);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.orange,
                      child: Icon(cat['icon'] as IconData, color: Colors.white),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      cat['label'] as String,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _saveExpense() {
    final title = _titleController.text;
    final amount = double.tryParse(_amountController.text);

    if (title.isEmpty || amount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${_selectedType[0].toUpperCase()}${_selectedType.substring(1)} added!")),
      );
      return;
    }

    final newExpense = Expense(
      title: title,
      amount: amount,
      category: _selectedCategory,
      date: _selectedDate,
      type: _selectedType,
    );

    Provider.of<ExpenseProvider>(context, listen: false).addExpense(newExpense);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Expense added!")),
    );

    _titleController.clear();
    _amountController.clear();
    setState(() {
      _selectedCategory = 'Food';
      _selectedDate = DateTime.now();
      _selectedType = 'expense';
    });
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType type = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          keyboardType: type,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            filled: true,
            fillColor: Colors.white10,
            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildCategoryPicker(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: _showCategorySelector,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_selectedCategory, style: const TextStyle(color: Colors.white)),
                const Icon(Icons.arrow_drop_down, color: Colors.white),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Date", style: TextStyle(color: Colors.white70)),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: _pickDate,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
                  style: const TextStyle(color: Colors.white),
                ),
                const Icon(Icons.calendar_today, color: Colors.white),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildTypePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Type", style: TextStyle(color: Colors.white70)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButton<String>(
            value: _selectedType,
            dropdownColor: const Color(0xFF2A2A2E),
            items: const [
              DropdownMenuItem(
                value: 'expense',
                child: Text("Expense", style: TextStyle(color: Colors.white)),
              ),
              DropdownMenuItem(
                value: 'income',
                child: Text("Income", style: TextStyle(color: Colors.white)),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() => _selectedType = value);
              }
            },
            underline: Container(),
            isExpanded: true,
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final expenses = Provider.of<ExpenseProvider>(context).expenses;

    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      appBar: AppBar(
        title: const Text('Add Expense'),
        backgroundColor: const Color(0xFF1C1C1E),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTextField("Title", _titleController),
              _buildTextField("Amount", _amountController, type: TextInputType.number),
              if (_selectedType == 'expense') _buildCategoryPicker("Category"),
              _buildDatePicker(),
              _buildTypePicker(),
              ElevatedButton(
                onPressed: _saveExpense,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("Save Expense"),
              ),
              const SizedBox(height: 30),
              const Text("Saved Expenses", style: TextStyle(color: Colors.white, fontSize: 18)),
              const SizedBox(height: 10),
              ...expenses.map((e) => ListTile(
                title: Text(e.title, style: const TextStyle(color: Colors.white)),
                subtitle: Text("${e.category} • ${e.date.toLocal().toString().split(' ')[0]}",
                    style: const TextStyle(color: Colors.white70)),
                trailing: Text(
                  "${e.type == 'income' ? '+' : '-'}\$${e.amount}",
                  style: TextStyle(color: e.type == 'income' ? Colors.greenAccent : Colors.redAccent),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
