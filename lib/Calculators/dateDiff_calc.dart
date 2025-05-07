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
  String resultText = "";
  bool isAgeMode = false;

  void calculate() {
    if (startDate == null) {
      setState(() {
        resultText = "Please select your birth date!";
      });
      return;
    }

    if (!isAgeMode && endDate == null) {
      setState(() {
        resultText = "Please select both dates!";
      });
      return;
    }

    DateTime finalEndDate = isAgeMode ? DateTime.now() : endDate!;
    Duration difference = finalEndDate.difference(startDate!);
    int days = difference.inDays;
    int years = days ~/ 365;
    int months = (days % 365) ~/ 30;
    int remainingDays = (days % 365) % 30;

    setState(() {
      resultText = isAgeMode
          ? "You are $years Years, $months Months, $remainingDays Days old."
          : "$years Years, $months Months, $remainingDays Days";
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
            primaryColor: Colors.black,
            colorScheme: ColorScheme.light(primary: Colors.black),
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
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          isAgeMode ? "Age Calculator" : "Date Diff Calculator",
          style: GoogleFonts.mochiyPopOne(fontSize: 22, color: Colors.white),
        ),
        backgroundColor: Colors.black,
        elevation: 6,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.swap_horiz, color: Colors.white),
            tooltip: 'Switch Mode',
            onPressed: () {
              setState(() {
                isAgeMode = !isAgeMode;
                resultText = "";
                startDate = null;
                endDate = null;
              });
            },
          )
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Colors.grey[300] ?? Colors.blueGrey],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[400]!,
                  blurRadius: 15,
                  spreadRadius: 5,
                ),
              ],
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isAgeMode ? "Select Your Birth Date" : "Select Your Dates",
                  style: GoogleFonts.mochiyPopOne(fontSize: 24, color: Colors.black),
                ),
                const SizedBox(height: 30),

                // Date Pickers
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildDateButton(isAgeMode ? "Birth Date" : "Start Date", startDate,
                        () => selectDate(context, true)),
                    if (!isAgeMode)
                      _buildDateButton("End Date", endDate, () => selectDate(context, false)),
                  ],
                ),

                const SizedBox(height: 30),

                ElevatedButton.icon(
                  onPressed: calculate,
                  icon: Icon(Icons.calculate, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  label: Text(
                    "Calculate",
                    style: GoogleFonts.mochiyPopOne(fontSize: 18, color: Colors.white),
                  ),
                ),

                const SizedBox(height: 40),

                AnimatedOpacity(
                  opacity: resultText.isNotEmpty ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 300),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[400]!.withOpacity(0.4),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      resultText,
                      style: GoogleFonts.fredoka(fontSize: 22, color: Colors.black),
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
        Text(label, style: GoogleFonts.fredoka(fontSize: 16, color: Colors.grey[800])),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            elevation: 4,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(color: Colors.grey[600]!, width: 2),
            ),
          ),
          child: Text(
            date == null ? "Pick Date" : DateFormat("yyyy-MM-dd").format(date),
            style: GoogleFonts.fredoka(fontSize: 16, color: Colors.grey[600]),
          ),
        ),
      ],
    );
  }
}