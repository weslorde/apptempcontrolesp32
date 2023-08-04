import 'package:apptempcontrolesp32/pages/pageMenu.dart';
import 'package:apptempcontrolesp32/src/shared/themes/color_schemes.g.dart';
import 'package:flutter/material.dart';
import 'package:apptempcontrolesp32/blue_controler.dart';

import 'all_Widget.dart';
import 'aws_Controler.dart';
import 'p2_Widget.dart';

class Page2 extends StatefulWidget {
  const Page2({super.key});

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  List alarmeGraus = [];
  List alarmeTimer = [];

  void reciveAlarmBluetoPag2(list) {
    setState(() {
      alarmeGraus = list[0];
      alarmeTimer = list[1];
      print("chegou");
      print(alarmeTimer);
      print(alarmeGraus);
    });
  }

  @override
  void initState() {
    if (isConnectBlueDevice()) {
      mandaMensagem("Alarme");
    } else {
      awsMsg("\$aws/things/ChurrasTech2406/shadow/name/AlarmShadow/update",
          '{"state":{"desired": {"Enviar": "1"}}}');
    }
    recivePage2Att(reciveAlarmBluetoPag2);
    awsRecivePage2Att(reciveAlarmBluetoPag2);
  }

  void _openAlarmsFormModal() {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return alarmForm(
            onTempoSubmit: onAlarmsTempoFormSubmit,
            onGrausSubmit: onAlarmsGrausFormSubmit,
          );
        });
  }

  void onAlarmsTempoFormSubmit(Duration value) {
    mandaMensagem("TimerAlarme,${value.inHours},${value.inMinutes}");
    Navigator.of(context).pop();
    initState();
  }

  void onAlarmsGrausFormSubmit(String sensor, int value) {
    mandaMensagem("GrausAlarme,$sensor,$value");
    print("$sensor, $value");
    Navigator.of(context).pop();
    initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menu superior
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {}, //TODO Perfil icon superior esquedo
          icon: const Icon(
            Icons.account_circle_rounded,
            size: 30,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PageMenu()),
              );
            }, //TODO Menu icon superior direito
            icon: const Icon(
              Icons.menu,
              size: 30,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween, //Deixa sempre a lista la em baixo
          children: [
            Flexible(
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      for (var x = 0; x < alarmeTimer.length; x++)
                        alarmeTimer[x] != 0
                            ? ListAlarm(
                                name: alarmeTimer[x],
                                tipo: "timer",
                                indice: x,
                                apagaAlarm: apagaAlarm)
                            : const SizedBox(),
                      for (var x = 0; x < alarmeGraus.length; x++)
                        alarmeGraus[x] != 0
                            ? ListAlarm(
                                name: alarmeGraus[x],
                                tipo: "graus",
                                indice: x,
                                apagaAlarm: apagaAlarm)
                            : const SizedBox(),
                    ],
                  ),
                ),
              ),
            ),
            //const SizedBox(height: 15),
            //const AlarmCreatButtons()
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 20),
              child: FloatingActionButton(
                onPressed: _openAlarmsFormModal,
                child: const Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
