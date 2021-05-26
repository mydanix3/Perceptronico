import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';
import 'package:perceptronico/screens/home/googleapis.dart';

class SensorData extends StatefulWidget {
  @override
  _SensorDataPage createState() => _SensorDataPage();
}

//void agafa_valors_giro(){
//  double x, y , z;
//
//  accelerometerEvents.listen((AccelerometerEvent event) {
//      ( {
//        x = event.x;
//        y = event.y;
//        z = event.z;
//      });
//    });
//
//}

class _SensorDataPage extends State<SensorData> {
  double x = 0.0, y = 0.0, z = 0.0;

  var account = signin();

  @override
  void initState() {

    super.initState();

    accelerometerEvents.listen((AccelerometerEvent  event) {
      setState(() {
        x = event.x;
        y = event.y;
        z = event.z;
      });
    }); //get the sensor data and set then to the data types
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Connexió Robot"),
      ),
      body: Center(
        child: GestureDetector(
          onTap: () {

            uploadFile(y, z, account);
          },
          child: Container(
            height: MediaQuery.of(context).size.height / 7,
            child: Center(
              child: Text("Envia les dades del giroscopi. Roll: ${x.toStringAsFixed(2)}, Pitch: ${y.toStringAsFixed(2)} Yaw:${z.toStringAsFixed(2)}"),
            ),
            decoration: BoxDecoration(
              color: Colors.teal[300],
              borderRadius: BorderRadius.all(Radius.circular(2)),
            ),
          )
        )
        //x.toStringAsFixed(2)
      )
    );
  }

}

