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
      backgroundColor: const Color(0xFFF8F3F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF8C52FF),
        title: Text("Advanced BMI Calculator",
            style: GoogleFonts.mochiyPopOne(color: Colors.white, fontSize: 20)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInputCard(),
            const SizedBox(height: 20),
            _buildResultCard(),
            const SizedBox(height: 20),
            _buildHistoryCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildSlider("Height", "${height.toInt()} cm", height, 100, 250,
                (value) => setState(() => height = value)),
            _buildSlider("Weight", "${weight.toInt()} kg", weight, 30, 200,
                (value) => setState(() => weight = value)),
            _buildSlider("Age", "$age", age.toDouble(), 10, 100,
                (value) => setState(() => age = value.toInt())),
            const SizedBox(height: 10),
            _buildGenderSelector(),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: calculateBMI,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8C52FF),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text("Calculate",
                  style: GoogleFonts.mochiyPopOne(color: Colors.white)),
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
        Text("$label: $value",
            style:
                GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w600)),
        Slider(
          value: currentValue,
          min: min,
          max: max,
          divisions: (max - min).toInt(),
          label: value,
          activeColor: const Color(0xFF8C52FF),
          onChanged: onChanged,
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildGenderSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ChoiceChip(
          label: const Text("Male"),
          selected: gender == "Male",
          selectedColor: const Color(0xFF8C52FF),
          onSelected: (selected) {
            setState(() => gender = "Male");
          },
        ),
        const SizedBox(width: 10),
        ChoiceChip(
          label: const Text("Female"),
          selected: gender == "Female",
          selectedColor: const Color(0xFFEC87C0),
          onSelected: (selected) {
            setState(() => gender = "Female");
          },
        ),
      ],
    );
  }

  Widget _buildResultCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      color: const Color(0xFFE7D9F8),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  elevation: 8,
  color: const Color(0xFFE7D9F8),
  child: Padding(
    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            "Your Results",
            style: GoogleFonts.mochiyPopOne(
              fontSize: 20,
              color: const Color(0xFF4A148C),
            ),
          ),
        ),
        const SizedBox(height: 20),
        _buildResultRow("BMI", "${bmi.toStringAsFixed(2)}"),
        _buildResultRow("Category", category),
        _buildResultRow("BMR", "${bmr.toStringAsFixed(2)} kcal/day"),
        _buildResultRow("Waist/Height Ratio", "${waistToHeightRatio().toStringAsFixed(2)}"),
      ],
    ),
  ),
)

      ),
    );
  }
  Widget _buildResultRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        Text(
          value,
          style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    ),
  );
}


  Widget _buildHistoryCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 6,
      color: const Color(0xFFFDF5FF),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("History",
                    style: GoogleFonts.mochiyPopOne(fontSize: 16)),
                TextButton(
                  onPressed: clearBMIHistory,
                  child: Text("Clear All",
                      style: GoogleFonts.nunito(
                          color: Colors.redAccent, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            const Divider(),
            bmiHistory.isEmpty
                ? Text("No history yet",
                    style: GoogleFonts.nunito(color: Colors.grey))
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: bmiHistory.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => ListTile(
                      title: Text(bmiHistory[index],
                          style: GoogleFonts.nunito()),
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
