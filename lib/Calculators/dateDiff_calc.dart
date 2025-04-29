import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class DateDifferenceCalculator extends StatefulWidget {
  @override
  _DateDifferenceCalculatorState createState() => _DateDifferenceCalculatorState();
}

class _DateDifferenceCalculatorState extends State<DateDifferenceCalculator> {
  DateTime? startDate;
  DateTime? endDate;
  String differenceText = "";

  void calculateDifference() {
    if (startDate == null || endDate == null) {
      setState(() {
        differenceText = "Please select both dates!";
      });
      return;
    }

    Duration difference = endDate!.difference(startDate!);
    int days = difference.inDays;
    int years = days ~/ 365;
    int months = (days % 365) ~/ 30;
    int remainingDays = (days % 365) % 30;

    setState(() {
      differenceText = "$years Years, $months Months, $remainingDays Days ";
    });
  }

  Future<void> selectDate(BuildContext context, bool isStart) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color.fromARGB(255, 112, 64, 255),
            colorScheme: ColorScheme.light(primary: Colors.purple),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 236, 228, 252),
      appBar: AppBar(
        title: Text(" Date Diff Calculator",
            style: GoogleFonts.mochiyPopOne(fontSize: 22, color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 121, 64, 255),
        elevation: 6,
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple.shade50, Colors.pink.shade50],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.shade100,
                  blurRadius: 15,
                  spreadRadius: 5,
                ),
              ],
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(" Select Your Dates ",
                    style: GoogleFonts.mochiyPopOne(
                      fontSize: 24,
                      color: Colors.purple[900],
                    )),
                const SizedBox(height: 30),

                // Date Pickers
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildDateButton("Start Date", startDate, () => selectDate(context, true)),
                    _buildDateButton("End Date", endDate, () => selectDate(context, false)),
                  ],
                ),

                const SizedBox(height: 30),

                ElevatedButton.icon(
                  onPressed: calculateDifference,
                  icon: Icon(Icons.calculate, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 80, 64, 255),
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  label: Text("Calculate",
                      style: GoogleFonts.mochiyPopOne(fontSize: 18, color: Colors.white)),
                ),

                const SizedBox(height: 40),

                AnimatedOpacity(
                  opacity: differenceText.isNotEmpty ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 300),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.pinkAccent.withOpacity(0.4),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      differenceText,
                      style: GoogleFonts.fredoka(fontSize: 22, color: Colors.purple[900]),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateButton(String label, DateTime? date, VoidCallback onPressed) {
    return Column(
      children: [
        Text(label, style: GoogleFonts.fredoka(fontSize: 16, color: Colors.purple[800])),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            elevation: 4,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(color: Colors.pinkAccent, width: 2),
            ),
          ),
          child: Text(
            date == null ? "Pick Date" : DateFormat("yyyy-MM-dd").format(date),
            style: GoogleFonts.fredoka(fontSize: 16, color: Colors.pinkAccent),
          ),
        ),
      ],
    );
  }
}
