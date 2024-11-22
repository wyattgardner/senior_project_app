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
  late QualifiedCharacteristic co2;
  late QualifiedCharacteristic batt;
  late QualifiedCharacteristic tx;
  final devId = 'D8:3A:DD:73:5A:76';
  var status = 'Connect to Bluetooth'.obs;
  var coConcentration = 0.obs;
  var ch4Concentration = 0.obs;
  var co2Concentration = 0.obs;
  var battPercent = 0.obs;
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

        co2 = QualifiedCharacteristic(
            serviceId: Uuid.parse("0000181A-0000-1000-8000-00805F9B34FB"),
            characteristicId:
            Uuid.parse("ef090002-2ec0-4cd4-8f5a-51de99e65ecb"),
            deviceId: devId);

        batt = QualifiedCharacteristic(
            serviceId: Uuid.parse("0000181A-0000-1000-8000-00805F9B34FB"),
            characteristicId:
            Uuid.parse("ef090003-2ec0-4cd4-8f5a-51de99e65ecb"),
            deviceId: devId);

        tx = QualifiedCharacteristic(
            serviceId: Uuid.parse("0000181A-0000-1000-8000-00805F9B34FB"),
            characteristicId:
            Uuid.parse("ef090004-2ec0-4cd4-8f5a-51de99e65ecb"),
            deviceId: devId);

        frb.subscribeToCharacteristic(co).listen((data) {
          int concentration = _processData(data);
          coConcentration.value = concentration;
        });

        frb.subscribeToCharacteristic(ch4).listen((data) {
            int concentration = _processData(data);
            ch4Concentration.value = concentration;
          });

        frb.subscribeToCharacteristic(co2).listen((data) {
            int concentration = _processData(data);
            co2Concentration.value = concentration;
          });

        frb.subscribeToCharacteristic(batt).listen((data) {
            int percent = _processData(data);
            battPercent.value = percent;
          });
      }
    });
  }

  int _processData(List<int> data) {
    // Assuming the data is a 16-bit integer in little-endian format
    if (data.length >= 2) {
      return data[0] + (data[1] << 8);
    } else if (data.length == 1) {
      return data[0];
    } else {
      return 0;
    }
  }
}
