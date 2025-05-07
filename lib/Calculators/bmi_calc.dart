import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdvancedBMICalculator extends StatefulWidget {
  @override
  _AdvancedBMICalculatorState createState() => _AdvancedBMICalculatorState();
}

class _AdvancedBMICalculatorState extends State<AdvancedBMICalculator> {
  double height = 170;
  double weight = 70;
  int age = 25;
  String gender = "Male";
  double bmi = 0;
  String category = "";
  double bmr = 0;
  double waist = 80;
  List<String> bmiHistory = [];

  @override
  void initState() {
    super.initState();
    loadBMIHistory();
  }

  Future<void> loadBMIHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      bmiHistory = prefs.getStringList('bmiHistory') ?? [];
    });
  }

  Future<void> saveBMIHistory(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bmiHistory.add(value);
    await prefs.setStringList('bmiHistory', bmiHistory);
  }

  Future<void> clearBMIHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('bmiHistory');
    setState(() {
      bmiHistory.clear();
    });
  }

  void deleteHistoryItem(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      bmiHistory.removeAt(index);
    });
    await prefs.setStringList('bmiHistory', bmiHistory);
  }

  void calculateBMI() {
    setState(() {
      bmi = weight / ((height / 100) * (height / 100));
      category = getBMICategory(bmi);
      bmr = calculateBMR(weight, height, age, gender);
    });
    saveBMIHistory("BMI: ${bmi.toStringAsFixed(2)} ($category)");
  }

  String getBMICategory(double bmi) {
    if (bmi < 18.5) return "Underweight";
    if (bmi < 24.9) return "Normal";
    if (bmi < 29.9) return "Overweight";
    return "Obese";
  }

  double calculateBMR(double weight, double height, int age, String gender) {
    if (gender == "Male") {
      return 88.36 + (13.4 * weight) + (4.8 * height) - (5.7 * age);
    } else {
      return 447.6 + (9.2 * weight) + (3.1 * height) - (4.3 * age);
    }
  }

  double waistToHeightRatio() {
    return waist / height;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Advanced BMI Calculator",
          style: GoogleFonts.mochiyPopOne(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildInputCard(),
            const SizedBox(height: 24),
            _buildResultCard(),
            const SizedBox(height: 24),
            _buildHistoryCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 8,
      color: Colors.white,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey[200]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
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
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildSlider(
              "Height",
              "${height.toInt()} cm",
              height,
              100,
              250,
              (value) => setState(() => height = value),
            ),
            _buildSlider(
              "Weight",
              "${weight.toInt()} kg",
              weight,
              30,
              200,
              (value) => setState(() => weight = value),
            ),
            _buildSlider(
              "Age",
              "$age",
              age.toDouble(),
              10,
              100,
              (value) => setState(() => age = value.toInt()),
            ),
            const SizedBox(height: 16),
            _buildGenderSelector(),
            const SizedBox(height: 16),
            AnimatedScale(
              scale: 1.0,
              duration: const Duration(milliseconds: 200),
              child: ElevatedButton(
                onPressed: calculateBMI,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  elevation: 6,
                  shadowColor: Colors.grey[400],
                ),
                child: Text(
                  "Calculate",
                  style: GoogleFonts.mochiyPopOne(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider(String label, String value, double currentValue,
      double min, double max, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label: $value",
          style: GoogleFonts.nunito(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          child: Slider(
            value: currentValue,
            min: min,
            max: max,
            divisions: (max - min).toInt(),
            label: value,
            activeColor: Colors.black,
            inactiveColor: Colors.grey[400],
            onChanged: onChanged,
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildGenderSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          child: ChoiceChip(
            label: Text(
              "Male",
              style: GoogleFonts.nunito(
                fontSize: 16,
                color: gender == "Male" ? Colors.white : Colors.black,
              ),
            ),
            selected: gender == "Male",
            selectedColor: Colors.black,
            backgroundColor: Colors.grey[200],
            onSelected: (selected) {
              setState(() => gender = "Male");
            },
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
        ),
        const SizedBox(width: 12),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          child: ChoiceChip(
            label: Text(
              "Female",
              style: GoogleFonts.nunito(
                fontSize: 16,
                color: gender == "Female" ? Colors.white : Colors.black,
              ),
            ),
            selected: gender == "Female",
            selectedColor: Colors.black,
            backgroundColor: Colors.grey[200],
            onSelected: (selected) {
              setState(() => gender = "Female");
            },
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
        ),
      ],
    );
  }

  Widget _buildResultCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 8,
      color: Colors.white,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey[200]!, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
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
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Your Results",
                style: GoogleFonts.mochiyPopOne(
                  fontSize: 22,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildResultRow("BMI", "${bmi.toStringAsFixed(2)}"),
            _buildResultRow("Category", category),
            _buildResultRow("BMR", "${bmr.toStringAsFixed(2)} kcal/day"),
            _buildResultRow(
                "Waist/Height Ratio", "${waistToHeightRatio().toStringAsFixed(2)}"),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.nunito(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.nunito(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 8,
      color: Colors.white,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey[200]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
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
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "History",
                  style: GoogleFonts.mochiyPopOne(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: clearBMIHistory,
                  child: Text(
                    "Clear All",
                    style: GoogleFonts.nunito(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(color: Colors.grey),
            bmiHistory.isEmpty
                ? Text(
                    "No history yet",
                    style: GoogleFonts.nunito(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: bmiHistory.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => ListTile(
                      title: Text(
                        bmiHistory[index],
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () => deleteHistoryItem(index),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}