import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import '../../lib2/src/shared/themes/color_schemes.g.dart';
import 'package:numberpicker/numberpicker.dart';

class AlarmCreatButtons extends StatefulWidget {
  const AlarmCreatButtons(
      {super.key,
      required this.openTemAlvoFormModal,
      required this.openAlarmsFormModal});

  final void Function() openTemAlvoFormModal;
  final void Function() openAlarmsFormModal;
  @override
  State<AlarmCreatButtons> createState() => _AlarmCreatButtonsState();
}

class _AlarmCreatButtonsState extends State<AlarmCreatButtons> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: widget.openTemAlvoFormModal,
            child: Text(
              "Temperatura Alvo",
              style: TextStyle(
                  color: darkColorScheme.background,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: ElevatedButton(
            onPressed: widget.openAlarmsFormModal,
            child: const Text(
              "Criar Alarme",
              style: TextStyle(
                  //color: darkColorScheme.background,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}

class targetTempForm extends StatefulWidget {
  const targetTempForm({super.key, required this.onSubmit});

  final void Function(int) onSubmit;

  @override
  State<targetTempForm> createState() => _targetTempFormState();
}

class _targetTempFormState extends State<targetTempForm> {
  final targetValueController = TextEditingController();
  double myHeight = 200;

  void changeHeigth(double value) {
    setState(() {
      myHeight = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        height: myHeight,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 10),
          child: Column(
            children: [
              TextField(
                onTap: () {
                  changeHeigth(500);
                },
                controller: targetValueController,
                keyboardType: TextInputType.numberWithOptions(
                    signed: true, decimal: true),
                decoration:
                    InputDecoration(labelText: "Valor da temperatura alvo"),
                onSubmitted: (value) {
                  widget.onSubmit(int.parse(targetValueController.text));
                },
              ),
              TextButton(
                  onPressed: () {
                    widget.onSubmit(int.parse(targetValueController.text));
                  },
                  child: Text("Salvar"))
            ],
          ),
        ),
      ),
    );
  }
}

class alarmForm extends StatefulWidget {
  const alarmForm(
      {super.key, required this.onTempoSubmit, required this.onGrausSubmit});

  final void Function(Duration) onTempoSubmit;
  final void Function(String, int) onGrausSubmit;

  @override
  State<alarmForm> createState() => _alarmFormState();
}

class _alarmFormState extends State<alarmForm> {
  final targetValueController = TextEditingController();
  double myHeight = 200;
  String alarm = "none";

  void changeHeigth(double value) {
    setState(() {
      myHeight = value;
    });
  }

  void selectAlarm(String name) {
    setState(() {
      alarm = name;
    });
  }

  Duration _duration = const Duration(hours: 0, minutes: 0);
  List<bool> _sensorSelect = [false, false, false];
  List<String> _sensorNames = ["Grelha", "Sensor1", "Sensor2"];
  String _sensorTemp = "";
  int _temperaturaValue = 100;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        height: myHeight,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              SizedBox(height: 10),
              Text(
                "Tipo de alarme",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          changeHeigth(800);
                          selectAlarm("Temperatura");
                        },
                        child: Text(
                          "Temperatura",
                          style: TextStyle(
                              color: darkColorScheme.background,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          changeHeigth(500);
                          selectAlarm("Tempo");
                        },
                        child: const Text(
                          "Tempo",
                          style: TextStyle(
                              //color: darkColorScheme.background,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (alarm == "Tempo")
                Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      DurationPicker(
                        onChange: (val) {
                          _duration = val;
                          setState(() {});
                        },
                        duration: _duration,
                      ),
                      TextButton(
                          onPressed: () {
                            widget.onTempoSubmit(_duration);
                          },
                          child: const Text(
                            "Salvar",
                            style: TextStyle(fontSize: 20),
                          ))
                    ],
                  ),
                )
              else if (alarm == "Temperatura")
                Column(
                  children: [
                    const SizedBox(height: 20),
                    ToggleButtons(
                      isSelected: _sensorSelect,
                      onPressed: (index) {
                        setState(() {
                          _sensorSelect = [false, false, false];
                          _sensorSelect[index] = true;
                        });
                      },
                      textStyle: const TextStyle(fontSize: 20),
                      borderRadius: const BorderRadius.all(Radius.circular(25.0)),
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Text("Grelha"),
                        ),
                        Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Text("Sensor1"),
                        ),
                        Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Text("Sensor2"),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    NumberPicker(
                      value: _temperaturaValue,
                      minValue: 20,
                      maxValue: 400,
                      step: 5,
                      onChanged: (value) =>
                          setState(() => _temperaturaValue = value),
                    ),
                    TextButton(
                      onPressed: () {
                        for (int i = 0; i < _sensorSelect.length; i++) {
                          if (_sensorSelect[i]) {
                            _sensorTemp = _sensorNames[i];
                          }
                        }
                        widget.onGrausSubmit(_sensorTemp, _temperaturaValue);
                      },
                      child: const Text(
                        "Salvar",
                        style: TextStyle(fontSize: 20),
                      ),
                    )
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}


class tAlvoForm extends StatefulWidget {
  const tAlvoForm(
      {super.key, required this.onTAlvoSubmit});

  final void Function(int) onTAlvoSubmit;

  @override
  State<tAlvoForm> createState() => _tAlvoFormState();
}

class _tAlvoFormState extends State<tAlvoForm> {
  final targetValueController = TextEditingController();
  double myHeight = 350;
  String alarm = "none";

  void changeHeigth(double value) {
    setState(() {
      myHeight = value;
    });
  }

  int _temperaturaValue = 100;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        height: myHeight,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              SizedBox(height: 10),
              Text(
                "Definir temperatura alvo",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 10),
                Column(
                  children: [
                    const SizedBox(height: 20),
                    NumberPicker(
                      value: _temperaturaValue,
                      minValue: 20,
                      maxValue: 400,
                      step: 5,
                      onChanged: (value) =>
                          setState(() => _temperaturaValue = value),
                    ),
                    TextButton(
                      onPressed: () {
                        widget.onTAlvoSubmit(_temperaturaValue);
                      },
                      child: const Text(
                        "Salvar",
                        style: TextStyle(fontSize: 20),
                      ),
                    )
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
