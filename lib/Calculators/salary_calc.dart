import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';

class SalaryCalculator extends StatefulWidget {
  @override
  _SalaryCalculatorState createState() => _SalaryCalculatorState();
}

class _SalaryCalculatorState extends State<SalaryCalculator> {
  TextEditingController basicSalaryController = TextEditingController();
  TextEditingController allowancesController = TextEditingController();
  TextEditingController deductionsController = TextEditingController();

  double basicSalary = 0.0;
  double allowances = 0.0;
  double deductions = 0.0;
  double netSalary = 0.0;

  List<Map<String, dynamic>> salaryHistory = [];

  void calculateSalary() {
    setState(() {
      basicSalary = double.tryParse(basicSalaryController.text) ?? 0.0;
      allowances = double.tryParse(allowancesController.text) ?? 0.0;
      deductions = double.tryParse(deductionsController.text) ?? 0.0;

      basicSalary = basicSalary < 0 ? 0 : basicSalary;
      allowances = allowances < 0 ? 0 : allowances;
      deductions = deductions < 0 ? 0 : deductions;

      netSalary = (basicSalary + allowances) - deductions;

      if (basicSalary > 0 || allowances > 0 || deductions > 0) {
        salaryHistory.add({
          "Basic Salary": basicSalary,
          "Allowances": allowances,
          "Deductions": deductions,
          "Net Salary": netSalary,
          "timestamp": DateTime.now(),
        });
      }
    });
  }

  void resetCalculator() {
    setState(() {
      basicSalaryController.clear();
      allowancesController.clear();
      deductionsController.clear();
      basicSalary = 0.0;
      allowances = 0.0;
      deductions = 0.0;
      netSalary = 0.0;
    });
  }

  void deleteHistory(int index) {
    setState(() {
      salaryHistory.removeAt(index);
    });
  }

