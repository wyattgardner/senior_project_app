import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'dart:typed_data';

class BleController {
  final frb = FlutterReactiveBle();
  late StreamSubscription<ConnectionStateUpdate> c;
  late QualifiedCharacteristic co;
  late QualifiedCharacteristic ch4;
  late QualifiedCharacteristic tx;
  final devId = 'D8:3A:DD:73:67:03';
  var status = 'Connect to Bluetooth'.obs;
  var coConcentration = 0;
  var ch4Concentration = 0;
  List<int> packet = [0x74, 0];

  void connect() async {
    status.value = 'Connecting...';
    c = frb.connectToDevice(id: devId).listen((state) {
      if (state.connectionState == DeviceConnectionState.connected) {
        status.value = 'Connected!';

        co = QualifiedCharacteristic(
            serviceId: Uuid.parse("0000181A-0000-1000-8000-00805F9B34FB"),
            characteristicId:
                Uuid.parse("ef090000-2ec0-4cd4-8f5a-51de99e65ecb"),
            deviceId: devId);

        ch4 = QualifiedCharacteristic(
            serviceId: Uuid.parse("0000181A-0000-1000-8000-00805F9B34FB"),
            characteristicId:
            Uuid.parse("ef090001-2ec0-4cd4-8f5a-51de99e65ecb"),
            deviceId: devId);

        tx = QualifiedCharacteristic(
            serviceId: Uuid.parse("0000181A-0000-1000-8000-00805F9B34FB"),
            characteristicId:
            Uuid.parse("ef090002-2ec0-4cd4-8f5a-51de99e65ecb"),
            deviceId: devId);
      }
    });
  }
}
