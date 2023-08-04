import 'package:apptempcontrolesp32/src/shared/themes/color_schemes.g.dart';
import 'package:flutter/material.dart';
import 'package:apptempcontrolesp32/blue_controler.dart';

import 'all_Widget.dart';
import 'aws_Controler.dart';
import 'p2_Widget.dart';

class PageMenu extends StatefulWidget {
  const PageMenu({super.key});

  @override
  State<PageMenu> createState() => _PageMenu();
}

class _PageMenu extends State<PageMenu> {
  /*List alarmeGraus = [];
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
  }*/

  void saveSendWifi() {
    if (isConnectBlueDevice()) {
      mandaMensagem("WR, ${redeWifi.text.codeUnits}");
      mandaMensagem("WS, ${passWifi.text.codeUnits}");
      setState(() {
        redeWifi.text = "";
        passWifi.text = "";
      });
    } else {
      showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                alignment: AlignmentDirectional.center,
                title: const Text('Conexão bluetooth',
                    style: TextStyle(color: Colors.amber)),
                content: const Text(
                    'Necessário estar conectado com a churrasqueira pelo bluetooth',
                    style: TextStyle(color: Colors.amber)),
              ));
    }
  }

  bool hiddenPass = true;
  final redeWifi = TextEditingController();
  final passWifi = TextEditingController();

  bool openWifi = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // Menu superior
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            }, //TODO Perfil icon superior esquedo
            icon: const Icon(
              Icons.arrow_back,
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
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    openWifi = !openWifi;
                  });
                },
                child: Container(
                  height: 40,
                  color: darkColorScheme.background,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Configurar Wi-Fi",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      openWifi == true
                          ? Transform.rotate(
                              angle: -80,
                              child: const Icon(
                                Icons.arrow_forward_ios,
                              ))
                          : const Icon(
                              Icons.arrow_forward_ios,
                            ),
                    ],
                  ),
                ),
              ),
              openWifi == true
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 10),
                      child: Column(
                        children: [
                          SizedBox(height: 10),
                          TextFormField(
                              controller: redeWifi,
                              keyboardType: TextInputType.text,
                              autocorrect: false,
                              decoration: const InputDecoration(
                                labelText: "Nome do Wi-Fi",
                              )),
                          Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              TextFormField(
                                  controller: passWifi,
                                  keyboardType: TextInputType.text,
                                  autocorrect: false,
                                  obscureText: hiddenPass,
                                  decoration: const InputDecoration(
                                    labelText: "Senha do Wi-Fi",
                                  )),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      hiddenPass = !hiddenPass;
                                    });
                                  },
                                  icon: hiddenPass == true
                                      ? Icon(Icons.remove_red_eye)
                                      : Icon(Icons.remove_red_eye_outlined))
                            ],
                          ),
                          SizedBox(height: 15),
                          TextButton(
                            onPressed: saveSendWifi,
                            child:
                                Text("Salvar", style: TextStyle(fontSize: 18)),
                          ),
                        ],
                      ),
                    )
                  : SizedBox(
                      height: 5,
                    ),
            ],
          ),
        ));
  }
}



/*


Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 30),
            child: ListView(
              children: [
                TextFormField(
                    controller: redeWifi,
                    keyboardType: TextInputType.text,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      labelText: "Nome do Wi-Fi",
                    )),
                Stack(
                  alignment: AlignmentDirectional.bottomEnd,
                  children: [
                    TextFormField(
                        controller: passWifi,
                        keyboardType: TextInputType.text,
                        autocorrect: false,
                        obscureText: hiddenPass,
                        decoration: const InputDecoration(
                          labelText: "Senha do Wi-Fi",
                        )),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            hiddenPass = !hiddenPass;
                          });
                        },
                        icon: hiddenPass == true
                            ? Icon(Icons.remove_red_eye)
                            : Icon(Icons.remove_red_eye_outlined))
                  ],
                ),
                SizedBox(height: 15),
                TextButton(
                  onPressed: saveSendWifi,
                  child: Text("Salvar", style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          )),


*/