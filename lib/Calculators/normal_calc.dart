import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

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
        _output = _input;  // ✅ Update the display with the operator
        isOperandPressed = true;
      }
    } else {
      _input += buttonText;
      _output = _input;  // ✅ Update the display with numbers
      isOperandPressed = false;
    }
  });
}


  Widget buildButton(String text, Color color) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ElevatedButton(
          onPressed: () => buttonPressed(text),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: EdgeInsets.all(20),
            elevation: 10,
            shadowColor: Colors.pinkAccent,
          ),
          child: Text(
            text,
            style: GoogleFonts.fredoka(
              textStyle: TextStyle(
                fontSize: 28,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (RawKeyEvent event) {
        if (event is RawKeyDownEvent) {
          String key = event.logicalKey.keyLabel;
          if (key == "Backspace") {
            buttonPressed("⌫");
          } else if (key == "Enter") {
            buttonPressed("=");
          } else if (key == "Escape") {
            buttonPressed("C");
          } else if (key == "Shift") {
            // Ignore shift key
          } else if (["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ".", "+", "-", "*", "/", "%"].contains(key)) {
            if (key == "*") key = "×";
            if (key == "/") key = "÷";
            buttonPressed(key);
          }
        }
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(161, 18, 18, 18),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 147, 64, 255),
          title: Text(
            " Calculator",
            style: GoogleFonts.fredoka(fontSize: 24, color: Colors.white),
          ),
          centerTitle: true,
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
                    textStyle: TextStyle(fontSize: 48, color: const Color.fromARGB(255, 253, 251, 255)),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.pinkAccent.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: [
                        buildButton("C", Colors.redAccent),
                        buildButton("⌫", Colors.orangeAccent),
                        buildButton("%", Colors.blueAccent),
                        buildButton("÷", Colors.pinkAccent),
                      ],
                    ),
                    Row(
                      children: [
                        buildButton("7", Colors.purple),
                        buildButton("8", Colors.purple),
                        buildButton("9", Colors.purple),
                        buildButton("×", Colors.pinkAccent),
                      ],
                    ),
                    Row(
                      children: [
                        buildButton("4", Colors.purple),
                        buildButton("5", Colors.purple),
                        buildButton("6", Colors.purple),
                        buildButton("-", Colors.pinkAccent),
                      ],
                    ),
                    Row(
                      children: [
                        buildButton("1", Colors.purple),
                        buildButton("2", Colors.purple),
                        buildButton("3", Colors.purple),
                        buildButton("+", Colors.pinkAccent),
                      ],
                    ),
                    Row(
                      children: [
                        buildButton("0", Colors.purple),
                        buildButton(".", Colors.purple),
                        buildButton("=", Colors.green),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
