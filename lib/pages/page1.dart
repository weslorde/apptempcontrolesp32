import 'package:apptempcontrolesp32/src/shared/themes/color_schemes.g.dart';
import 'package:flutter/material.dart';

import 'dart:math' as math;
import 'package:step_progress_indicator/step_progress_indicator.dart';

import 'p1_Widget.dart';

class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  Color ColorCircularProgress(int t) {
    if (currentStep > t) {
      return (Color.lerp(Colors.amber, Colors.red, t.toDouble() / totalSteps)!);
    } else {
      return (Color.lerp(Colors.amber.withAlpha(70), Colors.red.withAlpha(70),
          t.toDouble() / totalSteps)!);
    }
  }

  int temp = 200;
  int target = 200;
  late int totalSteps;
  late double stepsToPi;
  late int currentStep;
  late int targetStep;

  @override
  void initState() {
    //const int totalSteps = 50;  //Number of Steps of the circular indicator
    totalSteps = 50;
    stepsToPi = (2 * math.pi - 2 * math.pi / 6) /
        totalSteps; // (Total size - unused size) / number of Steps = Size of each steps
    currentStep = ((temp - 20) * (totalSteps - 0) / (300 - 20) + (0))
        .toInt(); // ValNovaEscala = ((ValEscalaVelha - MinVelho) * (MaxNovo - (MinNovo)) / (MaxVelho - MinVelho) + (MinNovo))
    targetStep = ((target - 20) * (totalSteps - 0) / (300 - 20) + (0)).toInt();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.account_circle_rounded,
            size: 30,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.menu,
              size: 30,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              // Circular Principal Temperature progress Circle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      CircularStepProgressIndicator(
                        totalSteps: totalSteps,
                        currentStep: currentStep,
                        stepSize: 25,
                        customColor: ColorCircularProgress,
                        selectedColor: Colors.red,
                        unselectedColor: Colors.amber,
                        padding: math.pi / 200,
                        width: 250,
                        height: 250,
                        startingAngle: 5 * math.pi / 6,
                        arcSize: 2 * math.pi - 2 * math.pi / 6,
                      ),
                      Transform.rotate(
                        angle: math.pi / 6 + targetStep * stepsToPi,
                        child: Image.asset(
                          "lib/assets/images/TargetCircular.png",
                          color: Colors.white,
                          height: 220,
                        ),
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Row(
                              children: [
                                Text(
                                  "$temp",
                                  style: const TextStyle(
                                      fontSize: 55,
                                      fontWeight: FontWeight.bold),
                                ),
                                //Padding + Text to make the º graus symbol
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 15),
                                  child: Text(
                                    "º",
                                    style: TextStyle(
                                        fontSize: 35,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Image.asset(
                                "lib/assets/images/TargetIcon.png",
                                color: Colors.white,
                                height: 25,
                              ),
                              Text(
                                " $target",
                                style: const TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),

              // Divisor Bar with padding
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Divider(
                  thickness: 1,
                  color: Colors.grey,
                ),
              ),

              LineTemperatureProgress(temp: 100, name: "Sensor 1",),
              const SizedBox(
                height: 30,
              ),
              LineTemperatureProgress(temp: 200, name: "Sensor 2",),
              const SizedBox(
                height: 30,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        "Temperatura",
                        style: TextStyle(
                            color: darkColorScheme.background,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        "Timer",
                        style: TextStyle(
                            //color: darkColorScheme.background,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
