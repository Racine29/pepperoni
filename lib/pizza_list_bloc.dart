import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pepperoni/pizza_home.dart';

import 'ingredient.dart';

class PizzaListBloc extends StatelessWidget {
  Size size;
  Widget child;
  double left;
  double bottom;

  PizzaListBloc({
    required this.size,
    required this.child,
    required this.left,
    required this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: (size.width / 2) - left,
      bottom: (size.height / 2) - bottom,
      child: Container(
        height: roundedContainerSize,
        width: roundedContainerSize,
        alignment: Alignment.topCenter,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(1000),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.1),
                blurRadius: 20,
                spreadRadius: 2,
                offset: Offset(0, 0),
              ),
            ]),
        child: child,
      ),
    );
  }
}
