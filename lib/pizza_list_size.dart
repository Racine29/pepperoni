import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pepperoni/pizza_home.dart';
import 'package:pepperoni/pizza_list_bloc.dart';

import 'ingredient.dart';

class PizzaListSize extends StatelessWidget {
  Size size;
  double roundedContainerSize;
  ValueNotifier<double> pizzaSizeNotifier;
  PageController pageController;
  Function(int index, String pizzaSize) onTap;
  int pizzaCurrentSizeIndex;

  PizzaListSize({
    required this.size,
    required this.roundedContainerSize,
    required this.pizzaSizeNotifier,
    required this.pageController,
    required this.onTap,
    required this.pizzaCurrentSizeIndex,
  });

  @override
  Widget build(BuildContext context) {
    return PizzaListBloc(
      size: size,
      bottom: (roundedContainerSize / .97),
      left: (roundedContainerSize / 2),
      child: ValueListenableBuilder<double>(
          valueListenable: pizzaSizeNotifier,
          builder: (context, value, _) {
            return Stack(
              children: [
                SizedBox(
                  height: 100,
                  child: PageView.builder(
                      controller: pageController,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (ctx, index) {
                        final percent = value - index;
                        double rounded = percent.abs();
                        final pizzaSize = pizzaSizes[index % pizzaSizes.length];
                        return InkWell(
                          onTap: () {
                            onTap(index, pizzaSize);
                            pageController.animateToPage(index,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut);
                          },
                          child: Center(
                            child: Transform.translate(
                              offset: Offset(0, lerpDouble(-14, 14, rounded)!),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  pizzaSize,
                                  style: TextStyle(
                                    color: pizzaCurrentSizeIndex == index
                                        ? Colors.red
                                        : Colors.black87,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ),

                // Arc rouge au dessus des taille du pizza
                Positioned(
                  top: 4,
                  left: (size.width / 2) +
                      (size.width * .3 / 2) +
                      ((size.width * .1) / 2),
                  child: CustomPaint(
                    size: Size(size.width, 0),
                    painter: MyArc(size: size),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
