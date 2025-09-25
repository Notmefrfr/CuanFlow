import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'expense_provider.dart'; // Adjust the path if needed

class StatisticPage extends StatefulWidget {
  const StatisticPage({super.key});

  @override
  State<StatisticPage> createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage> {
  String selectedChart = 'Bar';

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ExpenseProvider>(context);
    final expenses = provider.expenses;

    double totalRevenue = expenses
        .where((e) => e.amount > 0)
        .fold(0, (sum, e) => sum + e.amount);

    double totalFood = expenses
        .where((e) => e.category == 'Grocery' && e.amount < 0)
        .fold(0, (sum, e) => sum + e.amount);

    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Statistics',
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            InkWell(
              onTap: () => Navigator.pushNamed(context, '/savings'),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFD97941),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Column(
                      children: [
                        Icon(Icons.savings, color: Colors.white, size: 28),
                        SizedBox(height: 6),
                        Text("Savings\nOn Goals",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                    Container(height: 60, width: 1, color: Colors.white30),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Revenue Last Week",
                            style: TextStyle(color: Colors.white70, fontSize: 12)),
                        Text("\$${totalRevenue.toStringAsFixed(2)}",
                            style: const TextStyle(
                                color: Colors.white, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        const Text("Food Last Week",
                            style: TextStyle(color: Colors.white70, fontSize: 12)),
                        Text("\$${totalFood.abs().toStringAsFixed(2)}",
                            style: const TextStyle(
                                color: Colors.lightBlueAccent,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/saving'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD97941),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: const Text('Add Saving'),
                ),
                const SizedBox(width: 12),
                DropdownButton<String>(
                  value: selectedChart,
                  dropdownColor: Colors.grey[900],
                  style: const TextStyle(color: Colors.white),
                  underline: Container(),
                  items: ['Bar', 'Pie', 'Line']
                      .map((chart) => DropdownMenuItem(
                    value: chart,
                    child: Text(chart),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedChart = value!;
                    });
                  },
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/profile'),
                  child: const CircleAvatar(
                    backgroundImage: AssetImage('assets/profile.jpg'),
                    radius: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildChartCard(
                '$selectedChart Chart', _getSelectedChartWidget(expenses, selectedChart)),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Recent Transactions",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ),
            const SizedBox(height: 12),
            ...expenses
                .map((e) => _buildTransactionRow(e.title, e.category, e.amount))
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget _getSelectedChartWidget(List expenses, String selectedChart) {
    switch (selectedChart) {
      case 'Pie':
        return _buildPieChart(expenses);
      case 'Line':
        return _buildLineChart(expenses);
      default:
        return _buildMonthlyBarChart(expenses);
    }
  }

  Widget _buildChartCard(String title, Widget chart) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2D2D2D),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 12),
          SizedBox(height: 200, child: chart),
        ],
      ),
    );
  }

  Widget _buildMonthlyBarChart(List expenses) {
    final Map<String, Map<String, double>> monthlyData = {};

    for (var e in expenses) {
      final monthKey = DateFormat('yyyy-MM').format(e.date);
      final type = e.amount >= 0 ? 'revenue' : 'expense';

      monthlyData.putIfAbsent(monthKey, () => {'revenue': 0.0, 'expense': 0.0});
      // add to the existing value
      monthlyData[monthKey]![type] = (monthlyData[monthKey]![type] ?? 0) + e.amount.abs();
    }

    final sortedKeys = monthlyData.keys.toList()..sort();

    double maxY = 0;
    for (var values in monthlyData.values) {
      maxY = [
        maxY,
        values['revenue'] ?? 0,
        values['expense'] ?? 0,
      ].reduce((a, b) => a > b ? a : b);
    }
    maxY *= 1.2; // some headroom

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceBetween,
        maxY: maxY,
        barGroups: List.generate(sortedKeys.length, (index) {
          final data = monthlyData[sortedKeys[index]]!;
          return BarChartGroupData(x: index, barRods: [
            BarChartRodData(
              toY: data['expense'] ?? 0,
              color: Colors.redAccent,
              width: 10,
              borderRadius: BorderRadius.circular(4),
            ),
            BarChartRodData(
              toY: data['revenue'] ?? 0,
              color: Colors.lightBlueAccent,
              width: 10,
              borderRadius: BorderRadius.circular(4),
            ),
          ]);
        }),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final idx = value.toInt();
                if (idx < 0 || idx >= sortedKeys.length) return Container();
                final label =
                DateFormat('MMM').format(DateTime.parse('${sortedKeys[idx]}-01'));
                return Text(label,
                    style: const TextStyle(color: Colors.white, fontSize: 10));
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: maxY / 5,
              reservedSize: 28,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(color: Colors.white70, fontSize: 10),
                );
              },
            ),
          ),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: true),
      ),
    );
  }

  Widget _buildPieChart(List expenses) {
    Map<String, double> categoryTotals = {};

    for (var e in expenses) {
      categoryTotals[e.category] = (categoryTotals[e.category] ?? 0) + e.amount.abs();
    }

    final totalAmount =
    categoryTotals.values.fold(0.0, (previous, element) => previous + element);

    return PieChart(
      PieChartData(
        sections: categoryTotals.entries
            .map(
              (entry) => PieChartSectionData(
            value: entry.value,
            title:
            '${entry.key}\n${(entry.value / totalAmount * 100).toStringAsFixed(1)}%',
            radius: 60,
            titleStyle: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        )
            .toList(),
        sectionsSpace: 2,
        centerSpaceRadius: 40,
      ),
    );
  }

  Widget _buildLineChart(List expenses) {
    // Here, I'm assuming line chart showing total amounts per day

    final Map<DateTime, double> dailyTotals = {};

    for (var e in expenses) {
      final dayKey = DateTime(e.date.year, e.date.month, e.date.day);
      dailyTotals[dayKey] = (dailyTotals[dayKey] ?? 0) + e.amount;
    }

    final sortedDates = dailyTotals.keys.toList()..sort();

    double minY = dailyTotals.values.fold(double.infinity, (prev, e) => e < prev ? e : prev);
    double maxY = dailyTotals.values.fold(double.negativeInfinity, (prev, e) => e > prev ? e : prev);

    minY = minY.isFinite ? minY : 0;
    maxY = maxY.isFinite ? maxY : 0;
    final yRange = (maxY - minY).abs() * 1.2;

    return LineChart(
      LineChartData(
        minY: minY - yRange * 0.1,
        maxY: maxY + yRange * 0.1,
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) {
                int index = value.toInt();
                if (index < 0 || index >= sortedDates.length) return Container();
                return Text(DateFormat('MMM d').format(sortedDates[index]),
                    style: const TextStyle(color: Colors.white, fontSize: 10));
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toStringAsFixed(0),
                  style: const TextStyle(color: Colors.white70, fontSize: 10),
                );
              },
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(show: true),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(
                sortedDates.length,
                    (index) => FlSpot(
                    index.toDouble(), dailyTotals[sortedDates[index]] ?? 0)),
            isCurved: true,
            color: Colors.lightBlueAccent,
            barWidth: 3,
            dotData: FlDotData(show: false),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionRow(String title, String category, double amount) {
    final color = amount < 0 ? Colors.redAccent : Colors.lightBlueAccent;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF2D2D2D),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(category,
                  style: const TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),
          Text(
            '${amount < 0 ? '-' : '+'}\$${amount.abs().toStringAsFixed(2)}',
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
