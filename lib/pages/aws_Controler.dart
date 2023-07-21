/*
 * Package : mqtt_client
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 10/07/2021
 * Copyright :  S.Hamblett
 *
 */

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:mqtt_client/mqtt_client.dart';

import '../logic/valor_Controler.dart';

late MqttServerClient client;

/// An example of connecting to the AWS IoT Core MQTT broker and publishing to a devices topic.
/// This example uses MQTT on port 8883 using certificites
/// More instructions can be found at https://docs.aws.amazon.com/iot/latest/developerguide/mqtt.html and
/// https://docs.aws.amazon.com/iot/latest/developerguide/protocols.html, please read this
/// before setting up and running this example.

late void Function(List) attPage2;
void awsRecivePage2Att(void Function(List) fun) {
  attPage2 = fun;
}

Future<int> aws() async {
  // Your AWS IoT Core endpoint url
  const url = "a35wgflbzj4nrh-ats.iot.sa-east-1.amazonaws.com";
  // AWS IoT MQTT default port
  const port = 8883;
  // The client id unique to your device
  const clientId = 'FlutterApp';

  // Create the client
  client = MqttServerClient.withPort(url, clientId, port);

  // Set secure
  client.secure = true;
  // Set Keep-Alive
  client.keepAlivePeriod = 99999;
  // Set the protocol to V3.1.1 for AWS IoT Core, if you fail to do this you will not receive a connect ack with the response code
  client.setProtocolV311();
  // logging if you wish
  client.logging(on: false);

  // Set the security context as you need, note this is the standard Dart SecurityContext class.
  // If this is incorrect the TLS handshake will abort and a Handshake exception will be raised,
  // no connect ack message will be received and the broker will disconnect.
  // For AWS IoT Core, we need to set the AWS Root CA, device cert & device private key
  // Note that for Flutter users the parameters above can be set in byte format rather than file paths

  ByteData rootCA = await rootBundle.load('lib/assets/awsCert/rootCA.pem');
  ByteData deviceCert =
      await rootBundle.load('lib/assets/awsCert/device.pem.crt');
  ByteData privateKey =
      await rootBundle.load('lib/assets/awsCert/private.pem.key');

  final context = SecurityContext.defaultContext;

  context.setClientAuthoritiesBytes(rootCA.buffer.asUint8List());
  context.useCertificateChainBytes(deviceCert.buffer.asUint8List());
  context.usePrivateKeyBytes(privateKey.buffer.asUint8List());
  client.securityContext = context;

  // Setup the connection Message
  final connMess =
      MqttConnectMessage().withClientIdentifier('FlutterApp').startClean();
  client.connectionMessage = connMess;

  // Connect the client
  try {
    print('MQTT client connecting to AWS IoT using certificates....');
    await client.connect();
  } on Exception catch (e) {
    print('MQTT client exception - $e');
    client.disconnect();
    exit(-1);
  }

  if (client.connectionStatus!.state == MqttConnectionState.connected) {
    print('MQTT client connected to AWS IoT');

    // Publish to a topic of your choice after a slight delay, AWS seems to need this
    await MqttUtilities.asyncSleep(1);
    const topic = '/test/topic';
    final builder = MqttClientPayloadBuilder();
    builder.addString('Hello World');
    // Important: AWS IoT Core can only handle QOS of 0 or 1. QOS 2 (exactlyOnce) will fail!
    client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);

    // Subscribe to the same topic
    client.subscribe(
        '\$aws/things/ChurrasTech2406/shadow/name/TemperaturesShadow/update/delta',
        MqttQos.atLeastOnce);
    client.subscribe(
        '\$aws/things/ChurrasTech2406/shadow/name/AlarmShadow/update/delta',
        MqttQos.atLeastOnce);
    // Print incoming messages from another client on this topic

    client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final recMess = c[0].payload as MqttPublishMessage;
      final pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      final mapMsg = jsonDecode(pt);
      print('Topic is <${c[0].topic}>, payload is <-- ${mapMsg['state']} -->');
      if (c[0].topic ==
          '\$aws/things/ChurrasTech2406/shadow/name/TemperaturesShadow/update/delta') {
        if (mapMsg['state']['Enviar'] == "0") {
          var Tgrelha = mapMsg['state']['Grelha'];
          var Tsensor1 = mapMsg['state']['Temp1'];
          var Tsensor2 = mapMsg['state']['Temp2'];
          var TempAlvo = mapMsg['state']['TAlvoEsp'];
          print("Valors das Temps: $Tgrelha $Tsensor1 $Tsensor2 $TempAlvo !");
          setTemp(Tgrelha, Tsensor1, Tsensor2, TempAlvo);
        }
      } else if (c[0].topic ==
          '\$aws/things/ChurrasTech2406/shadow/name/AlarmShadow/update/delta') {
        if (mapMsg['state']['Enviar'] == "0") {
          var AlarmeTimer = mapMsg['state']['TimerAlarm'];
          var AlarmeGraus = mapMsg['state']['GrausAlarm'];
          print("\n   $AlarmeTimer\n   $AlarmeGraus");
          attPage2([alarmToList(AlarmeGraus), alarmToList(AlarmeTimer)]);
          print("Aqui");
          print(alarmToList(AlarmeTimer));
        }
      }
    });
  } else {
    print(
        'ERROR MQTT client connection failed - disconnecting, state is ${client.connectionStatus!.state}');
    client.disconnect();
  }

  //print('Sleeping....');
  //await MqttUtilities.asyncSleep(10);

  //print('Disconnecting');
  //client.disconnect();

  return 0;
}

void awsMsg(topic, msg) {
  final builder = MqttClientPayloadBuilder();
  builder.addString(msg);
  // Important: AWS IoT Core can only handle QOS of 0 or 1. QOS 2 (exactlyOnce) will fail!
  client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
}

List alarmToList(String alarme) {
  if (alarme == "[]") {
    return ([0, 0, 0, 0, 0, 0, 0, 0, 0, 0]);
  }
  //print("00: $alarme");
  alarme = alarme.replaceAll('[[', '');
  //print("01: $alarme");
  alarme = alarme.replaceAll('], ', '');
  //print("02: $alarme");
  alarme = alarme.replaceAll("]]", '');
  //print("03: $alarme");
  var lista = alarme.split('[');
  //print("1: $lista");
  List newList = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  for (var i = 0; i < lista.length; i++) {
    var item = lista[i];
    print("2: ${item}");
    item = item.replaceAll("', ", 'w');
    item = item.replaceAll("'", '');
    newList[i] = item.split('w');
  }
  print(newList);

  return (newList);
}


void awsMotor(String motor){
  print(motor);
  var comandos = motor.split(',');
  awsMsg('\$aws/things/ChurrasTech2406/shadow/name/MotorShadow/update', '{"state": {"desired": {"Sentido": "${comandos[1]}","Nivel": "${comandos[2]}"}}}');
}

