import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

void main(){
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}



class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final recorder = FlutterSoundRecorder();
  final player = FlutterSoundPlayer();
  bool isRecorderReady = false;

  @override
  void initState() {
    super.initState();
    initRecorder();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future initRecorder() async {
    final status = await Permission.microphone.request();

    if(status != PermissionStatus.granted){
      throw 'Microphone permission not granted';
    }
    await recorder.openRecorder();
    isRecorderReady = true;
    recorder.setSubscriptionDuration(Duration(milliseconds: 500));
  }

  Future record() async {
    if(!isRecorderReady) return;
    await recorder.startRecorder( toFile: 'tau_file');
  }

  Future stop() async {
    if(!isRecorderReady) return;

    final path = await recorder.stopRecorder();
    final audioFile = await File(path!);

    print("Recorded audio :   ${audioFile}");
    // /data/user/0/com.example.voice_recorder_attempt_two/cache/tau_file

    print("Playing the player");
    await player.openPlayer();
    player.startPlayer(fromURI: path);

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder<RecordingDisposition>(
              stream: recorder.onProgress,
                builder: (context, snapshot) {
                final duration = snapshot.hasData
                    ? snapshot.data!.duration
                    : Duration.zero;

                String twoDigits(int n) => n.toString().padLeft(2,"0");
                final twoDigitMinutes =
                    twoDigits(duration.inMinutes.remainder(60));
                final twoDigitSeconds =
                    twoDigits(duration.inSeconds.remainder(60));

                return Text('$twoDigitMinutes: $twoDigitSeconds',
                  style: TextStyle(fontSize: 80, fontWeight: FontWeight.bold));
                }),
            ElevatedButton(
                onPressed: () async {
                  if(recorder.isRecording){
                    await stop();
                  } else {
                    await record();
                  }
                  setState(() {

                  });
                }
                , child: Icon(
              recorder.isRecording? Icons.stop: Icons.mic,
              size: 80,
            )),
            SizedBox(height: 20,),
            ElevatedButton(onPressed: (){
              // player.startPlayer(path);
            }, child: Icon(Icons.play_arrow))

          ],
        ),
      )
    );
  }
}

