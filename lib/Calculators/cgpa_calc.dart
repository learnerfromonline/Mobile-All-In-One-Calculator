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
      if (gpa != null && gpa >= 0.0 && gpa <= 10.0) {
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
          backgroundColor: Colors.redAccent,
          content: Text(
            "Please enter valid GPA values (0 - 10).",
            textAlign: TextAlign.center,
            style: GoogleFonts.karla(color: Colors.white),
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
      backgroundColor: Colors.lightGreen[50],
      appBar: AppBar(
        title: Text("🎓 CGPA Calculator", style: GoogleFonts.kanit(color: Colors.white, fontSize: 24)),
        backgroundColor: Colors.teal.shade700,
        centerTitle: true,
        elevation: 6,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Enter number of semesters",
                labelStyle: GoogleFonts.rubik(color: Colors.teal[800]),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: Icon(Icons.numbers, color: Colors.teal),
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
                    color: Colors.lightBlue.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextField(
                        controller: gpaControllers[index],
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "GPA for Semester ${index + 1}",
                          labelStyle: GoogleFonts.karla(color: Colors.indigo[800]),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.school, color: Colors.indigo),
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
              label: Text("Calculate CGPA", style: GoogleFonts.karla(fontSize: 18, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
            const SizedBox(height: 20),
            if (showResult)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.yellow.shade100,
                  border: Border.all(color: Colors.orange.shade300, width: 2),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.2),
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
                    color: Colors.orange.shade800,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
