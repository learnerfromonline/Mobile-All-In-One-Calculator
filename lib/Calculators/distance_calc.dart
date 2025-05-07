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

      if (distance1 < 0 || distance2 < 0 || speed <= 0) {
        timeRequired = 0.0;
        startTime = "";
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Please enter valid positive values (speed must be > 0)",
              style: GoogleFonts.fredoka(fontSize: 16, color: Colors.white),
            ),
            backgroundColor: Colors.grey[800],
            duration: const Duration(seconds: 2),
          ),
        );
        return;
      }

      double distance = (distance2 - distance1).abs();
      double timeInHours = distance / speed;

      if (selectedTimeUnit == "Seconds") {
        timeRequired = timeInHours * 3600;
      } else if (selectedTimeUnit == "Minutes") {
        timeRequired = timeInHours * 60;
      } else {
        timeRequired = timeInHours;
      }
    });
  }

  void calculateStartTime() {
    if (arrivalTimeController.text.isEmpty || timeRequired == 0) {
      setState(() {
        startTime = "";
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Please calculate time required and enter arrival time",
              style: GoogleFonts.fredoka(fontSize: 16, color: Colors.white),
            ),
            backgroundColor: Colors.grey[800],
            duration: const Duration(seconds: 2),
          ),
        );
      });
      return;
    }

    try {
      DateTime arrivalTime = DateFormat("HH:mm").parseStrict(arrivalTimeController.text);
      DateTime calculatedStartTime;

      int timeToSubtract = (selectedTimeUnit == "Seconds")
          ? (timeRequired ~/ 60)
          : (selectedTimeUnit == "Hours")
              ? (timeRequired * 60).toInt()
              : timeRequired.toInt();

      calculatedStartTime = arrivalTime.subtract(Duration(minutes: timeToSubtract));

      setState(() {
        startTime = DateFormat("HH:mm").format(calculatedStartTime);
      });
    } catch (e) {
      setState(() {
        startTime = "";
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Invalid time format (use HH:mm, e.g., 14:30)",
              style: GoogleFonts.fredoka(fontSize: 16, color: Colors.white),
            ),
            backgroundColor: Colors.grey[800],
            duration: const Duration(seconds: 2),
          ),
        );
      });
    }
  }

  void resetFields() {
    setState(() {
      distance1Controller.clear();
      distance2Controller.clear();
      speedController.clear();
      arrivalTimeController.clear();
      selectedTimeUnit = "Minutes";
      timeRequired = 0.0;
      startTime = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          "Distance Calculator",
          style: GoogleFonts.fredoka(fontSize: 24, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInputCard(isMobile),
            const SizedBox(height: 24),
            _buildResultsCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputCard(bool isMobile) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      color: Colors.white,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey[200]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[300]!,
              blurRadius: 12,
              offset: const Offset(4, 4),
            ),
            BoxShadow(
              color: Colors.white,
              blurRadius: 12,
              offset: const Offset(-4, -4),
            ),
          ],
        ),
        padding: EdgeInsets.all(isMobile ? 16.0 : 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Starting Distance (km):",
              style: GoogleFonts.fredoka(fontSize: 18, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: distance1Controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Enter starting distance",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.black, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                prefixIcon: Icon(Icons.location_on, color: Colors.grey[600]),
              ),
              style: GoogleFonts.fredoka(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 16),
            Text(
              "Destination Distance (km):",
              style: GoogleFonts.fredoka(fontSize: 18, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: distance2Controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Enter destination distance",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.black, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                prefixIcon: Icon(Icons.location_on, color: Colors.grey[600]),
              ),
              style: GoogleFonts.fredoka(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 16),
            Text(
              "Speed (km/h):",
              style: GoogleFonts.fredoka(fontSize: 18, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: speedController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Enter speed",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.black, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                prefixIcon: Icon(Icons.speed, color: Colors.grey[600]),
              ),
              style: GoogleFonts.fredoka(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Time Unit:",
                        style: GoogleFonts.fredoka(fontSize: 18, color: Colors.black87),
                      ),
                      const SizedBox(height: 8),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey[300]!,
                              blurRadius: 8,
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                        child: DropdownButtonFormField<String>(
                          value: selectedTimeUnit,
                          items: ["Seconds", "Minutes", "Hours"]
                              .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(
                                      e,
                                      style: GoogleFonts.fredoka(fontSize: 16, color: Colors.black87),
                                    ),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedTimeUnit = value!;
                              timeRequired = 0.0;
                              startTime = "";
                            });
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                          ),
                          style: GoogleFonts.fredoka(fontSize: 16, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              "Arrival Time (HH:mm):",
              style: GoogleFonts.fredoka(fontSize: 18, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: arrivalTimeController,
              keyboardType: TextInputType.datetime,
              decoration: InputDecoration(
                hintText: "Enter arrival time (e.g., 14:30)",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.black, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                prefixIcon: Icon(Icons.access_time, color: Colors.grey[600]),
              ),
              style: GoogleFonts.fredoka(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 24),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedScale(
                    scale: 1.0,
                    duration: const Duration(milliseconds: 200),
                    child: ElevatedButton(
                      onPressed: calculateTimeRequired,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 6,
                        shadowColor: Colors.grey[400],
                      ),
                      child: Text(
                        softWrap: false,
              
                        "Calculate Time",
                        style: GoogleFonts.fredoka(
                          fontSize: 18,
              
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  AnimatedScale(
                    scale: 1.0,
                    duration: const Duration(milliseconds: 200),
                    child: ElevatedButton(
                      onPressed: calculateStartTime,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[600],
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 6,
                        shadowColor: Colors.grey[400],
                      ),
                      child: Text(
                        "Calculate Start",
                        style: GoogleFonts.fredoka(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  AnimatedScale(
                    scale: 1.0,
                    duration: const Duration(milliseconds: 200),
                    child: ElevatedButton(
                      onPressed: resetFields,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[400],
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 6,
                        shadowColor: Colors.grey[400],
                      ),
                      child: Text(
                        "Reset",
                        style: GoogleFonts.fredoka(
                          fontSize: 18,
                          color: const Color.fromARGB(146, 167, 12, 12),
                          fontWeight: FontWeight.w500,
                        ),
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

  Widget _buildResultsCard() {
    return AnimatedOpacity(
      opacity: (timeRequired > 0 || startTime.isNotEmpty) ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: (timeRequired > 0 || startTime.isNotEmpty)
          ? Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 8,
              color: Colors.white,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.white, Colors.grey[200]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[300]!,
                      blurRadius: 12,
                      offset: const Offset(4, 4),
                    ),
                    BoxShadow(
                      color: Colors.white,
                      blurRadius: 12,
                      offset: const Offset(-4, -4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Results:",
                      style: GoogleFonts.fredoka(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (timeRequired > 0)
                      Text(
                        "Time Required: ${selectedTimeUnit == "Seconds" ? timeRequired.toInt() : timeRequired.toStringAsFixed(2)} $selectedTimeUnit",
                        style: GoogleFonts.fredoka(
                          fontSize: 20,
                          color: Colors.black87,
                        ),
                      ),
                    if (startTime.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        "Start Time: $startTime",
                        style: GoogleFonts.fredoka(
                          fontSize: 20,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            )
          : Container(),
    );
  }
}