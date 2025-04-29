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

      netSalary = (basicSalary + allowances) - deductions;

      salaryHistory.add({
        "Basic Salary": basicSalary,
        "Allowances": allowances,
        "Deductions": deductions,
        "Net Salary": netSalary
      });
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
    return SizedBox(
      height: 250,
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              value: basicSalary,
              title: 'Basic',
              color: Colors.blue,
              radius: 50,
              titleStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            PieChartSectionData(
              value: allowances,
              title: 'Allowances',
              color: Colors.green,
              radius: 50,
              titleStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            PieChartSectionData(
              value: deductions,
              title: 'Deductions',
              color: Colors.red,
              radius: 50,
              titleStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            PieChartSectionData(
              value: netSalary,
              title: 'Net',
              color: Colors.purple,
              radius: 60,
              titleStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTable() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 5)],
      ),
      child: Table(
        border: TableBorder.all(color: Colors.black),
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
        color: isHighlighted ? Colors.green[100] : Colors.white,
      ),
      children: [
        Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            title,
            style: GoogleFonts.fredoka(
              fontSize: isHeader ? 18 : 16,
              fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
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
            ),
          ),
        ),
      ],
    );
  }

  Widget buildHistory() {
    return salaryHistory.isEmpty
        ? Center(child: Text("No History", style: GoogleFonts.fredoka(fontSize: 18)))
        : Column(
            children: salaryHistory.map((entry) {
              int index = salaryHistory.indexOf(entry);
              return Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  title: Text(
                    "Net Salary: \$${entry['Net Salary'].toStringAsFixed(2)}",
                    style: GoogleFonts.sofiaSans(color: Colors.black),
                  ),
                  subtitle: Text(
                    "Basic: ${entry['Basic Salary']} | Allowances: ${entry['Allowances']} | Deductions: ${entry['Deductions']}",
                    style: GoogleFonts.adventPro(color: Colors.black),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deleteHistory(index),
                  ),
                ),
              );
            }).toList(),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 236, 228, 252),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 109, 64, 255),
        title: Text(
          "Salary Calculator",
          style: GoogleFonts.fredoka(fontSize: 24, color: Colors.white),
        ),
        centerTitle: true,
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

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: calculateSalary,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                    child: Text("Calculate", style: GoogleFonts.fredoka(fontSize: 18)),
                  ),
                  SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: resetCalculator,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                    child: Text("Reset", style: GoogleFonts.fredoka(fontSize: 18)),
                  ),
                ],
              ),
              SizedBox(height: 25),

              // Chart and Table
              if (netSalary > 0) ...[
                Center(
                  child: Text(
                    "Salary Breakdown",
                    style: GoogleFonts.fredoka(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    buildPieChart(),
                    buildTable(),
                  ],
                ),
                SizedBox(height: 30),
              ],

              Center(
                child: Text("Salary History", style: GoogleFonts.fredoka(fontSize: 22, fontWeight: FontWeight.bold)),
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
        Text(label, style: GoogleFonts.fredoka(fontSize: 18)),
        SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: "Enter ${label.toLowerCase()}",
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        SizedBox(height: 12),
      ],
    );
  }
}
