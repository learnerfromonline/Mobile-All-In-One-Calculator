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
          backgroundColor: Colors.redAccent,
          content: Text("Enter valid marks!", style: GoogleFonts.karla(color: Colors.white)),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      appBar: AppBar(
        title: Text("📈 Percentage Calculator", style: GoogleFonts.rubik(fontSize: 24, color: Colors.white)),
        backgroundColor: Colors.teal.shade700,
        centerTitle: true,
        elevation: 4,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [BoxShadow(blurRadius: 6, color: Colors.grey.shade300)],
              ),
              child: Column(
                children: [
                  TextField(
                    controller: obtainedMarksController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Obtained Marks",
                      prefixIcon: Icon(Icons.grade, color: Colors.teal),
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: totalMarksController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Total Marks",
                      prefixIcon: Icon(Icons.school, color: Colors.deepPurple),
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: calculatePercentage,
                    icon: Icon(Icons.calculate,color: Colors.white,),
                    label: Text("Calculate", style: GoogleFonts.rubik(fontSize: 18,color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(107, 0, 32, 150),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            if (showResult)
              Column(
                children: [
                  Text(
                    "Your Percentage:",
                    style: GoogleFonts.fredoka(fontSize: 22, color: Colors.teal[900]),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "${percentage.toStringAsFixed(2)}%",
                    style: GoogleFonts.fredoka(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.deepPurple),
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
                            titleStyle: GoogleFonts.rubik(color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                          PieChartSectionData(
                            value: 100 - percentage,
                            title: '${(100 - percentage).toStringAsFixed(1)}%',
                            color: Colors.orangeAccent.shade100,
                            radius: 70,
                            titleStyle: GoogleFonts.rubik(color: Colors.black),
                          ),
                        ],
                        sectionsSpace: 5,
                        centerSpaceRadius: 40,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
