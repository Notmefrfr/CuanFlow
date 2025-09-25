import 'package:flutter/material.dart';
import 'expenditure_page.dart';
import 'statistic_page.dart';
import 'bootcamp_page.dart';
import 'profile_page.dart'; // Add this import
import 'expenses_page.dart';
import 'package:provider/provider.dart';
import '../models/transaction_model.dart';
import 'expense_provider.dart';



class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    _HomeContent(),
    StatisticPage(),
    const ExpenditurePage(),
    Center(child: Text("Notifications", style: TextStyle(color: Colors.white))),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _goToAddExpense() {
    // Use a separate page just for adding an expense
    Navigator.push(context, MaterialPageRoute(builder: (_) => const ExpensesPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2A2A2E),
      body: SafeArea(child: _pages[_selectedIndex]),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: Colors.transparent,
        elevation: 0,
        notchMargin: 6.0,
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: const Color(0xFFD97941),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white70,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
              BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: ""),
              BottomNavigationBarItem(icon: Icon(Icons.history), label: ""),
              BottomNavigationBarItem(icon: Icon(Icons.notifications), label: ""),
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _goToAddExpense,
        backgroundColor: const Color(0xFFD97941),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  // Helper to get icon from category
  static IconData getIconForCategory(String category, String type) {
    if (type == 'income') {
      return Icons.attach_money; // or something different for income
    }
    switch (category.toLowerCase()) {
      case 'food':
        return Icons.fastfood;
      case 'transport':
        return Icons.directions_car;
      case 'shopping':
        return Icons.shopping_cart;
      default:
        return Icons.receipt;
    }
  }

  static Color getColorForCategory(String category, String type) {
    if (type == 'income') {
      return Colors.green; // green for income
    }
    switch (category.toLowerCase()) {
      case 'food':
        return Colors.red;
      case 'transport':
        return Colors.blue;
      case 'shopping':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // App Bar with profile tap
        Container(
          color: const Color(0xFFD97941),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "CuanFlow",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilePage())),
                child: const CircleAvatar(
                  radius: 18,
                  backgroundImage: AssetImage('assets/images/profile.jpg'),
                ),
              ),
            ],
          ),
        ),

        // Slider
        SizedBox(
          height: 180,
          width: double.infinity,
          child: PageView(
            children: [
              _buildSliderItem(context, 'assets/images/expenditure.jpeg', "Expenditure", const ExpenditurePage()),
              _buildSliderItem(context, 'assets/images/statistic.jpeg', "Statistics", StatisticPage()),
              _buildSliderItem(context, 'assets/images/bootcamp.jpeg', "Bootcamp", const BootcampPage()),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Time Filters
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTimeFilter("This Week"),
              _buildTimeFilter("This Month"),
              _buildTimeFilter("This Year"),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Transactions
        Expanded(
          child: Consumer<ExpenseProvider>(
            builder: (context, provider, _) {
              final expenses = provider.allTransactions;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: const BoxDecoration(
                  color: Color(0xFF1C1C1F),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("Transaction", style: TextStyle(color: Colors.white, fontSize: 18)),
                        Text("See all", style: TextStyle(color: Colors.white54)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: expenses.isEmpty
                          ? const Center(child: Text("No expenses yet", style: TextStyle(color: Colors.white54)))
                          : ListView.builder(
                        itemCount: expenses.length,
                        itemBuilder: (context, index) {
                          final e = expenses[index];
                          return _buildTransactionItem(
                            e.title,
                            e.amount.toStringAsFixed(2),
                            getIconForCategory(e.category, e.type),
                            getColorForCategory(e.category, e.type),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  static Widget _buildSliderItem(BuildContext context, String image, String label, Widget targetPage) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => targetPage)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(image, fit: BoxFit.cover, width: double.infinity),
          ),
        ),
        Positioned(
          bottom: 16,
          left: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              ElevatedButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => targetPage)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD97941),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text("Go Now"),
              ),
            ],
          ),
        )
      ],
    );
  }

  static Widget _buildTimeFilter(String label) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Text(label, style: const TextStyle(color: Colors.white)),
    );
  }

  static Widget _buildTransactionItem(String title, String amount, IconData icon, Color iconColor) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: iconColor.withOpacity(0.3),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
          ),
          Text(amount, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
