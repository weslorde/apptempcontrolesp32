import 'package:flutter/material.dart';
import 'package:apptempcontrolesp32/blue_controler.dart';

class Page2 extends StatefulWidget {
  const Page2({super.key});

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  var test = getTemps();
  
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
    );
  }
}
