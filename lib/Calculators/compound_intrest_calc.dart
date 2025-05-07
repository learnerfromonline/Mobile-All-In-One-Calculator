import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

class CompoundInterestCalculator extends StatefulWidget {
  @override
  _CompoundInterestCalculatorState createState() => _CompoundInterestCalculatorState();
}

class _CompoundInterestCalculatorState extends State<CompoundInterestCalculator> {
  final TextEditingController principalController = TextEditingController();
  final TextEditingController rateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  String selectedFrequency = 'Yearly';
  double totalAmount = 0.0;
  double compoundInterest = 0.0;
  List<Map<String, String>> breakdown = [];

  void calculateCompoundInterest() {
    double principal = double.tryParse(principalController.text) ?? 0.0;
    double rate = double.tryParse(rateController.text) ?? 0.0;
    double time = double.tryParse(timeController.text) ?? 0.0;

    int n;
    String periodLabel;
    if (selectedFrequency == 'Yearly') {
      n = 1;
      periodLabel = 'Year';
    } else if (selectedFrequency == 'Half-Yearly') {
      n = 2;
      periodLabel = 'Half-Year';
    } else if (selectedFrequency == 'Quarterly') {
      n = 4;
      periodLabel = 'Quarter';
    } else if (selectedFrequency == 'Monthly') {
      n = 12;
      periodLabel = 'Month';
    } else {
      n = 365;
      periodLabel = 'Day';
    }

    double amount = principal * pow((1 + (rate / 100) / n), (n * time));
    setState(() {
      totalAmount = amount;
      compoundInterest = amount - principal;
      breakdown = _generateBreakdown(principal, rate, time, n, periodLabel);
    });
  }

  List<Map<String, String>> _generateBreakdown(double principal, double rate, double time, int n, String periodLabel) {
    List<Map<String, String>> breakdownList = [];
    int totalPeriods = (time * n).toInt();
    for (int i = 1; i <= totalPeriods; i++) {
      double periodAmount = principal * pow((1 + (rate / 100) / n), i);
      double periodInterest = periodAmount - principal;
      breakdownList.add({
        "Period": "$i",
        "Total Amount": "\$${periodAmount.toStringAsFixed(2)}",
        "Interest Earned": "\$${periodInterest.toStringAsFixed(2)}",
        "PeriodLabel": periodLabel,
      });
    }
    return breakdownList;
  }

