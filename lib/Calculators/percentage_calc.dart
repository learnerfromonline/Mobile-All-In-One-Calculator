import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';

class PercentageCalculator extends StatefulWidget {
  @override
  _PercentageCalculatorState createState() => _PercentageCalculatorState();
}

class _PercentageCalculatorState extends State<PercentageCalculator> {
  final TextEditingController obtainedMarksController = TextEditingController();
  final TextEditingController totalMarksController = TextEditingController();
  double percentage = 0.0;
  bool showResult = false;

  void calculatePercentage() {
    double? obtainedMarks = double.tryParse(obtainedMarksController.text);
    double? totalMarks = double.tryParse(totalMarksController.text);

    if (obtainedMarks != null && totalMarks != null && totalMarks > 0) {
      setState(() {
        percentage = (obtainedMarks / totalMarks) * 100;
        showResult = true;
      });
    } else {
      setState(() {
        showResult = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.grey[800],
          content: Text("Enter valid marks!", style: GoogleFonts.fredoka(color: Colors.white)),
        ),
      );
    }
  }

  @override
  void dispose() {
    obtainedMarksController.dispose();
    totalMarksController.dispose();
    super.dispose();
  }

  InputDecoration buildInputDecoration(String label, IconData icon, Color iconColor) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.fredoka(color: Colors.grey[400]),
      prefixIcon: Icon(icon, color: iconColor),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: iconColor, width: 2),
      ),
      hintStyle: GoogleFonts.fredoka(color: Colors.grey[500]),
      contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("📈 Percentage Calculator", style: GoogleFonts.fredoka(fontSize: 24, color: Colors.white)),
        backgroundColor: Colors.black,
        centerTitle: true,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 500),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.grey[300] ?? Colors.blueGrey],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(color: Colors.grey[400]!, blurRadius: 12, offset: Offset(0, 8)),
                ],
              ),
              child: Column(
                children: [
                  TextField(
                    controller: obtainedMarksController,
                    keyboardType: TextInputType.number,
                    decoration: buildInputDecoration("Obtained Marks", Icons.grade, Colors.black),
                    style: GoogleFonts.fredoka(color: Colors.black),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: totalMarksController,
                    keyboardType: TextInputType.number,
                    decoration: buildInputDecoration("Total Marks", Icons.school, Colors.grey[600]!),
                    style: GoogleFonts.fredoka(color: Colors.black),
                  ),
                  const SizedBox(height: 25),
                  ElevatedButton.icon(
                    onPressed: calculatePercentage,
                    icon: Icon(Icons.calculate, color: Colors.white),
                    label: Text("Calculate", style: GoogleFonts.fredoka(fontSize: 18, color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 30),
                      elevation: 6,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            if (showResult)
              AnimatedOpacity(
                duration: Duration(milliseconds: 600),
                opacity: showResult ? 1.0 : 0.0,
                child: Column(
                  children: [
                    Text(
                      "Your Percentage:",
                      style: GoogleFonts.fredoka(fontSize: 22, color: Colors.black),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "${percentage.toStringAsFixed(2)}%",
                      style: GoogleFonts.fredoka(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.grey[800]),
                    ),
                    const SizedBox(height: 30),
                    AspectRatio(
                      aspectRatio: 1.2,
                      child: PieChart(
                        PieChartData(
                          sections: [
                            PieChartSectionData(
                              value: percentage,
                              title: '${percentage.toStringAsFixed(1)}%',
                              color: Colors.greenAccent.shade400,
                              radius: 70,
                              titleStyle: GoogleFonts.fredoka(color: Colors.black, fontWeight: FontWeight.bold),
                            ),
                            PieChartSectionData(
                              value: 100 - percentage,
                              title: '${(100 - percentage).toStringAsFixed(1)}%',
                              color: Colors.orangeAccent.shade100,
                              radius: 70,
                              titleStyle: GoogleFonts.fredoka(color: Colors.black),
                            ),
                          ],
                          sectionsSpace: 5,
                          centerSpaceRadius: 40,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}