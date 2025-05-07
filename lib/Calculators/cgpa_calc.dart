import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CgpaCalculator extends StatefulWidget {
  @override
  _CgpaCalculatorState createState() => _CgpaCalculatorState();
}

class _CgpaCalculatorState extends State<CgpaCalculator> {
  int subjectCount = 0;
  List<TextEditingController> gpaControllers = [];
  double cgpa = 0.0;
  bool showResult = false;

  void calculateCGPA() {
    double totalGPA = 0.0;
    int validSubjects = 0;

    for (var controller in gpaControllers) {
      double? gpa = double.tryParse(controller.text);
      if (gpa != null && gpa >= 0.0 && gpa <= 15.0) {
        totalGPA += gpa;
        validSubjects++;
      }
    }

    if (validSubjects > 0) {
      setState(() {
        cgpa = totalGPA / validSubjects;
        showResult = true;
      });
    } else {
      setState(() {
        showResult = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.grey[900],
          content: Text(
            "Please enter valid GPA values (0 - 15).",
            textAlign: TextAlign.center,
            style: GoogleFonts.fredoka(color: Colors.white),
          ),
        ),
      );
    }
  }

  void setSubjectCount(String value) {
    int? count = int.tryParse(value);
    if (count != null && count > 0) {
      setState(() {
        subjectCount = count;
        gpaControllers = List.generate(count, (index) => TextEditingController());
        showResult = false;
      });
    }
  }

  @override
  void dispose() {
    for (var controller in gpaControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212), // Black background
      appBar: AppBar(
        title: Text(
          "🎓 CGPA Calculator",
          style: GoogleFonts.fredoka(color: Colors.white, fontSize: 24),
        ),
        backgroundColor: Color(0xFF121212),
        centerTitle: true,
        elevation: 6,
        iconTheme: IconThemeData(color: Colors.transparent),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.white), // Fix: user text visible
              decoration: InputDecoration(
                labelText: "Enter number of semesters",
                labelStyle: GoogleFonts.fredoka(color: Colors.white),
                filled: true,
                fillColor: Color(0xFF1E1E1E), // Dark gray field
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: Icon(Icons.numbers, color: Colors.white),
                hintText: 'e.g., 5',
                hintStyle: GoogleFonts.fredoka(color: Colors.grey[500]),
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
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    color: Color(0xFF1E1E1E),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextField(
                        controller: gpaControllers[index],
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: Colors.white), // Fix: user text visible
                        decoration: InputDecoration(
                          labelText: "GPA for Semester ${index + 1}",
                          labelStyle: GoogleFonts.fredoka(color: Colors.white),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          filled: true,
                          fillColor: Color(0xFF2C2C2C),
                          prefixIcon: Icon(Icons.school, color: Colors.white),
                          hintText: 'e.g., 8.5',
                          hintStyle: GoogleFonts.fredoka(color: Colors.grey[500]),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: calculateCGPA,
              icon: Icon(Icons.calculate, color: Colors.white),
              label: Text("Calculate CGPA", style: GoogleFonts.fredoka(fontSize: 18, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: Colors.white, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (showResult)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0xFF1E1E1E),
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  "Your CGPA: ${cgpa.toStringAsFixed(2)}",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.fredoka(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