  void resetFields() {
    setState(() {
      principalController.clear();
      rateController.clear();
      timeController.clear();
      selectedFrequency = 'Yearly';
      totalAmount = 0.0;
      compoundInterest = 0.0;
      breakdown = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Compound Interest",
          style: GoogleFonts.fredoka(
            fontSize: 26,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInputCard(),
            const SizedBox(height: 24),
            _buildResults(),
            if (breakdown.isNotEmpty) _buildBreakdownTable(),
            if (breakdown.isNotEmpty) _buildBarChart(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      color: Colors.white,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey[200]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[300]!,
              blurRadius: 12,
              offset: const Offset(4, 4),
            ),
            BoxShadow(
              color: Colors.white,
              blurRadius: 12,
              offset: const Offset(-4, -4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildTextField(principalController, "Principal Amount"),
            const SizedBox(height: 16),
            _buildTextField(rateController, "Annual Interest Rate (%)"),
            const SizedBox(height: 16),
            _buildTextField(timeController, "Time (years)"),
            const SizedBox(height: 16),
            _buildDropdown(),
            const SizedBox(height: 24),
            _buildButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.fredoka(
          fontSize: 18,
          color: Colors.grey[700],
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.black, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        prefixIcon: Icon(Icons.monetization_on, color: Colors.grey[600]),
      ),
      style: GoogleFonts.fredoka(fontSize: 16, color: Colors.black),
    );
  }

  Widget _buildDropdown() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[300]!,
            blurRadius: 8,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: selectedFrequency,
        items: ['Yearly', 'Half-Yearly', 'Quarterly', 'Monthly', 'Daily']
            .map((String value) => DropdownMenuItem(
                  value: value,
                  child: Text(
                    value,
                    style: GoogleFonts.fredoka(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ))
            .toList(),
        onChanged: (newValue) {
          setState(() {
            selectedFrequency = newValue!;
          });
        },
        decoration: InputDecoration(
          labelText: "Compounding Frequency",
          labelStyle: GoogleFonts.fredoka(
            fontSize: 18,
            color: Colors.grey[700],
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          prefixIcon: Icon(Icons.repeat, color: Colors.grey[600]),
        ),
        style: GoogleFonts.fredoka(fontSize: 16, color: Colors.black),
      ),
    );
  }

  Widget _buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedScale(
          scale: 1.0,
          duration: const Duration(milliseconds: 200),
          child: ElevatedButton(
            onPressed: calculateCompoundInterest,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 6,
              shadowColor: Colors.grey[400],
            ),
            child: Text(
              "Calculate",
              style: GoogleFonts.fredoka(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        const SizedBox(width: 20),
        AnimatedScale(
          scale: 1.0,
          duration: const Duration(milliseconds: 200),
          child: ElevatedButton(
            onPressed: resetFields,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[600],
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 6,
              shadowColor: Colors.grey[400],
            ),
            child: Text(
              "Reset",
              style: GoogleFonts.fredoka(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResults() {
    return AnimatedOpacity(
      opacity: totalAmount > 0 ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 8,
        color: Colors.white,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.grey[200]!, Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[300]!,
                blurRadius: 12,
                offset: const Offset(4, 4),
              ),
              BoxShadow(
                color: Colors.white,
                blurRadius: 12,
                offset: const Offset(-4, -4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Results",
                style: GoogleFonts.fredoka(
                  fontSize: 22,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Total Amount: \$${totalAmount.toStringAsFixed(2)}",
                style: GoogleFonts.fredoka(
                  fontSize: 20,
                  color: Colors.black87,
                ),
              ),
              Text(
                "Compound Interest: \$${compoundInterest.toStringAsFixed(2)}",
                style: GoogleFonts.fredoka(
                  fontSize: 20,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBreakdownTable() {
    String periodLabel = breakdown.isNotEmpty ? breakdown[0]["PeriodLabel"]! : "Period";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          "$periodLabel Breakdown 📊",
          style: GoogleFonts.fredoka(
            fontSize: 24,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 8,
          color: Colors.white,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Colors.grey[200]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[300]!,
                  blurRadius: 12,
                  offset: const Offset(4, 4),
                ),
                BoxShadow(
                  color: Colors.white,
                  blurRadius: 12,
                  offset: const Offset(-4, -4),
                ),
              ],
            ),
            child: Table(
              border: TableBorder.all(color: Colors.grey[400]!),
              columnWidths: const {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(2),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey[300]),
                  children: [
                    _buildTableCell(periodLabel, true),
                    _buildTableCell("Total Amount", true),
                    _buildTableCell("Interest Earned", true),
                  ],
                ),
                ...breakdown.map((data) => TableRow(
                      children: [
                        _buildTableCell(data["Period"]!),
                        _buildTableCell(data["Total Amount"]!),
                        _buildTableCell(data["Interest Earned"]!),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBarChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          "Growth Chart 📈",
          style: GoogleFonts.fredoka(
            fontSize: 24,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 8,
          color: Colors.white,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Colors.grey[200]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[300]!,
                  blurRadius: 12,
                  offset: const Offset(4, 4),
                ),
                BoxShadow(
                  color: Colors.white,
                  blurRadius: 12,
                  offset: const Offset(-4, -4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              height: 300,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: breakdown
                      .map((data) => double.parse(data["Total Amount"]!.replaceAll('\$', '')))
                      .reduce((a, b) => a > b ? a : b) * 1.2,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor:(group) =>  Colors.grey,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final data = breakdown[groupIndex];
                        final label = rodIndex == 0 ? 'Total Amount' : 'Interest';
                        final value = rodIndex == 0
                            ? data["Total Amount"]
                            : data["Interest Earned"];
                        return BarTooltipItem(
                          '$label\n$value',
                          GoogleFonts.fredoka(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) => Text(
                          '\$${value.toInt()}',
                          style: GoogleFonts.fredoka(
                            fontSize: 12,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index < breakdown.length) {
                            return Text(
                              breakdown[index]["Period"]!,
                              style: GoogleFonts.fredoka(
                                fontSize: 12,
                                color: Colors.black87,
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: const FlGridData(show: true, drawVerticalLine: false),
                  barGroups: breakdown.asMap().entries.map((entry) {
                    final index = entry.key;
                    final data = entry.value;
                    final totalAmount = double.parse(data["Total Amount"]!.replaceAll('\$', ''));
                    final interestEarned = double.parse(data["Interest Earned"]!.replaceAll('\$', ''));
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: totalAmount,
                          color: Colors.grey[600],
                          width: 10,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        BarChartRodData(
                          toY: interestEarned,
                          color: Colors.grey[300],
                          width: 10,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTableCell(String text, [bool isHeader = false]) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: GoogleFonts.fredoka(
          fontSize: isHeader ? 18 : 16,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          color: isHeader ? Colors.black : Colors.black87,
        ),
      ),
    );
  }
}