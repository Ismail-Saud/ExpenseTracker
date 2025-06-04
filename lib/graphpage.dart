import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class GraphsPage extends StatelessWidget {
  final Map<String, double> incomeCategoryTotals;
  final Map<String, double> expenseCategoryTotals;

  const GraphsPage({
    super.key,
    required this.incomeCategoryTotals,
    required this.expenseCategoryTotals,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: const Text(
            "Graphs Overview",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 221, 214, 199),
            ),
          ),
        ),
        backgroundColor: Color(0xFF321B15),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: IncomeExpenseBarChart(
          incomeCategoryTotals: incomeCategoryTotals,
          expenseCategoryTotals: expenseCategoryTotals,
        ),
      ),
    );
  }
}

class IncomeExpenseBarChart extends StatefulWidget {
  final Map<String, double> incomeCategoryTotals;
  final Map<String, double> expenseCategoryTotals;

  const IncomeExpenseBarChart({
    super.key,
    required this.incomeCategoryTotals,
    required this.expenseCategoryTotals,
  });

  @override
  State<IncomeExpenseBarChart> createState() => _IncomeExpenseBarChartState();
}

class _IncomeExpenseBarChartState extends State<IncomeExpenseBarChart> {
  bool showIncome = false;

  @override
  Widget build(BuildContext context) {
    final Map<String, double> displayData =
        showIncome ? widget.incomeCategoryTotals : widget.expenseCategoryTotals;

    final List<String> categories = displayData.keys.toList();
    final List<double> values = displayData.values.toList();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  showIncome = true;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    showIncome
                        ? const Color(0xFF321B15)
                        : const Color(0xFFECE5D8),
                foregroundColor:
                    showIncome
                        ? const Color(0xFFECE5D8)
                        : const Color(0xFF321B15),
              ),
              child: const Text("Incomes"),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  showIncome = false;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    !showIncome
                        ? const Color(0xFF321B15)
                        : const Color(0xFFECE5D8),
                foregroundColor:
                    !showIncome
                        ? const Color(0xFFECE5D8)
                        : const Color(0xFF321B15),
              ),
              child: const Text("Expenses"),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Expanded(
          child: BarChart(
            BarChartData(
              barGroups: [
                for (int i = 0; i < categories.length; i++)
                  BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: values[i],
                        color: showIncome ? Colors.green : Colors.red,
                        width: 22,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
              ],
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 42,
                    getTitlesWidget: (value, meta) {
                      int index = value.toInt();
                      if (index < categories.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            categories[index],
                            style: const TextStyle(fontSize: 10),
                            textAlign: TextAlign.center,
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style: const TextStyle(fontSize: 12),
                      );
                    },
                    reservedSize: 40,
                  ),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              gridData: FlGridData(show: true),
              borderData: FlBorderData(show: false),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, "/homepage");
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF321B15),
            foregroundColor: const Color(0xFFECE5D8),
          ),
          child: Text("Back To Home Page"),
        ),
      ],
    );
  }
}
