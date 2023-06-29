import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pepperoni/pizza_home.dart';
import 'package:pepperoni/pizza_list_bloc.dart';

import 'ingredient.dart';

class PizzaListIngredient extends StatelessWidget {
  Size size;
  double roundedContainerSize;
  ValueNotifier<double> pizzaIngredientNotifier;
  PageController ingredientPageController;
  Function(int index)? onPageChanged;

  PizzaListIngredient({
    required this.size,
    required this.roundedContainerSize,
    required this.pizzaIngredientNotifier,
    required this.ingredientPageController,
    this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PizzaListBloc(
      size: size,
      bottom: (roundedContainerSize / .88),
      left: (roundedContainerSize / 2),
      child: ValueListenableBuilder<double>(
          valueListenable: pizzaIngredientNotifier,
          builder: (context, listenable, _) {
            return Stack(
              children: [
                Container(
                  height: 120,
                  width: double.infinity,
                  alignment: Alignment.topCenter,
                  child: PageView.builder(
                      controller: ingredientPageController,
                      itemCount: ingredients.length,
                      onPageChanged: onPageChanged,
                      itemBuilder: (ctx, index) {
                        final ingredientPercent = listenable - index;
                        double ingredientRounded = ingredientPercent.abs();
                        final ingredient = ingredients[index];

                        return Stack(
                          children: [
                            Positioned(
                              top: 22,
                              left: 0,
                              right: 0,
                              child: Transform.translate(
                                offset: Offset(0, 28 * ingredientRounded),
                                child: Center(
                                  child: CircleAvatar(
                                    maxRadius: 20,
                                    backgroundColor:
                                        ingredient.color.withOpacity(.16),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.asset(
                                        ingredient.img,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                ),
                const Positioned(
                  top: 80,
                  left: 0,
                  right: 0,
                  child: CircleAvatar(
                    backgroundColor: Colors.red,
                    maxRadius: 3,
                  ),
                ),
              ],
            );
          }),
    );
  }
}
