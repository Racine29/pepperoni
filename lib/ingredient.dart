import 'dart:ui';

import 'package:flutter/material.dart';

class Ingredients {
  String img;
  Color color;
  Ingredients({required this.img, required this.color});
}

List<Ingredients> ingredients = [
  Ingredients(img: "asset/concombre.png", color: Colors.green),
  Ingredients(img: "asset/piment.png", color: Colors.red),
  Ingredients(img: "asset/champignon.png", color: Colors.amber),
  Ingredients(img: "asset/olive.png", color: Colors.black),
  Ingredients(img: "asset/raisin.png", color: Colors.black),
  Ingredients(img: "asset/concombre.png", color: Colors.green),
];

List<String> pizzaSizes = ["S", "M", "L"];
List<double> xStart(Size size, double decalage) => [
      -size.height * (.1 + decalage),
      size.height * (.7 + decalage),
      -size.height * (.6 + decalage),
      -size.height * (.7 + decalage),
      -size.height * (.6 + decalage),
      size.height * (.8 + decalage),
      -size.height * (.2 + decalage),
      -size.height * (.7 + decalage),
      size.height * (.63 + decalage),
      -size.height * (.6 + decalage),
      -size.height * (.8 + decalage),
      size.height * (.3 + decalage),
    ];
List<double> xEnd(Size size, double decalage) => [
      -size.height * .01 + decalage,
      size.height * .07 + decalage,
      -size.height * .04 + decalage,
      -size.height * .03 + decalage,
      -size.height * .06 + decalage,
      size.height * .02 + decalage,
      -size.height * .09 + decalage,
      -size.height * .02 + decalage,
      size.height * .07 + decalage,
      -size.height * .0 + decalage,
      -size.height * .1 + decalage,
      size.height * .04 + decalage,
    ];
List<double> yStart(Size size, double decalage) => [
      -size.height * (.9 + decalage),
      size.height * (.9 + decalage),
      size.height * (.2 + decalage),
      -size.height * (.4 + decalage),
      -size.height * (.4 + decalage),
      size.height * (.8 + decalage),
      size.height * (.8 + decalage),
      -size.height * (.4 + decalage),
      -size.height * (.22 + decalage),
      -size.height * (.42 + decalage),
      -size.height * (.34 + decalage),
      -size.height * (.9 + decalage),
    ];
List<double> yEnd(Size size, double decalage) => [
      -size.height * (.24 + decalage),
      -size.height * (.17 + decalage),
      -size.height * (.15 + decalage),
      -size.height * (.26 + decalage),
      -size.height * (.2 + decalage),
      -size.height * (.22 + decalage),
      -size.height * (.12 + decalage),
      -size.height * (.24 + decalage),
      -size.height * (.21 + decalage),
      -size.height * (.1 + decalage),
      -size.height * (.18 + decalage),
      -size.height * (.25 + decalage),
    ];

List<Map<String, dynamic>> epices(
  String ingredientName,
  Size size,
) {
  return [
    {
      "img": "asset/concombre-1.png",
      "xStart": xStart(size, 0),
      "xEnd": xEnd(size, 0.0),
      "yStart": yStart(size, 0.0),
      "yEnd": yEnd(size, 0.0),
    },
    {
      "img": "asset/piment-1.png",
      "xStart": xStart(size, .02),
      "xEnd": xEnd(size, .02),
      "yStart": yStart(size, .02),
      "yEnd": yEnd(size, -.01),
    },
    {
      "img": "asset/champignon-1.png",
      "xStart": xStart(size, .06),
      "xEnd": xEnd(size, .055),
      "yStart": yStart(size, .02),
      "yEnd": yEnd(size, -.025),
    },
  ];
}