  Widget buildPieChart() {
    double total = basicSalary + allowances + deductions;
    if (total == 0) {
      return Center(
        child: Text(
          "No data to display",
          style: GoogleFonts.fredoka(fontSize: 16, color: Colors.white),
        ),
      );
    }

    return Column(
      children: [
        SizedBox(
          height: 250,
          child: PieChart(
            PieChartData(
              sections: _buildPieChartSections(total),
              sectionsSpace: 4,
              centerSpaceRadius: 50,
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {});
                },
              ),
            ),
            swapAnimationDuration: Duration(milliseconds: 800),
            swapAnimationCurve: Curves.easeInOut,
          ),
        ),
        SizedBox(height: 16),
        _buildLegend(),
      ],
    );
  }

  List<PieChartSectionData> _buildPieChartSections(double total) {
    List<PieChartSectionData> sections = [];
    
    if (basicSalary > 0) {
      sections.add(PieChartSectionData(
        value: basicSalary,
        title: '${((basicSalary / total) * 100).toStringAsFixed(1)}%',
        color: Colors.grey[300]!,
        radius: 60,
        titleStyle: GoogleFonts.fredoka(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        titlePositionPercentageOffset: 0.55,
      ));
    }
    
    if (allowances > 0) {
      sections.add(PieChartSectionData(
        value: allowances,
        title: '${((allowances / total) * 100).toStringAsFixed(1)}%',
        color: Colors.grey[500]!,
        radius: 60,
        titleStyle: GoogleFonts.fredoka(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        titlePositionPercentageOffset: 0.55,
      ));
    }
    
    if (deductions > 0) {
      sections.add(PieChartSectionData(
        value: deductions,
        title: '${((deductions / total) * 100).toStringAsFixed(1)}%',
        color: Colors.grey[700]!,
        radius: 60,
        titleStyle: GoogleFonts.fredoka(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        titlePositionPercentageOffset: 0.55,
      ));
    }

    return sections;
  }

  Widget _buildLegend() {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        if (basicSalary > 0)
          _buildLegendItem('Basic Salary', Colors.grey[300]!),
        if (allowances > 0)
          _buildLegendItem('Allowances', Colors.grey[500]!),
        if (deductions > 0)
          _buildLegendItem('Deductions', Colors.grey[700]!),
      ],
    );
  }

  Widget _buildLegendItem(String title, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          color: color,
        ),
        SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.fredoka(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget buildTable() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white),
      ),
      child: Table(
        border: TableBorder.all(color: Colors.white),
        columnWidths: {
          0: FlexColumnWidth(2),
          1: FlexColumnWidth(2),
        },
        children: [
          buildTableRow("Component", "Amount", isHeader: true),
          buildTableRow("Basic Salary", "\$${basicSalary.toStringAsFixed(2)}"),
          buildTableRow("Allowances", "\$${allowances.toStringAsFixed(2)}"),
          buildTableRow("Deductions", "\$${deductions.toStringAsFixed(2)}"),
          buildTableRow("Net Salary", "\$${netSalary.toStringAsFixed(2)}", isHighlighted: true),
        ],
      ),
    );
  }

  TableRow buildTableRow(String title, String value, {bool isHeader = false, bool isHighlighted = false}) {
    return TableRow(
      decoration: BoxDecoration(
        color: isHighlighted ? Colors.grey[800] : Colors.black,
      ),
      children: [
        Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            title,
            style: GoogleFonts.fredoka(
              fontSize: isHeader ? 18 : 16,
              fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
              color: Colors.white,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            value,
            style: GoogleFonts.fredoka(
              fontSize: isHeader ? 18 : 16,
              fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildHistory() {
    return salaryHistory.isEmpty
        ? Center(
            child: Text(
              "No History",
              style: GoogleFonts.fredoka(fontSize: 18, color: Colors.white),
            ),
          )
        : ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: salaryHistory.length,
            itemBuilder: (context, index) {
              final entry = salaryHistory[index];
              return Card(
                color: Colors.black,
                elevation: 2,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.white),
                ),
                child: ListTile(
                  title: Text(
                    "Net Salary: \$${entry['Net Salary'].toStringAsFixed(2)}",
                    style: GoogleFonts.fredoka(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    "Basic: \$${entry['Basic Salary'].toStringAsFixed(2)} | "
                    "Allowances: \$${entry['Allowances'].toStringAsFixed(2)} | "
                    "Deductions: \$${entry['Deductions'].toStringAsFixed(2)}",
                    style: GoogleFonts.fredoka(
                      color: Colors.grey[300],
                      fontSize: 14,
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.white),
                    onPressed: () => deleteHistory(index),
                  ),
                ),
              );
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          "Salary Calculator",
          style: GoogleFonts.fredoka(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(color: Colors.white, height: 1),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInputField("Basic Salary:", basicSalaryController),
              _buildInputField("Allowances:", allowancesController),
              _buildInputField("Deductions:", deductionsController),
              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: calculateSalary,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Calculate",
                      style: GoogleFonts.fredoka(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: resetCalculator,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[800],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Reset",
                      style: GoogleFonts.fredoka(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25),

              if (netSalary != 0 || basicSalary != 0 || allowances != 0 || deductions != 0) ...[
                Center(
                  child: Text(
                    "Salary Breakdown",
                    style: GoogleFonts.fredoka(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    buildPieChart(),
                    SizedBox(height: 16),
                    buildTable(),
                  ],
                ),
                SizedBox(height: 30),
              ],

              Center(
                child: Text(
                  "Salary History",
                  style: GoogleFonts.fredoka(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 10),
              buildHistory(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.fredoka(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Enter ${label.toLowerCase()}",
            hintStyle: TextStyle(color: Colors.grey[400]),
            filled: true,
            fillColor: Colors.grey[900],
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.white, width: 2),
            ),
          ),
        ),
        SizedBox(height: 12),
      ],
    );
  }
}