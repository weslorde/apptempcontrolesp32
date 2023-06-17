import 'dart:async';

import 'package:apptempcontrolesp32/blue_controler.dart';
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

  int temp = 300;
  int tempSensor1 = 200;
  int tempSensor2 = 200;
  int target = 200;
  late int totalSteps;
  late double stepsToPi;
  late int currentStep;
  late int targetStep;
  bool BlueState = true;
  bool LocatState = true;
  var periodTimer;
  bool inConectBlue = false;
  late Timer rotine2Seg;

  @override
  void initState() {
    print("INIT pag1");
    blueCheck();
    attTemperatures();
    periodTimer = const Duration(seconds: 2);
    rotine2Seg = Timer.periodic(periodTimer, (arg) {
      blueCheck();
      attTemperatures();
    });

    attCalculaValores();
    blueCheck();
    super.initState();
  }

  @override
  void dispose() {
    rotine2Seg.cancel();
    super.dispose();
  }

  void attCalculaValores() {
    totalSteps = 50;
    stepsToPi = (2 * math.pi - 2 * math.pi / 6) /
        totalSteps; // (Total size - unused size) / number of Steps = Size of each steps
    currentStep = ((temp - 0) * (totalSteps - 0) / (300 - 0) + (0))
        .toInt(); // ValNovaEscala = ((ValEscalaVelha - MinVelho) * (MaxNovo - (MinNovo)) / (MaxVelho - MinVelho) + (MinNovo))
    targetStep = ((target - 0) * (totalSteps - 0) / (300 - 0) + (0)).toInt();
  }

  void attTemperatures() {
    if (isConnectBlueDevice() & reciverBluOk()) {
      mandaMensagem("Ping");
    }
    setState(() {
      List listTemps = getTemps();
      temp = int.parse(listTemps[0]);
      tempSensor1 = int.parse(listTemps[1]);
      tempSensor2 = int.parse(listTemps[2]);
      target = int.parse(listTemps[3]);
      attCalculaValores();
    });
  }

  void blueCheck() async {
    print("teste");
    var _ListLogic = await status();
    try {
      setState(() {
        BlueState = _ListLogic[0];
        LocatState = _ListLogic[1];
      });
      if (!isConnectBlueDevice()) {
        if (BlueState & LocatState & !inConectBlue) {
          inConectBlue = true;
          blueScan(inConBlueChange);
        }
      }
    } on Exception {
      print("opa");
    }
  }

  void inConBlueChange(bool state) {
    setState(() {
      inConectBlue = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menu superior
      appBar: AppBar(
        leading: IconButton(
          onPressed: ()  { }, //TODO Perfil icon superior esquedo
          icon: const Icon(
            Icons.account_circle_rounded,
            size: 30,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {}, //TODO Menu icon superior direito
            icon: const Icon(
              Icons.menu,
              size: 30,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Stack(
              children: [
                //Bluetooth and Location ICON
                !(BlueState & LocatState)
                    ? Container(
                        alignment: Alignment.topRight,
                        child: Container(
                          decoration: BoxDecoration(
                              color: darkColorScheme.primary,
                              border: Border.all(),
                              borderRadius: const BorderRadius.horizontal(
                                  left: Radius.circular(20))),
                          child: IconButton(
                            onPressed: () => {infoBlue()},
                            icon: Icon(
                              BlueState == false
                                  ? Icons.bluetooth_disabled
                                  : Icons.gps_off,
                              color: darkColorScheme.background,
                              size: 35,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
                //Complet Body of page
                Padding(
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
                                            padding:
                                                EdgeInsets.only(bottom: 15),
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
                                          " $targetº",
                                          style: const TextStyle(
                                              fontSize: 22,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
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

                        // Horizontal Bar with name and temp
                        LineTemperatureProgress(
                          temp: tempSensor1,
                          name: "Sensor 1",
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        LineTemperatureProgress(
                          temp: tempSensor2,
                          name: "Sensor 2",
                        ),
                        const SizedBox(
                          height: 30,
                        ),

                        //Botoes abaixo Temp e Timer
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
              ],
            ),
          ),

          // Load blue efect
          if (inConectBlue)
            const Opacity(
              opacity: 0.8,
              child: ModalBarrier(dismissible: false, color: Colors.black),
            ),
          if (inConectBlue)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Conectando",
                    style: TextStyle(color: darkColorScheme.primary),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
