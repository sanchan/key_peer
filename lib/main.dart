
import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:macos_ui/macos_ui.dart';

import 'package:key_peer/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Window.initialize();
  await Window.setEffect(
    effect: WindowEffect.mica,
    // color: const Color(0xCC222222),
    // color: const Color.fromARGB(200, 120, 0, 0),
    dark: true
  );
  await Window.makeTitlebarTransparent();

  await DesktopWindow.setMinWindowSize(const Size(1100,630));
  await DesktopWindow.setWindowSize(const Size(1100,630));

  return runApp(const ThemedCupertinoApp());
}

class ThemedCupertinoApp extends StatelessWidget {
  const ThemedCupertinoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // This app is designed only to work vertically, so we limit
    // orientations to portrait up and down.
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);


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
