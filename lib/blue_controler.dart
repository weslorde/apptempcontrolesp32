import 'dart:convert';

import 'package:apptempcontrolesp32/pages/notificationAlarm.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

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
List AlarmeGraus = [0,0,0,0,0, 0,0,0,0,0]; //[0,0,0,0,0,0,0,0];
List AlarmeTimer = [0,0,0,0,0, 0, 0, 0, 0, 0]; //[0,0,0,0,0,0,0,0];
bool notiflyOk = false;

late void Function(List) attPage2;

void recivePage2Att(void Function(List) fun){
  attPage2 = fun;
}

Future<List<bool>> status() async {
  //await Permission.location.request();
  //await Permission.bluetooth.request();
  return [await FlutterBluePlus.instance.isOn, await location.serviceEnabled()];
}

bool isConnectBlueDevice() {
  if (conectedDevice?.name == "ESP32" || conectedDevice?.name == "ChurrasTech") {return true;}
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
    print(scanResult[i].device.name);
    if (scanResult[i].device.name == "ESP32" || scanResult[i].device.name == "ChurrasTech") {
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
              //mandaMensagem("Ping");
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
  else if (comando == "AlarmG"){
    int x = int.parse(listRecived[1]);
    AlarmeGraus[x] = [listRecived[2], listRecived[3] ];
    attPage2([AlarmeGraus,AlarmeTimer]);
  }
  else if (comando == "AlarmT"){
    int x = int.parse(listRecived[1]);
    AlarmeTimer[x] = [listRecived[2], listRecived[3] ];
    attPage2([AlarmeGraus,AlarmeTimer]);
  }
  else if (comando == "NotT"){
    if (listRecived[1] == "0"){
      NotificationService().showNotification(CustomNotification(id: 1, title: 'Alarme', body: 'Alarme de ${listRecived[2]} minutos concluído', payload: 'GoAlarmes'));
    }
    else if(listRecived[1] == "1"){
      NotificationService().showNotification(CustomNotification(id: 1, title: 'Alarme', body: 'Alarme de ${listRecived[1]} hora e ${listRecived[2]} minutos concluído', payload: 'GoAlarmes'));
    }
    else{NotificationService().showNotification(CustomNotification(id: 1, title: 'Alarme', body: 'Alarme de ${listRecived[1]} horas e ${listRecived[2]} minutos concluído', payload: 'GoAlarmes'));}
  }
  else if (comando == "NotG"){
    if(listRecived[1] == "Grelha"){
      NotificationService().showNotification(CustomNotification(id: 1, title: 'Temperatura da ${listRecived[1]}', body: 'Temperatura da ${listRecived[1]} alcançou ${listRecived[2]} graus', payload: 'GoAlarmes'));
    }
    else if (listRecived[1] == "Sensor1"){
      NotificationService().showNotification(CustomNotification(id: 1, title: 'Temperatura do Sensor 1', body: 'Temperatura do Sensor 1 alcançou ${listRecived[2]} graus', payload: 'GoAlarmes'));
      }
    else if (listRecived[1] == "Sensor2"){
      NotificationService().showNotification(CustomNotification(id: 1, title: 'Temperatura do Sensor 2', body: 'Temperatura do Sensor 2 alcançou ${listRecived[2]} graus', payload: 'GoAlarmes'));
      }
  }


}

TestPrint() async {
  print(AlarmeGraus);
  print(AlarmeTimer);
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

List<List> getAlarm() {
  return [AlarmeGraus,AlarmeTimer];
}

void apagaAlarm(String name, int indice){
  if (name == "timer"){
    AlarmeTimer = [0,0,0,0,0, 0,0,0,0,0]; //Reinicia lista para receber os valores que ficaram
  } else{ AlarmeGraus = [0,0,0,0,0, 0,0,0,0,0];}
  print(AlarmeTimer);
  mandaMensagem("DelAlarme,$name,$indice");
  attPage2([AlarmeGraus,AlarmeTimer]);
  mandaMensagem("Alarme");  // Solicita os valores
  
}
