import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis/vision/v1.dart';
import 'package:http/http.dart';
import 'package:googleapis/texttospeech/v1.dart';
import 'dart:convert';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_sign_in/google_sign_in.dart' as signIn;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';


class HttpService {
  static Future<String> getRequest(String url) async {
    Response res = await get(Uri.parse(url));
    if (res.statusCode == 200) {
     var a = jsonDecode(res.body)['results'][0]['formatted_address'];
     //print(a);
     return a;
    } else {
      throw "Unable to retrieve posts.";
    }
  }
}

class AudioOutputBase64Encoded{
  String audioContent;

  AudioOutputBase64Encoded({this.audioContent});

  AudioOutputBase64Encoded.fromJson(Map<String, dynamic> json) {
    audioContent = json['audioContent'];
  }
  Map<String, dynamic> toJson() => {
    'audioContent':audioContent,
  };



}

Future<AudioOutputBase64Encoded> getAudioBase64Output (String text) async{

  var _apiURL = 'https://texttospeech.googleapis.com/v1/text:synthesize?key=';

  var body = '{"input": {"text":"$text"}, "voice": {"languageCode":"ca-ES" , "name":"ca-es-Estándar-A"}, "audioConfig": {"audioEncoding":"MP3"}}';

  Future request = post(Uri.parse(_apiURL), body: body);

  var response = await _getResponse(request);

  return AudioOutputBase64Encoded.fromJson(response);

}

Future _getResponse(Future<Response> request) {

  return request.then((response){

    if(response.statusCode==200){
      return jsonDecode(response.body);
    }
    throw(jsonDecode(response.body));
  });
}

Future<dynamic> signin() async {
  final googleSignIn = signIn.GoogleSignIn.standard(scopes: [drive.DriveApi.driveScope]);
  final signIn.GoogleSignInAccount account = await googleSignIn.signIn();
  print("User account $account");
  return account;
}
Future<void> uploadFile(dynamic x, dynamic y, dynamic account) async {

  x = (x/9.81)*3.14;
  y = (y/9.81)*3.14;

  final googleSignIn = signIn.GoogleSignIn.standard(scopes: [drive.DriveApi.driveScope]);
  final signIn.GoogleSignInAccount account = await googleSignIn.signIn();
  print("User account $account");

  final authHeaders = await account.authHeaders;
  final authenticateClient = GoogleAuthClient(authHeaders);
  final driveApi = drive.DriveApi(authenticateClient);

  final file = new File('${(await getTemporaryDirectory()).path}/coords.txt');

  await file.writeAsString("$x $y");



  var media = new drive.Media(file.openRead(), file.lengthSync());
  var driveFile = new drive.File();
  driveFile.name = "coords.txt";
  driveFile.parents = [""];
  final result = await driveApi.files.create(driveFile, uploadMedia: media);
  print("Upload result: $result");

  downloadGoogleDriveFile(account);

}

class GoogleAuthClient extends BaseClient {
  final Map<String, String> _headers;

  final Client _client = new Client();

  GoogleAuthClient(this._headers);

  Future<StreamedResponse> send(BaseRequest request) {
    return _client.send(request..headers.addAll(_headers));
  }
}

Future<void> downloadGoogleDriveFile(dynamic account) async {


  final googleSignIn = signIn.GoogleSignIn.standard(scopes: [drive.DriveApi.driveScope]);
  final signIn.GoogleSignInAccount account = await googleSignIn.signIn();
  print("User account $account");

  final authHeaders = await account.authHeaders;
  final authenticateClient = GoogleAuthClient(authHeaders);
  final driveApi = drive.DriveApi(authenticateClient);

  drive.Media file = await driveApi.files.get("", downloadOptions: drive.DownloadOptions.fullMedia);

  final saveat = new File('${(await getTemporaryDirectory()).path}/music.mp3');
  List<int> dataStore = [];
  file.stream.listen((data) {  
      dataStore.insertAll(dataStore.length, data);  
    }, onDone: () {  
      print("Task Done");  
      saveat.writeAsBytes(dataStore);  
    }, onError: (error) {  
      print("Some Error");  
    });  

  AudioPlayer audioPlayer = AudioPlayer();
  await audioPlayer.play(saveat.path, isLocal: true);
//  final googleSignIn = signIn.GoogleSignIn.standard(scopes: [drive.DriveApi.driveScope]);
//  var client = GoogleHttpClient(await googleSignInAccount.authHeaders);
//  var drive = drive.DriveApi(client);
//  drive.Media file = await drive.files
//      .get(gdID, downloadOptions: drive.DownloadOptions.FullMedia);
//  print(file.stream);

}
