import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pepperoni/pizza_list_ingredient.dart';
import 'package:pepperoni/pizza_list_size.dart';
import 'package:pepperoni/pizza_slider.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import 'ingredient.dart';
import 'dart:ui' as ui;

class PizzaHome extends StatefulWidget {
  PizzaHome({super.key});

  @override
  State<PizzaHome> createState() => _PizzaHomeState();
}

double roundedContainerSize = 700;

class _PizzaHomeState extends State<PizzaHome> with TickerProviderStateMixin {
  final pizzaSizeNotifier = ValueNotifier<double>(0);
  ValueNotifier<double>? pizzaIngredientNotifier = ValueNotifier(0.0);
  late PageController pageController;
  late PageController ingredientPageController;

  late AnimationController sliderAnimationController;
  late AnimationController pizzaAnimationController;
  late AnimationController ingredientAnimationController;
  late AnimationController addPizzaAnimationController;
  late Animation continueAnimation;
  late Animation repeatAnimation;

  int currentPizzaSize = 0;
  double pizzaScaleValue = .8;

  int pizzaCurrentSizeIndex = 0;
  double sliderPosition = 0.0;

  List<Widget> ingredientsOnPizza = [];
  List<Animation> animations = [];

  String getIngredientName(String img) {
    return img.split("/")[1].split(".").first;
  }

  String ingredientName = "";

  listener() {
    pizzaSizeNotifier.value = pageController.page!;
  }

  late Size size;

  ingredientListener() {
    pizzaIngredientNotifier!.value = ingredientPageController.page!;
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController(
      viewportFraction: .2,
    );
    ingredientPageController = PageController(
      viewportFraction: .142,
    );
    addPizzaAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    continueAnimation = CurvedAnimation(
      parent: addPizzaAnimationController,
      curve: Interval(0.0, .4, curve: Curves.decelerate),
    );
    repeatAnimation = CurvedAnimation(
      parent: addPizzaAnimationController,
      curve: Interval(0.7, 1.0, curve: Curves.decelerate),
    );
    ingredientAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    sliderAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    pizzaAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    ingredientName = getIngredientName(ingredients.first.img);
    pageController.addListener(listener);
    ingredientPageController.addListener(ingredientListener);
  }

  CurvedAnimation curvedAnimation(double start, double end) => CurvedAnimation(
      parent: ingredientAnimationController,
      curve: Interval(start, end, curve: Curves.easeInOut));
  _buildAnimation() {
    animations.clear();
    animations = [
      curvedAnimation(0.1, .9),
      curvedAnimation(0.2, .75),
      curvedAnimation(0.1, .85),
      curvedAnimation(0.16, .8),
      curvedAnimation(0.2, .9),
      curvedAnimation(0.35, .76),
      curvedAnimation(0.28, .89),
      curvedAnimation(0.3, .95),
      curvedAnimation(0.12, .7),
      curvedAnimation(0.13, .6),
      curvedAnimation(0.25, .93),
      curvedAnimation(0.3, .78),
    ];
  }

  List<Map<String, dynamic>> ings = [];
  ValueNotifier<List<Widget>> ingredientsInPizza =
      ValueNotifier<List<Widget>>([]);

