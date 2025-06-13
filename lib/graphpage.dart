import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class GraphsPage extends StatefulWidget {
  final Map<String, double> incomeCategoryTotals;
  final Map<String, double> expenseCategoryTotals;

  const GraphsPage({
    super.key,
    required this.incomeCategoryTotals,
    required this.expenseCategoryTotals,
  });

  @override
  State<GraphsPage> createState() => _GraphsPageState();
}

class _GraphsPageState extends State<GraphsPage> {
  bool showIncome = false;

  @override
  Widget build(BuildContext context) {
    final data = showIncome
        ? widget.incomeCategoryTotals
        : widget.expenseCategoryTotals;

    final categories = data.keys.toList();
    final values = data.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Graphs Overview",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 221, 214, 199),
            ),
          ),
        ),
        backgroundColor: const Color(0xFF321B15),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          ToggleButtons(
            isSelected: [showIncome, !showIncome],
            onPressed: (index) {
              setState(() {
                showIncome = index == 0;
              });
            },
            selectedColor: Colors.white,
            color: Colors.black,
            fillColor: const Color(0xFF321B15),
            borderRadius: BorderRadius.circular(8),
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text("Income"),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text("Expense"),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
                            width: 20,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                      ),
                  ],
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          int index = value.toInt();
                          if (index < categories.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                categories[index],
                                style: const TextStyle(fontSize: 10),
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
                          return Text(value.toInt().toString(),
                              style: const TextStyle(fontSize: 7));
                        },
                      ),
                    ),
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(show: true),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, "/homepage");
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF321B15),
              foregroundColor: const Color(0xFFECE5D8),
            ),
            child: const Text("Back To Home Page"),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
