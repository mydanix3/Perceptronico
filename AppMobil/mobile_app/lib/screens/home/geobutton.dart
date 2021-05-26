import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:perceptronico/screens/home/googleapis.dart';
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class GeoData extends StatefulWidget {
  @override
  _GeoDataState createState() => _GeoDataState();
}

class _GeoDataState extends State<GeoData> {
  Position _currentPosition;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Location"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_currentPosition != null) 
              Text(
                "LAT: ${_currentPosition.latitude}, LNG: ${_currentPosition.longitude}"
              ),
            if (_currentPosition != null) 
              FutureBuilder(
                future: getApisLocation(_currentPosition),
                builder: (context, snapshot){
                  return Center(
                    child: Text(snapshot.data.toString())
                  );
                },
              ),
            GestureDetector(
              child:
                Container( 
                  height: MediaQuery.of(context).size.height / 7,
                  child: Center(child: Text("Get location")),
                  decoration: BoxDecoration(
                    color: Colors.teal[300],
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                  ),
                ),
              onTap: () {
                _getCurrentLocation();
              },
            ),
          ],
        ),
      ),
    );
  }

  _getCurrentLocation() {
    Geolocator
      .getCurrentPosition(desiredAccuracy: LocationAccuracy.best, forceAndroidLocationManager: true)
      .then((Position position) {
        setState(() {
          _currentPosition = position;
        });
      }).catchError((e) {
        print(e);
      });
  }
}



Future<String> getApisLocation(Position _currentPosition) async {
  String url = ""
  var json = await HttpService.getRequest(url);
  //print(json.toString());

  var ayuda = await getAudioBase64Output(json.toString());

  var bytes = base64.decode(ayuda.audioContent);

  AudioPlayer audioPlayer = AudioPlayer();

  final file = new File('${(await getTemporaryDirectory()).path}/music.mp3');

  await file.writeAsBytes(bytes);

  await audioPlayer.play(file.path, isLocal: true);



  print(ayuda.toString());

  return "${json.toString()}";
}
