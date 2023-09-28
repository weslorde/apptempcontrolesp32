import 'package:flutter/material.dart';

import '../blue_controler.dart';
import 'aws_Controler.dart';
import 'pageMenu.dart';

class Page3 extends StatefulWidget {
  const Page3({super.key});

  @override
  State<Page3> createState() => _Page3State();
}

class _Page3State extends State<Page3> {
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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Listener(
                onPointerDown: (PointerEvent ignore) {
                  if (isConnectBlueDevice()) {
                    mandaMensagem("Motor,Up,Press");
                  } else {
                    awsMotor("Motor,Up,Press");
                  }
                },
                onPointerUp: (PointerEvent ignore) {
                  if (isConnectBlueDevice()) {
                    mandaMensagem("Motor,Up,Release");
                  } else {
                    awsMotor("Motor,Up,Release");
                  }
                },
                child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.upload,
                      size: 150,
                    )),
              ),
              SizedBox(height: 50),
              Listener(
                onPointerDown: (PointerEvent ignore) {
                  if (isConnectBlueDevice()) {
                    mandaMensagem("Motor,Down,Press");
                  } else {
                    awsMotor("Motor,Down,Press");
                  }
                },
                onPointerUp: (PointerEvent ignore) {
                  if (isConnectBlueDevice()) {
                    mandaMensagem("Motor,Down,Release");
                  } else {
                    awsMotor("Motor,Down,Release");
                  }
                },
                child: IconButton(
                    onPressed: () {},
                    icon: const RotatedBox(
                      quarterTurns: 90,
                      child: Icon(
                        Icons.upload,
                        size: 150,
                      ),
                    )),
              ),
            ],
          ),
        ));
  }
}
