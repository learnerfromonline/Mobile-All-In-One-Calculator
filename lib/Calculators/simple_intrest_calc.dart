import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';

class SimpleInterestCalculator extends StatefulWidget {
  @override
  _SimpleInterestCalculatorState createState() =>
      _SimpleInterestCalculatorState();
}

class _SimpleInterestCalculatorState extends State<SimpleInterestCalculator> {
  TextEditingController principalController = TextEditingController();
  TextEditingController rateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  String selectedPeriod = "Years";
  double interest = 0.0;
  double totalAmount = 0.0;

  void calculateInterest() {
    setState(() {
      double principal = double.tryParse(principalController.text) ?? 0;
      double rate = double.tryParse(rateController.text) ?? 0;
      double time = double.tryParse(timeController.text) ?? 0;

      double timeInYears = time;
      if (selectedPeriod == "Days") timeInYears = time / 365;
      if (selectedPeriod == "Weeks") timeInYears = time / 52;
      if (selectedPeriod == "Months") timeInYears = time / 12;

      interest = (principal * rate * timeInYears) / 100;
      totalAmount = principal + interest;
    });
  }

  Widget buildChart() {
    return SizedBox(
      height: 250,
      width: 250,
      child: PieChart(
        PieChartData(
          sectionsSpace: 3,
          centerSpaceRadius: 50,
          sections: [
            PieChartSectionData(
              value: interest,
              title:
                  "${(interest / totalAmount * 100).toStringAsFixed(1)}%",
              color: Colors.redAccent,
              radius: 40,
              showTitle: true,
              
            ),
            PieChartSectionData(
              value: totalAmount - interest,
              
              title:
                  "${((totalAmount - interest) / totalAmount * 100).toStringAsFixed(1)}%",
              color: Colors.blueAccent,
              radius: 40,
              showTitle: true,
            ),
          ],
          pieTouchData: PieTouchData(touchCallback: (event, response) {
            setState(() {});
          }),
        ),
      ),
    );
  }

  Widget buildTable() {
    return DataTable(
      columnSpacing: 16,
      columns: [
        DataColumn(
            label:
                Text("Category", style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(
            label:
                Text("Value", style: TextStyle(fontWeight: FontWeight.bold))),
      ],
      rows: [
        DataRow(cells: [
          DataCell(Text("Principal Amount")),
          DataCell(Text(principalController.text)),
        ]),
        DataRow(cells: [
          DataCell(Text("Annual Interest Rate (%)")),
          DataCell(Text(rateController.text)),
        ]),
        DataRow(cells: [
          DataCell(Text("Time in $selectedPeriod")),
          DataCell(Text(timeController.text)),
        ]),
        DataRow(cells: [
          DataCell(Text("Total Interest Earned")),
          DataCell(Text(interest.toStringAsFixed(2))),
        ]),
        DataRow(cells: [
          DataCell(Text("Total Amount (P + I)")),
          DataCell(Text(totalAmount.toStringAsFixed(2))),
        ]),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        title: Text(
          "Simple Interest Calculator",
          style: GoogleFonts.fredoka(fontSize: 22, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text("Principal Amount:",
                style: GoogleFonts.fredoka(fontSize: 18)),
            TextField(
              controller: principalController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Enter principal amount",
                filled: true,
                fillColor: Colors.white,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(height: 10),
            Text("Annual Interest Rate (%):",
                style: GoogleFonts.fredoka(fontSize: 18)),
            TextField(
              controller: rateController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Enter interest rate",
                filled: true,
                fillColor: Colors.white,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(height: 10),
            Text("Time Period:", style: GoogleFonts.fredoka(fontSize: 18)),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: timeController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Enter time period",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                DropdownButton<String>(
                  value: selectedPeriod,
                  items: ["Days", "Weeks", "Months", "Years"]
                      .map((e) =>
                          DropdownMenuItem(child: Text(e), value: e))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedPeriod = value!;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: calculateInterest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                child: Text(
                  "Calculate",
                  style:
                      GoogleFonts.fredoka(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 20),
            if (interest > 0) ...[
              Center(
                child: Text("Results:",
                    style: GoogleFonts.fredoka(
                        fontSize: 22, fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Center(child: buildTable()),
                    SizedBox(width: 20),
                    Center(child: buildChart()),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
