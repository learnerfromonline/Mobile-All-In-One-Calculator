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

  // Define your black and white color scheme
  final ColorScheme bwColorScheme = ColorScheme.fromSwatch(
    primarySwatch: Colors.grey, // Use grey as a base for black/white
    accentColor: Colors.black,
    brightness: Brightness.light, // Or Brightness.dark for a dark theme
  );

  void calculateInterest() {
    setState(() {
      double principal = double.tryParse(principalController.text) ?? 0;
      double rate = double.tryParse(rateController.text) ?? 0;
      double time = double.tryParse(timeController.text) ?? 0;

      if (principal <= 0 || rate <= 0 || time <= 0) {
        // Optional: You could show a snackbar or alert dialog here for invalid input
        return;
      }

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
              color: Colors.black87, // Dark grey for interest
              radius: 40,
              showTitle: true,
            ),
            PieChartSectionData(
              value: totalAmount - interest,
              title:
                  "${((totalAmount - interest) / totalAmount * 100).toStringAsFixed(1)}%",
              color: Colors.grey[400]!, // Light grey for principal
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
            label: Text("Category",
                style: TextStyle(fontWeight: FontWeight.bold, color: bwColorScheme.onSurface))),
        DataColumn(
            label: Text("Value",
                style: TextStyle(fontWeight: FontWeight.bold, color: bwColorScheme.onSurface))),
      ],
      rows: [
        DataRow(cells: [
          DataCell(Text("Principal Amount", style: TextStyle(color: bwColorScheme.onSurface))),
          DataCell(Text(principalController.text, style: TextStyle(color: bwColorScheme.onSurface))),
        ]),
        DataRow(cells: [
          DataCell(Text("Annual Interest Rate (%)", style: TextStyle(color: bwColorScheme.onSurface))),
          DataCell(Text(rateController.text, style: TextStyle(color: bwColorScheme.onSurface))),
        ]),
        DataRow(cells: [
          DataCell(Text("Time in $selectedPeriod", style: TextStyle(color: bwColorScheme.onSurface))),
          DataCell(Text(timeController.text, style: TextStyle(color: bwColorScheme.onSurface))),
        ]),
        DataRow(cells: [
          DataCell(Text("Total Interest Earned", style: TextStyle(color: bwColorScheme.onSurface))),
          DataCell(Text(interest.toStringAsFixed(2), style: TextStyle(color: bwColorScheme.onSurface))),
        ]),
        DataRow(cells: [
          DataCell(Text("Total Amount (P + I)", style: TextStyle(color: bwColorScheme.onSurface))),
          DataCell(Text(totalAmount.toStringAsFixed(2), style: TextStyle(color: bwColorScheme.onSurface))),
        ]),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return MaterialApp( // Wrap with MaterialApp to apply theme
      theme: ThemeData(
        colorScheme: bwColorScheme,
        textTheme: GoogleFonts.fredokaTextTheme(
          ThemeData.light().textTheme.apply(bodyColor: bwColorScheme.onSurface),
        ),
      ),
      home: Scaffold(
        backgroundColor: bwColorScheme.surface, // Use surface color for background
        appBar: AppBar(
          title: Text(
            "Simple Interest Calculator",
            style: TextStyle(fontSize: 22, color: bwColorScheme.onPrimary),
          ),
          centerTitle: true,
          backgroundColor: bwColorScheme.primary, // Use primary color for app bar
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Text("Principal Amount:", style: TextStyle(fontSize: 18, color: bwColorScheme.onSurface)),
              TextField(
                controller: principalController,
                keyboardType: TextInputType.number,
                style: TextStyle(color: bwColorScheme.onSurface),
                decoration: InputDecoration(
                  hintText: "Enter principal amount",
                  hintStyle: TextStyle(color: bwColorScheme.onSurface.withOpacity(0.6)),
                  filled: true,
                  fillColor: bwColorScheme.surfaceContainerHighest,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: bwColorScheme.outline)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: bwColorScheme.outline)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: bwColorScheme.primary)),
                ),
              ),
              SizedBox(height: 10),
              Text("Annual Interest Rate (%):",
                  style: TextStyle(fontSize: 18, color: bwColorScheme.onSurface)),
              TextField(
                controller: rateController,
                keyboardType: TextInputType.number,
                style: TextStyle(color: bwColorScheme.onSurface),
                decoration: InputDecoration(
                  hintText: "Enter interest rate",
                  hintStyle: TextStyle(color: bwColorScheme.onSurface.withOpacity(0.6)),
                  filled: true,
                  fillColor: bwColorScheme.surfaceContainerHighest,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: bwColorScheme.outline)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: bwColorScheme.outline)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: bwColorScheme.primary)),
                ),
              ),
              SizedBox(height: 10),
              Text("Time Period:", style: TextStyle(fontSize: 18, color: bwColorScheme.onSurface)),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: timeController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: bwColorScheme.onSurface),
                      decoration: InputDecoration(
                        hintText: "Enter time period",
                        hintStyle: TextStyle(color: bwColorScheme.onSurface.withOpacity(0.6)),
                        filled: true,
                        fillColor: bwColorScheme.surfaceContainerHighest,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: bwColorScheme.outline)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: bwColorScheme.outline)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: bwColorScheme.primary)),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  DropdownButton<String>(
                    value: selectedPeriod,
                    dropdownColor: bwColorScheme.surfaceContainerHighest,
                    style: TextStyle(color: bwColorScheme.onSurface),
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
                    backgroundColor: bwColorScheme.secondary,
                    foregroundColor: bwColorScheme.onSecondary,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  child: Text(
                    "Calculate",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              SizedBox(height: 20),
              if (interest > 0) ...[
                Center(
                  child: Text("Results:",
                      style: TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold, color: bwColorScheme.onSurface)),
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
      ),
    );
  }
}