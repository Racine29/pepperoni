import 'package:flutter/material.dart';

class PizzaSlider extends StatelessWidget {
  double width;
  Color color;
  PizzaSlider({required this.width, required this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: width,
        height: 14,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(100),
        ),
      ),
    );
  }
}
