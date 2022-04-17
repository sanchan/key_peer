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
    color: Color.fromARGB(0, 255, 0, 0),
    dark: true
  );
  await Window.setEffect(
    effect: WindowEffect.transparent,
  );
  await Window.makeTitlebarTransparent();
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
      theme: CupertinoThemeData(brightness: Brightness.dark),
      home: Home(),
    );
  }
}
