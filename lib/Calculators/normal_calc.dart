import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _output = "0";
  String _input = "";
  double num1 = 0;
  double num2 = 0;
  String operand = "";
  bool isOperandPressed = false;

  void buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        _input = "";
        _output = "0";
        num1 = 0;
        num2 = 0;
        operand = "";
        isOperandPressed = false;
      } else if (buttonText == "⌫") {
        if (_input.isNotEmpty) {
          _input = _input.substring(0, _input.length - 1);
          _output = _input.isNotEmpty ? _input : "0";
        }
      } else if (buttonText == "=") {
        try {
          List<String> parts = _input.split(RegExp(r'[\+\-\×\÷%]'));
          if (parts.length == 2) {
            num1 = double.parse(parts[0]);
            num2 = double.parse(parts[1]);
            if (operand == "+") _output = (num1 + num2).toString();
            if (operand == "-") _output = (num1 - num2).toString();
            if (operand == "×") _output = (num1 * num2).toString();
            if (operand == "÷") _output = (num1 / num2).toString();
            if (operand == "%") _output = (num1 % num2).toString();
            _input = _output;
            isOperandPressed = false;
          }
        } catch (e) {
          _output = "Error";
        }
      } else if (["+", "-", "×", "÷", "%"].contains(buttonText)) {
        if (_input.isNotEmpty && !isOperandPressed) {
          operand = buttonText;
          _input += buttonText;
          _output = _input;
          isOperandPressed = true;
        }
      } else {
        _input += buttonText;
        _output = _input;
        isOperandPressed = false;
      }
    });
  }

  Widget buildButton(String text, Color color, Color textColor) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () => buttonPressed(text),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: EdgeInsets.all(20),
            elevation: 2,
          ),
          child: text == "⌫"
              ? Icon(Icons.backspace, color: textColor, size: 28)
              : Text(
                  text,
                  style: GoogleFonts.fredoka(
                    textStyle: TextStyle(
                      fontSize: 28,
                      color: textColor,
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Calculator",
          style: GoogleFonts.fredoka(fontSize: 24, color: Colors.white),
        ),
        centerTitle: true,
        leading: Icon(Icons.calculate_outlined, color: Colors.white),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Text(
                _output,
                style: GoogleFonts.fredoka(
                  textStyle: TextStyle(fontSize: 48, color: Colors.white),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: <Widget>[
                  Row(
                    children: [
                      buildButton("C", Colors.white, Colors.black),
                      buildButton("⌫", Colors.grey[800]!, Colors.white),
                      buildButton("%", Colors.grey[800]!, Colors.white),
                      buildButton("÷", Colors.grey[800]!, Colors.white),
                    ],
                  ),
                  Row(
                    children: [
                      buildButton("7", Colors.grey[900]!, Colors.white),
                      buildButton("8", Colors.grey[900]!, Colors.white),
                      buildButton("9", Colors.grey[900]!, Colors.white),
                      buildButton("×", Colors.grey[800]!, Colors.white),
                    ],
                  ),
                  Row(
                    children: [
                      buildButton("4", Colors.grey[900]!, Colors.white),
                      buildButton("5", Colors.grey[900]!, Colors.white),
                      buildButton("6", Colors.grey[900]!, Colors.white),
                      buildButton("-", Colors.grey[800]!, Colors.white),
                    ],
                  ),
                  Row(
                    children: [
                      buildButton("1", Colors.grey[900]!, Colors.white),
                      buildButton("2", Colors.grey[900]!, Colors.white),
                      buildButton("3", Colors.grey[900]!, Colors.white),
                      buildButton("+", Colors.grey[800]!, Colors.white),
                    ],
                  ),
                  Row(
                    children: [
                      buildButton("0", Colors.grey[900]!, Colors.white),
                      buildButton(".", Colors.grey[900]!, Colors.white),
                      buildButton("=", Colors.white, Colors.black),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
