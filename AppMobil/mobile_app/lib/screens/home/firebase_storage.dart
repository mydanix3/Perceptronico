import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path/path.dart' as Path;
import 'package:googleapis/storage/v1.dart';
import 'package:googleapis_auth/auth_io.dart';



Future upload_firebase_storage(File _image) async {
  StorageReference storageReference = FirebaseStorage.instance
      .ref()
      .child('perceptronico/imatge/img.jpeg');
  StorageUploadTask uploadTask = storageReference.putFile(_image);
  await uploadTask.onComplete;
  print('File Uploaded');


}



Future<void> downloadFileExample() async {

  final file = new File('${(await getTemporaryDirectory()).path}/music.mp3');

  var a = true;

  while (a) {
    try {
    final StorageFileDownloadTask downloadTask = FirebaseStorage.instance
          .ref()
          .child('perceptronico/audio/audio.mp3').writeToFile(file);

      await downloadTask.future;

      a = false;
    }
    catch (e) {

      a = true;

    }

  }

  AudioPlayer audioPlayer = AudioPlayer();

//  final file = new File('${(await getTemporaryDirectory()).path}/music.mp3');
//
//
//  final StorageFileDownloadTask downloadTask = FirebaseStorage.instance
//      .ref()
//      .child('perceptronico/audio/audio.mp3').writeToFile(file);
//
//  await downloadTask.future;

  await audioPlayer.play(file.path, isLocal: true);

  await FirebaseStorage.instance
      .ref()
      .child('perceptronico/audio/audio.mp3').delete();

  print('File Upload');

}
