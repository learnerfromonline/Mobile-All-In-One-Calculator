import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    if (selectedFrequency == 'Yearly') {
      n = 1;
    } else if (selectedFrequency == 'Half-Yearly') {
      n = 2;
    } else if (selectedFrequency == 'Quarterly') {
      n = 4;
    } else if (selectedFrequency == 'Monthly') {
      n = 12;
    } else {
      n = 365; // Daily
    }

    double amount = principal * pow((1 + (rate / 100) / n), (n * time));
    setState(() {
      totalAmount = amount;
      compoundInterest = amount - principal;
      breakdown = _generateBreakdown(principal, rate, time, n);
    });
  }

  List<Map<String, String>> _generateBreakdown(double principal, double rate, double time, int n) {
    List<Map<String, String>> breakdownList = [];
    for (int i = 1; i <= time; i++) {
      double yearlyAmount = principal * pow((1 + (rate / 100) / n), (n * i));
      double yearlyInterest = yearlyAmount - principal;
      breakdownList.add({
        "Year": "$i",
        "Total Amount": "\$${yearlyAmount.toStringAsFixed(2)}",
        "Interest Earned": "\$${yearlyInterest.toStringAsFixed(2)}"
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
      backgroundColor: const Color.fromARGB(255, 190, 193, 231),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 89, 64, 255),
        title: Text(
          " Compound Interest",
          style: GoogleFonts.fredoka(fontSize: 24, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(principalController, "Principal Amount"),
            SizedBox(height: 10),
            _buildTextField(rateController, "Annual Interest Rate (%)"),
            SizedBox(height: 10),
            _buildTextField(timeController, "Time (years)"),
            SizedBox(height: 10),
            _buildDropdown(),
            SizedBox(height: 20),
            _buildButtons(),
            SizedBox(height: 20),
            _buildResults(),
            if (breakdown.isNotEmpty) _buildBreakdownTable(),
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
        labelStyle: GoogleFonts.fredoka(fontSize: 18),
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedFrequency,
      items: ['Yearly', 'Half-Yearly', 'Quarterly', 'Monthly', 'Daily']
          .map((String value) => DropdownMenuItem(
                value: value,
                child: Text(value, style: GoogleFonts.fredoka(fontSize: 18)),
              ))
          .toList(),
      onChanged: (newValue) {
        setState(() {
          selectedFrequency = newValue!;
        });
      },
      decoration: InputDecoration(
        labelText: "Compounding Frequency",
        labelStyle: GoogleFonts.fredoka(fontSize: 18),
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget _buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: calculateCompoundInterest,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 41, 40, 41),
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          ),
          child: Text(
            "Calculate",
            style: GoogleFonts.fredoka(fontSize: 22, color: Colors.white),
          ),
        ),
        SizedBox(width: 20),
        ElevatedButton(
          onPressed: resetFields,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          ),
          child: Text(
            "Reset",
            style: GoogleFonts.fredoka(fontSize: 22, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildResults() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Total Amount: \$${totalAmount.toStringAsFixed(2)}",
          style: GoogleFonts.fredoka(fontSize: 20, color: Colors.purple[900]),
        ),
        Text(
          "Compound Interest: \$${compoundInterest.toStringAsFixed(2)}",
          style: GoogleFonts.fredoka(fontSize: 20, color: Colors.purple[900]),
        ),
      ],
    );
  }

  Widget _buildBreakdownTable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Text(
          "Yearly Breakdown 📊",
          style: GoogleFonts.fredoka(fontSize: 22, color: Colors.purple[900], fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Table(
          border: TableBorder.all(color: const Color.fromARGB(255, 115, 64, 255)),
          columnWidths: {
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(2),
            2: FlexColumnWidth(2),
          },
          children: [
            TableRow(
              decoration: BoxDecoration(color: const Color.fromARGB(255, 96, 64, 255).withOpacity(0.3)),
              children: [
                _buildTableCell("Year", true),
                _buildTableCell("Total Amount", true),
                _buildTableCell("Interest Earned", true),
              ],
            ),
            ...breakdown.map((data) => TableRow(
                  children: [
                    _buildTableCell(data["Year"]!),
                    _buildTableCell(data["Total Amount"]!),
                    _buildTableCell(data["Interest Earned"]!),
                  ],
                )),
          ],
        ),
      ],
    );
  }

  Widget _buildTableCell(String text, [bool isHeader = false]) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: GoogleFonts.fredoka(fontSize: isHeader ? 18 : 16, fontWeight: isHeader ? FontWeight.bold : FontWeight.normal),
      ),
    );
  }
}
