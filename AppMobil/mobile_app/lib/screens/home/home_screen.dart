import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:perceptronico/constants.dart';
import 'package:perceptronico/screens/home/getsensors.dart';
import 'package:perceptronico/screens/home/geobutton.dart';
import 'package:perceptronico/screens/home/visionbutton.dart';

class HomeScreen extends StatelessWidget {
  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: 
          Center( 
            child: Text(
              "Perceptrònico",
              textAlign: TextAlign.center),
          ),
        ),
      
      body: Center(
        child: Container(
          child: Body(),
        )
      ),
    );
  }
}

class Body extends StatelessWidget {

  @override 
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GridView.count(
      //primary: false,
      padding: const EdgeInsets.all(20.0),
      crossAxisSpacing: 10.0,
      scrollDirection: Axis.vertical,
      crossAxisCount: 2, 
      childAspectRatio: size.width / (size.height - kToolbarHeight - 24), 
      children: <Widget>[
        GestureDetector(
          onTap: () { 
            Navigator.push(context, MaterialPageRoute(builder: (context) => SensorData()));
            
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.teal[300],
              borderRadius: BorderRadius.all(Radius.circular(20)),
              boxShadow: [ 
                BoxShadow (
                    offset: Offset(0, 10),
                    blurRadius: 5, 
                    color: kPrimaryColor.withOpacity(0.23),
               ), 
              ]
              ),
            child: Center(
              child: const Text(
                'Connecta amb Robot',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                )
              ),
            ),
            //color: Colors.teal[100],
          ),
        ),
        GestureDetector(
          onTap: () { 
            print("Opcionalitat encara no implementada"); 
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.teal[300],
              borderRadius: BorderRadius.all(Radius.circular(20)),
              boxShadow: [ 
                BoxShadow (
                    offset: Offset(0, 10),
                    blurRadius: 5, 
                    color: kPrimaryColor.withOpacity(0.23),
               ), 
              ]
              ),
            child: Center (
              child: const Text(
                'Personalització',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                )
              ),
            ),
            //color: Colors.teal[200],
          ),
        ),
        GestureDetector(
          onTap: () { 
            Navigator.push(context, MaterialPageRoute(builder: (context) => GeoData()));
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.teal[300],
              borderRadius: BorderRadius.all(Radius.circular(20)),
              boxShadow: [ 
                BoxShadow (
                    offset: Offset(0, 10),
                    blurRadius: 5, 
                    color: kPrimaryColor.withOpacity(0.23),
               ), 
              ]
              ),
            child: Center(
              child: const Text(
                'Zona Geogràfica',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                )
              ),
            ),
            //color: Colors.teal[300],
          ),
        ),
        GestureDetector(
          onTap: () { 
            //print("Opcionalitat encara no implementada"); 
            Navigator.push(context, MaterialPageRoute(builder: (context) => ImageRoute()));
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.teal[300],
              borderRadius: BorderRadius.all(Radius.circular(20)),
              boxShadow: [ 
                BoxShadow (
                    offset: Offset(0, 10),
                    blurRadius: 5, 
                    color: kPrimaryColor.withOpacity(0.23),
               ), 
              ]
              ),
            child: Center(
              child: const Text(
                'Visió Computador',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                )
              ),
            ),
            //color: Colors.teal[300],
          ),
        ),
      ],
    );
  }
} 