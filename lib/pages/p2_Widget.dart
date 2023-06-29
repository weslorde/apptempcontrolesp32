import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:apptempcontrolesp32/src/shared/themes/color_schemes.g.dart';

class ListAlarm extends StatefulWidget {
  //const ListAlarm({super.key, this.temp = 0, required this.name});
  const ListAlarm({super.key, required this.name, required this.tipo, required this.indice, required this.apagaAlarm});

  //final int temp;
  final name;
  final String tipo;
  final int indice;
  final void Function(String,int) apagaAlarm;

  @override
  State<ListAlarm> createState() =>
      _ListAlarmState();
}

class _ListAlarmState extends State<ListAlarm> {
  int totalSteps = 310;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Card(
                  child: Container(
                    height: 70,
                    child: Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            leading: Icon(widget.tipo == "timer" ? Icons.timer_sharp : Icons.fireplace_outlined, color: darkColorScheme.primary,),
                            title: widget.tipo == "timer" ?  Text("Timer em ${widget.name[0]}h ${widget.name[1]}m")
                            : Text("${widget.name[0]} em ${widget.name[1]}º"),
                            /*: widget.name[0] == "Grelha" ? Text("Temperatura da ${widget.name[0]} em ${widget.name[1]}º")
                            : Text("Temperatura do ${widget.name[0]} em ${widget.name[1]}º"),*/

    
                          ),
                        ),
                        IconButton(
                          onPressed: () {widget.apagaAlarm(widget.tipo, widget.indice);},
                          icon: Icon(Icons.delete_forever, color: Colors.red.shade900,),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
