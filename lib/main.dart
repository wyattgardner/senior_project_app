import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './blecontroller.dart';

void main() => runApp(GetMaterialApp(home: Home()));

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final BleController ble = Get.put(BleController());
    return Scaffold(
        appBar: AppBar(title: const Text('Gas Sensor App')),
        body: Center(
            child: Column(children: [
          SizedBox(height: 50.0),
          ElevatedButton(
              onPressed: ble.connect,
              child: Obx(() => Text('${ble.status.value}',
                  style:
                      TextStyle(fontSize: 25, fontWeight: FontWeight.bold)))),
          SizedBox(height: 50.0),
          Obx(() => Text(
                'CO Concentration: ${ble.coConcentration.value} ppm',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              )),
          Obx(() => Text(
                'CH4 Concentration: ${ble.ch4Concentration.value} ppm',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              )),
          Obx(() => Text(
                'CO2 Concentration: ${ble.co2Concentration.value} ppm',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              )),
          Obx(() => Text(
                'Battery Charge: ${ble.battPercent.value}%',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              )),
        ])));
  }
}
