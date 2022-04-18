
import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';

import 'package:key_peer/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Window.initialize();
  await Window.setEffect(
    effect: WindowEffect.acrylic,
    // color: const Color(0xCC222222),
    color: const Color.fromARGB(0, 255, 0, 0),
    dark: true
  );
  await Window.makeTitlebarTransparent();

  await DesktopWindow.setMinWindowSize(const Size(1100,450));

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

    return const CupertinoApp(
      debugShowCheckedModeBanner: false,
      theme: CupertinoThemeData(brightness: Brightness.dark),
      home: Home(),
    );
  }
}
