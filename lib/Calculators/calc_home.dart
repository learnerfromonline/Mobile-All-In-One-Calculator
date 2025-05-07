
import 'package:calculator/Calculators/bmi_calc.dart';
import 'package:calculator/Calculators/cgpa_calc.dart';
import 'package:calculator/Calculators/compound_intrest_calc.dart';
import 'package:calculator/Calculators/dateDiff_calc.dart';
import 'package:calculator/Calculators/distance_calc.dart';
import 'package:calculator/Calculators/normal_calc.dart';
import 'package:calculator/Calculators/percentage_calc.dart';
import 'package:calculator/Calculators/salary_calc.dart';
import 'package:calculator/Calculators/sgpa_calc.dart';
import 'package:calculator/Calculators/simple_intrest_calc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';


class CartoonCalculatorHome extends StatefulWidget {
  @override
  State<CartoonCalculatorHome> createState() => _CartoonCalculatorHomeState();
}

class _CartoonCalculatorHomeState extends State<CartoonCalculatorHome> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.freehandTextTheme(),
      ),
      home: CalcHomeScreen(),
    );
  }
}

class CalcHomeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> calculators = [
    {'name': 'Calculator', 'icon': Icons.calculate, 'screen': CalculatorScreen()},
    {'name': 'CGPA Calculator', 'icon': Icons.school, 'screen': CgpaCalculator()},
    {'name': 'SGPA Calculator', 'icon': Icons.grade, 'screen': SgpaCalculator()},
    {'name': 'Percentage Calculator', 'icon': Icons.percent, 'screen': PercentageCalculator()},
    {'name': 'Date Difference Calculator', 'icon': Icons.date_range, 'screen': DateDifferenceCalculator()},
    {'name': 'BMI Calculator', 'icon': Icons.fitness_center, 'screen': AdvancedBMICalculator()},
    {'name': 'Compound Interest', 'icon': Icons.savings, 'screen': CompoundInterestCalculator()},
    {'name': 'Simple Interest', 'icon': Icons.monetization_on, 'screen': SimpleInterestCalculator()},
    {'name': 'Distance Calculator', 'icon': Icons.route, 'screen': DistanceCalculator()},
    {'name': 'Salary Calculator', 'icon': Icons.attach_money, 'screen': SalaryCalculator()},  
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(41, 0, 0, 0),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Center(child: Text('All In One Calculator', style: GoogleFonts.fredoka(fontSize: 22, fontWeight: FontWeight.bold,color: Colors.white24),textAlign: TextAlign.center,)),
        backgroundColor: const Color.fromARGB(98, 45, 43, 43),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 40,
            mainAxisSpacing: 40,
          ),
          itemCount: calculators.length,
          itemBuilder: (context, index) {
            return CalculatorCard(
              name: calculators[index]['name'],
              icon: calculators[index]['icon'],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => calculators[index]['screen']),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class CalculatorCard extends StatelessWidget {
  final String name;
  final IconData icon;
  final VoidCallback onTap;

  CalculatorCard({required this.name, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Animate(
        effects: [FadeEffect(duration: Duration(milliseconds: 500)),FlipEffect()],
        child: Card(
          
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 15,
          color: const Color.fromARGB(218, 17, 16, 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: Colors.white),
              SizedBox(height: 10),
              Text(
                name,
                textAlign: TextAlign.center,
                style: GoogleFonts.fredoka(fontSize: 18, color: Colors.white),
              ),
            ],
          ),
        ).animate(effects: [FadeEffect(duration: Duration(milliseconds: 900)),FadeEffect(duration: Duration(milliseconds: 500)),]),
      ),
    );
  }
}
