import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class DistanceCalculator extends StatefulWidget {
  @override
  _DistanceCalculatorState createState() => _DistanceCalculatorState();
}

class _DistanceCalculatorState extends State<DistanceCalculator> {
  TextEditingController distance1Controller = TextEditingController();
  TextEditingController distance2Controller = TextEditingController();
  TextEditingController speedController = TextEditingController();
  TextEditingController arrivalTimeController = TextEditingController();

  String selectedTimeUnit = "Minutes";
  double timeRequired = 0.0;
  String startTime = "";

  void calculateTimeRequired() {
    setState(() {
      double distance1 = double.tryParse(distance1Controller.text) ?? 0;
      double distance2 = double.tryParse(distance2Controller.text) ?? 0;
      double speed = double.tryParse(speedController.text) ?? 0;

      if (speed > 0) {
        double distance = (distance2 - distance1).abs();
        double timeInHours = distance / speed;

        // Corrected Time Unit Conversion
        if (selectedTimeUnit == "Seconds") {
          timeRequired = timeInHours * 3600;
        } else if (selectedTimeUnit == "Minutes") {
          timeRequired = timeInHours * 60;
        } else {
          timeRequired = timeInHours;
        }
      }
    });
  }

  void calculateStartTime() {
    if (arrivalTimeController.text.isEmpty || timeRequired == 0) return;

    try {
      DateTime arrivalTime =
          DateFormat("HH:mm").parse(arrivalTimeController.text);
      DateTime calculatedStartTime;

      // Convert timeRequired to minutes for subtraction
      int timeToSubtract = (selectedTimeUnit == "Seconds")
          ? (timeRequired ~/ 60) // Convert seconds to minutes
          : (selectedTimeUnit == "Hours")
              ? (timeRequired * 60).toInt() // Convert hours to minutes
              : timeRequired.toInt();

      calculatedStartTime = arrivalTime.subtract(Duration(minutes: timeToSubtract));

      setState(() {
        startTime = DateFormat("HH:mm").format(calculatedStartTime);
      });
    } catch (e) {
      setState(() {
        startTime = "Invalid Time";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        title: Text(
          "Distance Calculator",
          style: GoogleFonts.fredoka(fontSize: 24, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Starting Distance (km):",
                  style: GoogleFonts.fredoka(fontSize: 18)),
              TextField(
                controller: distance1Controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Enter starting distance",
                  filled: true,
                  fillColor: Colors.white,
                  border:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(height: 10),

              Text("Destination Distance (km):",
                  style: GoogleFonts.fredoka(fontSize: 18)),
              TextField(
                controller: distance2Controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Enter destination distance",
                  filled: true,
                  fillColor: Colors.white,
                  border:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(height: 10),

              Text("Speed (km/h):", style: GoogleFonts.fredoka(fontSize: 18)),
              TextField(
                controller: speedController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Enter speed",
                  filled: true,
                  fillColor: Colors.white,
                  border:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(height: 10),

              Row(
                children: [
                  Text("Time Unit:", style: GoogleFonts.fredoka(fontSize: 18)),
                  SizedBox(width: 10),
                  DropdownButton<String>(
                    value: selectedTimeUnit,
                    items: ["Seconds", "Minutes", "Hours"]
                        .map((e) =>
                            DropdownMenuItem(child: Text(e), value: e))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedTimeUnit = value!;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),

              Center(
                child: ElevatedButton(
                  onPressed: calculateTimeRequired,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent,
                    padding:
                        EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  child: Text(
                    "Calculate Time Required",
                    style: GoogleFonts.fredoka(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 20),

              if (timeRequired > 0) ...[
                Center(
                  child: Text(
                    "Time Required: ${timeRequired.toStringAsFixed(2)} $selectedTimeUnit",
                    style: GoogleFonts.fredoka(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 20),
              ],

              Divider(),
              SizedBox(height: 20),

              Text("Arrival Time (HH:mm):",
                  style: GoogleFonts.fredoka(fontSize: 18)),
              TextField(
                controller: arrivalTimeController,
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                  hintText: "Enter expected arrival time",
                  filled: true,
                  fillColor: Colors.white,
                  border:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(height: 10),

              Center(
                child: ElevatedButton(
                  onPressed: calculateStartTime,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    padding:
                        EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  child: Text(
                    "Calculate Start Time",
                    style: GoogleFonts.fredoka(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 20),

              if (startTime.isNotEmpty) ...[
                Center(
                  child: Text(
                    "Start Time: $startTime",
                    style: GoogleFonts.fredoka(
                        fontSize: 22, fontWeight: FontWeight.bold),
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
