// // import 'dart:io';
//
// import 'dart:io';
//
// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_sound/flutter_sound.dart';
// import 'package:permission_handler/permission_handler.dart';
// // import 'dart:html';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//
//   final recorder = FlutterSoundRecorder();
//   bool isRecorderReady = false;
//
//   final audioPlayer = AudioPlayer();
//   bool isPlaying = false;
//   Duration duration = Duration.zero;
//   Duration position = Duration.zero;
//
//   @override
//   void initState() {
//     super.initState();
//     initRecorder();
//
//     audioPlayer.onPlayerStateChanged.listen((state) {
//       setState(() {
//         // isPlaying = state == PlayerState.PLAYING;
//       });
//     });
//
//     ///Listen to audio duration
//     audioPlayer.onDurationChanged.listen((newDuration) {
//       setState(() {
//         duration = newDuration;
//       });
//     });
//
//     ///Listen to audio position
//     audioPlayer.onAudioPositionChanged.listen((newPosition) {
//       setState(() {
//         position = newPosition;
//       });
//     });
//   }
//
//   @override
//   void dispose() {
//     recorder.closeRecorder();
//     super.dispose();
//   }
//
//   Future initRecorder() async {
//     final status = await Permission.microphone.request();
//
//     if(status != PermissionStatus.granted){
//       throw 'Microphone permission not granted';
//     }
//
//     await recorder.openRecorder();
//     isRecorderReady  = true;
//
//     recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
//   }
//
//   Future record() async {
//     if(!isRecorderReady) return;
//
//     await recorder.startRecorder(toFile: 'audio');
//   }
//
//   Future stop() async {
//     if(!isRecorderReady) return;
//
//     final path = await recorder.stopRecorder();
//     final audioFile = File(path!);
//
//     print('Recorded audio: $audioFile');
//   }
//
//
//   String formatTime(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2,"0");
//     final hours = twoDigits(duration.inHours);
//     final minutes =
//     twoDigits(duration.inMinutes.remainder(60));
//     final seconds =
//     twoDigits(duration.inSeconds.remainder(60));
//
//
//     return [
//       if(duration.inHours > 0) hours,
//       minutes,
//       seconds,
//     ].join(':');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             StreamBuilder<RecordingDisposition>(
//                 stream: recorder.onProgress,
//                 builder:(context, snapshot) {
//                   final duration = snapshot.hasData
//                       ? snapshot.data!.duration
//                       : Duration.zero;
//
//                   String twoDigits(int n) => n.toString().padLeft(2,"0");
//                   final twoDigitMinutes =
//                       twoDigits(duration.inMinutes.remainder(60));
//                   final twoDigitSeconds =
//                       twoDigits(duration.inSeconds.remainder(60));
//
//                   return Text('$twoDigitMinutes:$twoDigitSeconds',
//                   style: const TextStyle(
//                     fontSize: 80,
//                     fontWeight: FontWeight.bold
//                   ),
//                   );
//                 },
//             ),
//             // const SizedBox(height: 32,),
//             ElevatedButton(
//             child: Icon(
//               recorder.isRecording ? Icons.stop : Icons.mic,
//               size: 80,
//             ),
//               onPressed: () async {
//               if(recorder.isRecording) {
//                 await stop();
//               } else {
//                 await record();
//               }
//
//               setState(() {
//
//               });
//               },
//             ),
//             // SizedBox(height: 20,),
//             ClipRRect(
//               borderRadius: BorderRadius.circular(20),
//               child: Image.network(
//                   "https://images.unsplash.com/photo-1583121274602-3e2820c69888?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80",
//                 width: double.infinity,
//                 height: 350,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             // const SizedBox(height: 32,),
//             const Text('Recorder', style:  TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
//             const SizedBox(height: 4,),
//             const Text('Raj', style: TextStyle(fontSize: 20)),
//             Slider(
//               min: 0,
//                 max: duration.inSeconds.toDouble(),
//                 value: position.inSeconds.toDouble(),
//                 onChanged: (value) async {
//                 final position = Duration(seconds: value.toInt());
//                 await audioPlayer.seek(position);
//
//                 ///optiona;: Play audio if was paused
//                   await audioPlayer.resume();
//                 }),
//             Padding(padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(formatTime(position)),
//                   Text(formatTime(duration - position)),
//                 ],
//               ),),
//             CircleAvatar(
//               radius: 35,
//               child: IconButton(icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
//               iconSize: 50,
//               onPressed: () async {
//                 if ( isPlaying ) {
//                   await audioPlayer.pause();
//                 }
//                 else {
//                   String url = "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3";
//                   await audioPlayer.play(url);
//                 }
//               }),
//             )
//           ],
//         ),
//       )
//     );
//   }
// }
