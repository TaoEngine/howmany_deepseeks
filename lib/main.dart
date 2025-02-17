import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:just_audio/just_audio.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      statusBarColor: Colors.transparent,
    ),
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  Future<List<AppInfo>> apps() async {
    await play();
    return await InstalledApps.getInstalledApps();
  }

  Future<void> play() async {
    AudioPlayer audioPlayer = AudioPlayer();
    audioPlayer.setAsset('audio/congratulations.wav');
    await audioPlayer.play();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: FutureBuilder(
          future: apps(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  year2023: false,
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Error"),
              );
            } else {
              final List<AppInfo> app = snapshot.data;
              return ListView.builder(
                itemCount: app.length,
                itemBuilder: (BuildContext context, int index) {
                  return Text(app[index].name);
                },
              );
            }
          },
        ),
      ),
    );
  }
}
