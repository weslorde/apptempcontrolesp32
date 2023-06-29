import 'package:flutter/material.dart';
import 'package:apptempcontrolesp32/src/shared/themes/color_schemes.g.dart';

class AlarmCreatButtons extends StatefulWidget {
  const AlarmCreatButtons({super.key, required this.opentransactionFormModal});

  final void Function() opentransactionFormModal;
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
            onPressed: widget.opentransactionFormModal,
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
            onPressed: () {},
            child: const Text(
              "Timer",
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

    void changeHeigth(double value){
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
                keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                decoration:
                    InputDecoration(labelText: "Valor da temperatura alvo"),
                onSubmitted: (value) {widget.onSubmit(int.parse(targetValueController.text));},
              ),
              TextButton(onPressed: () {widget.onSubmit(int.parse(targetValueController.text));}, child: Text("Salvar"))
            ],
          ),
        ),
      ),
    );
  }
}