  List<Widget> lists = [];
  Widget addIngredient() {
    List<Widget> elements = [];
    if (ings.isNotEmpty) {
      final ing = ings.first;
      if (animations.isNotEmpty) {
        for (var i = 0; i < animations.length; ++i) {
          final anim = animations[i];
          double animValue = anim.value;
          final xStart = ing["xStart"][i];
          final xEnd = ing["xEnd"][i];
          final yStart = ing["yStart"][i];
          final yEnd = ing["yEnd"][i];

          elements.add(Transform.translate(
            offset: Offset(lerpDouble(xStart, xEnd, animValue)!,
                lerpDouble(yStart, yEnd, animValue)!),
            child: Center(
              child: Image.asset(
                ing["img"],
                height:
                    lerpDouble(size.height * .5, size.height * .038, animValue),
              ),
            ),
          ));

          // } else {
          //   elements.add(
          //     Transform.translate(
          //       offset: Offset(xEnd, yEnd),
          //       child: Center(
          //         child: Image.asset(
          //           ing["img"],
          //           height: size.height * .038,
          //         ),
          //       ),
          //     ),
          //   );
          // }
        }
        return Stack(
          children: elements,
        );
      }
    }
    return SizedBox.shrink();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
    ingredientAnimationController.dispose();
    sliderAnimationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    double sliderSizeContainer = size.width * .68;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          PizzaListSize(
            size: size,
            roundedContainerSize: roundedContainerSize,
            pizzaSizeNotifier: pizzaSizeNotifier,
            pageController: pageController,
            onTap: (index, pizzaSize) {
              setState(() {
                pizzaCurrentSizeIndex = index;
                if (pizzaSize == pizzaSizes[0]) {
                  pizzaScaleValue = .8;
                }
                if (pizzaSize == pizzaSizes[1]) {
                  pizzaScaleValue = .9;
                }
                if (pizzaSize == pizzaSizes[2]) {
                  pizzaScaleValue = 1.0;
                }
              });
            },
            pizzaCurrentSizeIndex: pizzaCurrentSizeIndex,
          ),

          //  Ingredients -------------------------------
          PizzaListIngredient(
            size: size,
            roundedContainerSize: roundedContainerSize,
            pizzaIngredientNotifier: pizzaIngredientNotifier!,
            ingredientPageController: ingredientPageController,
            onPageChanged: (index) {
              ingredientName = getIngredientName(ingredients[index].img);
            },
          ),

          // pizza slider --------------------------------
          Positioned(
            top: size.height * .83,
            left: size.width / 2 - (sliderSizeContainer / 2),
            right: size.width / 2 - (sliderSizeContainer / 2),
            child: Container(
              height: size.height * .17,
              // color: Colors.amber,
              width: size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    height: 30,
                    child: AnimatedBuilder(
                        animation: sliderAnimationController,
                        builder: (context, _) {
                          final sliderAnimation = Curves.easeInOut
                              .transform(sliderAnimationController.value);
                          return Stack(
                            children: [
                              PizzaSlider(
                                width: sliderSizeContainer,
                                color: Colors.grey.shade200,
                              ),
                              Positioned(
                                left: 0,
                                top: 0,
                                bottom: 0,
                                child: PizzaSlider(
                                  width: lerpDouble(sliderPosition + 10, 10.0,
                                      sliderAnimation)!,
                                  color: Colors.red,
                                ),
                              ),
                              Positioned(
                                top: 0,
                                bottom: 0,
                                left: lerpDouble(
                                    sliderPosition, 0.0, sliderAnimation),
                                child: GestureDetector(
                                  onHorizontalDragUpdate: (details) {
                                    final position = details.localPosition.dx;
                                    final sliderWidthSize =
                                        sliderSizeContainer - 30;
                                    if (position < sliderWidthSize &&
                                        position > 0.0) {
                                      sliderPosition = position;
                                    }
                                    setState(() {});
                                  },
                                  onHorizontalDragEnd: (details) {
                                    sliderAnimationController.forward();
                                    sliderAnimationController
                                        .addStatusListener((status) {
                                      if (status == AnimationStatus.completed) {
                                        sliderAnimationController.value = 0;
                                        sliderPosition = 0.0;
                                        ings = epices(ingredientName, size)
                                            .where((element) =>
                                                element["img"] ==
                                                "asset/$ingredientName-1.png")
                                            .toList();
                                        _buildAnimation();
                                        ingredientAnimationController.forward(
                                            from: 0);
                                      }
                                    });
                                  },
                                  child: Image.asset(
                                    "asset/slider.png",
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                  ),
                  Expanded(
                    child: AnimatedBuilder(
                        animation: addPizzaAnimationController,
                        builder: (context, _) {
                          final continueValue = continueAnimation.value;
                          final repeatValue = repeatAnimation.value;

                          return Stack(
                            fit: StackFit.expand,
                            children: [
                              Positioned(
                                right: 4,
                                bottom: (size.height * .17) / 2 - 50 / 2,
                                child: InkWell(
                                    onTap: () {},
                                    child: Opacity(
                                      opacity: repeatAnimation.value,
                                      child: Text(
                                        "Repeat ?",
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )),
                              ),
                              Center(
                                child: InkWell(
                                  onTap: () {
                                    final value =
                                        addPizzaAnimationController.value;
                                    if (value == 0) {
                                      addPizzaAnimationController.forward();
                                    } else {
                                      addPizzaAnimationController.reverse();
                                    }
                                  },
                                  child: Container(
                                    height: 50,
                                    width: lerpDouble(50, 120, continueValue),
                                    margin: EdgeInsets.only(
                                        right: lerpDouble(
                                            0,
                                            size.width / 2 - (120 / 2),
                                            repeatValue)!),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: Stack(
                                      children: [
                                        Center(
                                          child: Offstage(
                                            offstage: false,
                                            child: Transform.scale(
                                              scale: lerpDouble(
                                                  0, 1, continueValue),
                                              child: Text(
                                                "Continue",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: Offstage(
                                            offstage: continueValue > 0.7
                                                ? true
                                                : false,
                                            child: Transform.rotate(
                                              angle: pi * continueValue,
                                              child: Transform.scale(
                                                scale: lerpDouble(
                                                    1, 0, continueValue),
                                                child: Icon(
                                                  Icons.add,
                                                  color: Colors.white,
                                                  size: 30,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                  ),
                ],
              ),
            ),
          ),

// App Bar ----------------------------------------------------------------
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: Colors.white,
              elevation: 1,
              centerTitle: true,
              title: const Text(
                "Pepperoni Pizza",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              leading: BackButton(
                color: Colors.black,
              ),
              actions: [
                Center(
                  child: Container(
                    // color: Colors.amber,
                    width: 40,
                    height: size.height,
                    child: AnimatedBuilder(
                        animation: addPizzaAnimationController,
                        builder: (context, _) {
                          final value = Curves.decelerate
                              .transform(addPizzaAnimationController.value);
                          return Stack(
                            children: [
                              Center(
                                child: Image.asset(
                                  "asset/cart.png",
                                  height: 25,
                                  width: 25,
                                ),
                              ),
                              Positioned(
                                right:
                                    lerpDouble(5, 0, continueAnimation.value),
                                top: 25 / 2,
                                child: CircleAvatar(
                                  maxRadius: lerpDouble(
                                      lerpDouble(
                                          0, 11, continueAnimation.value),
                                      7,
                                      repeatAnimation.value),
                                  backgroundColor: Colors.red,
                                  child: FittedBox(
                                    child: Text(
                                      "1",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
              ],
            ),
          ),

          //  Pizza ----------------------------------------------------------------
          Positioned(
              top: size.height * .12,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                  animation: addPizzaAnimationController,
                  builder: (context, _) {
                    final value = Curves.fastOutSlowIn
                        .transform(addPizzaAnimationController.value);
                    return Transform.translate(
                      offset: Offset(lerpDouble(0, pi * 48, value)!,
                          lerpDouble(0, -size.height * .25, value)!),
                      child: Transform.rotate(
                        angle: (pi / 2) * value,
                        child: Transform.scale(
                          scale: lerpDouble(1, .1, value),
                          child: Opacity(
                            opacity: lerpDouble(1, 0, value)!,
                            child: AnimatedRotation(
                              duration: const Duration(milliseconds: 300),
                              turns: pi * pizzaScaleValue,
                              child: AnimatedScale(
                                duration: const Duration(milliseconds: 300),
                                scale: pizzaScaleValue,
                                child: Image.asset(
                                  "asset/pizza-1.png",
                                  height: size.height * .44,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  })),

// ----------------------------------------------------------------
          AnimatedBuilder(
              animation: addPizzaAnimationController,
              builder: (context, _) {
                final continueValue = Curves.fastOutSlowIn
                    .transform(addPizzaAnimationController.value);

                return Transform.translate(
                  offset: Offset(lerpDouble(0, pi * 45, continueValue)!,
                      lerpDouble(0, -size.height * .40, continueValue)!),
                  child: Transform.scale(
                    scale: lerpDouble(1, 0, continueValue),
                    child: Opacity(
                      opacity: lerpDouble(1, 0, continueValue)!,
                      child: AnimatedBuilder(
                        animation: ingredientAnimationController,
                        builder: (ctx, _) {
                          // TODO: noublie pas de decommenter
                          if (continueValue > .8) {
                            ings.clear();
                            ingredientAnimationController.value = 0;
                          }

                          return addIngredient();

                          // Transform.translate(
                          //   offset: Offset(
                          //       lerpDouble(
                          //           size.height * .3, size.height * .04, animValue)!,
                          //       lerpDouble(
                          //           -size.height * .9, -size.height * .25, animValue)!),
                          //   child: Center(
                          //     child: Image.asset(
                          //       "asset/piment-1.png",
                          //       height: lerpDouble(
                          //           size.height * .5, size.height * .04, animValue),
                          //     ),
                          //   ),
                          // ),
                        },
                      ),
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }
}

class CustomClipPath extends CustomPainter {
  Color backgroundColor;
  double? sweepAngle;
  double? startAngle;
  CustomClipPath({
    required this.backgroundColor,
    this.sweepAngle,
    this.startAngle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = backgroundColor;
    paint.strokeWidth = 10;
    paint.style = PaintingStyle.stroke;
    paint.strokeCap = StrokeCap.round;

    final path = Path();
    startAngle = -pi + .3;
    sweepAngle = sweepAngle != null ? sweepAngle! : pi - .6;
    canvas.drawArc(
        Rect.fromLTRB(0, 0, 220, 150), startAngle!, sweepAngle!, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class MyArc extends CustomPainter {
  Size size;
  MyArc({required this.size});
  @override
  void paint(Canvas canvas, _) {
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3;

    final path = Path();
    path.moveTo(size.width * .1, 0);
    path.arcToPoint(
      Offset(size.width * .3, 0),
      radius: Radius.circular(210),
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
