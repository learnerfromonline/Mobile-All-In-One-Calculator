import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SgpaCalculator extends StatefulWidget {
  @override
  _SgpaCalculatorState createState() => _SgpaCalculatorState();
}

class _SgpaCalculatorState extends State<SgpaCalculator> {
  int subjectCount = 0;
  List<TextEditingController> gpaControllers = [];
  List<TextEditingController> creditControllers = [];
  double sgpa = 0.0;
  bool showResult = false;

  void calculateSGPA() {
    double totalWeightedGPA = 0.0;
    int totalCredits = 0;

    for (int i = 0; i < subjectCount; i++) {
      double? gpa = double.tryParse(gpaControllers[i].text);
      int? credits = int.tryParse(creditControllers[i].text);

      if (gpa != null && credits != null && gpa >= 0.0 && gpa <= 10.0 && credits > 0) {
        totalWeightedGPA += gpa * credits;
        totalCredits += credits;
      }
    }

    if (totalCredits > 0) {
      setState(() {
        sgpa = totalWeightedGPA / totalCredits;
        showResult = true;
      });
    } else {
      setState(() {
        showResult = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter valid GPA (0-10) and credit values!")),
      );
    }
  }

  void setSubjectCount(String value) {
    int? count = int.tryParse(value);
    if (count != null && count > 0) {
      setState(() {
        subjectCount = count;
        gpaControllers = List.generate(count, (index) => TextEditingController());
        creditControllers = List.generate(count, (index) => TextEditingController());
        showResult = false;
      });
    }
  }

  @override
  void dispose() {
    for (var controller in gpaControllers) {
      controller.dispose();
    }
    for (var controller in creditControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: Text(
          "🎓 SGPA Calculator",
          style: GoogleFonts.kanit(fontSize: 24, color: Colors.white),
        ),
        backgroundColor: Colors.indigo.shade700,
        centerTitle: true,
        elevation: 8,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Number of Subjects",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.library_books_rounded, color: Colors.indigo),
              ),
              onChanged: setSubjectCount,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: subjectCount,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    color: Colors.green.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: creditControllers[index],
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: "Credits (Sub ${index + 1})",
                                labelStyle: GoogleFonts.rubik(),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                filled: true,
                                fillColor: Colors.white,
                                prefixIcon: Icon(Icons.bookmark, color: Colors.teal),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: gpaControllers[index],
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: "GPA (Sub ${index + 1})",
                                labelStyle: GoogleFonts.rubik(),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                filled: true,
                                fillColor: Colors.white,
                                prefixIcon: Icon(Icons.grade, color: Colors.amber[800]),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: calculateSGPA,
              icon: Icon(Icons.calculate, color: Colors.white),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo.shade600,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              label: Text("Calculate SGPA", style: GoogleFonts.karla(fontSize: 18, color: Colors.white)),
            ),
            const SizedBox(height: 20),
            if (showResult)
              AnimatedContainer(
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.indigo[50],
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.indigo, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.indigo.withOpacity(0.2),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    )
                  ],
                ),
                child: Text(
                  "Your SGPA: ${sgpa.toStringAsFixed(2)}",
                  style: GoogleFonts.kanit(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.indigo[900]),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
