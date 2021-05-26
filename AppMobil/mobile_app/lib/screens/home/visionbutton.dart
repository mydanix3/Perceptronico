import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:perceptronico/screens/home/firebase_storage.dart';

class ImageRoute extends StatefulWidget {
  @override
  _ImageRouteState createState() => _ImageRouteState();
}
 
class _ImageRouteState extends State<ImageRoute> {
 
  File imgFile;
  final imgPicker = ImagePicker();

  Future takeImage() async {
    final pickedFile = await imgPicker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        imgFile = File(pickedFile.path);
        upload_firebase_storage(imgFile);
        downloadFileExample();
      } else {
        print('No image selected.');
      }
    });
  } 

  Widget displayImage(){
    if(imgFile == null){
      return Text("No Image Selected!");
    } else{
      return Image.file(imgFile, width: 350, height: 350);
    }
  }

  @override
  Widget build(BuildContext context) {
         return Scaffold(
           appBar: AppBar(title: Text("Visió"),),
           body: Center(
             child: 
             Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              displayImage(),
              SizedBox(height: 30),
              GestureDetector(
                onTap: () { takeImage(); },
                child: Container(
                  height: MediaQuery.of(context).size.height / 7,
                  child: Center(
                    child: Icon(Icons.add_a_photo),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.teal[300],
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                  ),
                ),
                )
              ],
        ),
      ),
   );
  }
}