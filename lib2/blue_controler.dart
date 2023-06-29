import 'dart:convert';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:location/location.dart';

var location = Location();
bool? blueState;
BluetoothDevice? conectedDevice;
BluetoothCharacteristic? BlueCharacteristicToRecive;
BluetoothCharacteristic? BlueCharacteristicToSend;
String serviceUuid = "6e400001-b5a3-f393-e0a9-e50e24dcca9e";
String characterMandarUuid = "6e400002-b5a3-f393-e0a9-e50e24dcca9e";
String characterReceberUuid = "6e400003-b5a3-f393-e0a9-e50e24dcca9e";
bool isConectingBlue = false;
List ListTemp = ["000","000","000","000"];
bool notiflyOk = false;



Future<List<bool>> status() async {
  return [await FlutterBluePlus.instance.isOn, await location.serviceEnabled()];
}

bool isConnectBlueDevice() {
  if (conectedDevice?.name == "ChurrasTech") {return true;}
  else {return false;}
}

infoBlue() async {
  await FlutterBluePlus.instance.isOn.then(
    (value) async {
      if (!value) {
        await FlutterBluePlus.instance.turnOn();
      }
    },
  );

  if (await FlutterBluePlus.instance.isOn) {
    await location.serviceEnabled().then(
      (value) {
        if (!value) {
          location.requestService();
        }
      },
    );
  }
  //TODO - Caso Device já conectado
  /*
  conectedDevice = scanResult2[1];
  final List<BluetoothService>? services =
          await conectedDevice?.discoverServices();
  for (var x = 0; x < services!.length; x++) {
    print(services[x].uuid);
    if (services[x].uuid.toString().toLowerCase() ==
        serviceUuid.toLowerCase()) {
      final lsOfChar = services[x].characteristics;
      for (var y = 0; y < lsOfChar.length; y++) {
        if (lsOfChar[y].uuid.toString().toLowerCase() ==
            characterReceberUuid.toLowerCase()) {
          BlueCharacteristicToRecive = lsOfChar[y];
          print("foiiiiiiiiiiii");
        }
        ;
        if (lsOfChar[y].uuid.toString().toLowerCase() ==
            characterMandarUuid.toLowerCase()) {
          BlueCharacteristicToSend = lsOfChar[y];
          print("foiiiii222222222");
        }
      }
    }
  }
  */
}

blueScan(void Function(bool) inConBlueChange) async {
  if (isConectingBlue == true){return;}
  isConectingBlue = true;
  final List<ScanResult> scanResult = await FlutterBluePlus.instance
      .startScan(timeout: const Duration(seconds: 3));
  bool findDisp = false;
  for (int i = 0; i < scanResult.length; i++) {   
    //print(scanResult[i].device.name);
    if (scanResult[i].device.name == "ChurrasTech") {
      findDisp = true;
      await scanResult[i].device.connect();
      conectedDevice = scanResult[i].device;
      final List<BluetoothService>? services =
          await conectedDevice?.discoverServices();
      for (var x = 0; x < services!.length; x++) {
        //print(services[x].uuid);
        if (services[x].uuid.toString().toLowerCase() ==
            serviceUuid.toLowerCase()) {
          final lsOfChar = services[x].characteristics;
          for (var y = 0; y < lsOfChar.length; y++) {
            if (lsOfChar[y].uuid.toString().toLowerCase() ==
                characterReceberUuid.toLowerCase()) {
              BlueCharacteristicToRecive = lsOfChar[y];
              print("foiiiiiiiiiiii");
              criaLeitor();
            }
            ;
            if (lsOfChar[y].uuid.toString().toLowerCase() ==
                characterMandarUuid.toLowerCase()) {
              BlueCharacteristicToSend = lsOfChar[y];
              print("foiiiii222222222");
              inConBlueChange(false);
              //TODO chamar um "Ping" para receber as infos
            }
          }
        }
      }
    }
  }
  if (findDisp == false) {inConBlueChange(false);isConectingBlue = false;}
  //isConectingBlue = false;
  //inConBlueChange(false);
}

desco() async {
  await conectedDevice?.disconnect();
}

criaLeitor() async {
  if (BlueCharacteristicToRecive == null) {
    print("EEEEEEEEEEERRRRRRRRRRRRRRRRRRROOOOOOOOOOOORRRRRRRRRRRRRRR");
  } else {
    BlueCharacteristicToRecive?.value.listen((value) {
      blueNotify(value);
    });
    BlueCharacteristicToRecive?.setNotifyValue(true);
  }
  notiflyOk = true;
}

blueNotify(msgRecebida) {
  var recived = utf8.decode(msgRecebida);
  List<String> listRecived = recived.split(',');
  print(recived);
  print(listRecived);
  String comando = listRecived[0];
  if (comando == "Temp") {
    ListTemp = [listRecived[1], listRecived[2], listRecived[3], listRecived[4]];
  }
  print(listRecived[0]);

}

mandaMensagem(String msg) async {
  if (BlueCharacteristicToSend == null) {
    print("EEEEEEEEEEERRRRRRRRRRRRRRRRRRROOOOOOOOOOOORRRRRRRRRRRRRRR");
  } else {
    BlueCharacteristicToSend!.write(utf8.encode(msg)); //Só para mandar
  }
}

List getTemps() {
  return ListTemp;
}

bool reciverBluOk(){
  return notiflyOk;
}
