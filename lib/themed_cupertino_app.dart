import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:key_peer/screens/home.dart';
import 'package:macos_ui/macos_ui.dart';

class ThemedCupertinoApp extends StatelessWidget {
  const ThemedCupertinoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // This app is designed only to work vertically, so we limit
    // orientations to portrait up and down.
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
    );

    return MacosApp(
      title: 'KeyPeer',
      theme: MacosThemeData.dark(),
      darkTheme: MacosThemeData.dark(),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: const Home(),
    );
  }
}
