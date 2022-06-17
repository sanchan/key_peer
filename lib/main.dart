
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:key_peer/bloc/blocs.dart';
import 'package:key_peer/themed_cupertino_app.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  // ignore: avoid-ignoring-return-values
  WidgetsFlutterBinding.ensureInitialized();

  await Window.initialize();
  await Window.setEffect(
    effect: WindowEffect.mica,
  );
  await Window.makeTitlebarTransparent();

  await windowManager.ensureInitialized();

  // Use it only after calling `hiddenWindowAtLaunch`
  await windowManager.waitUntilReadyToShow();

  // Hide window title bar
  await windowManager.setTitleBarStyle(TitleBarStyle.hidden);
  await windowManager.setSize(const Size(1100,630));
  await windowManager.setMinimumSize(const Size(1100,630));
  await windowManager.setFullScreen(false); // Workaround
  await windowManager.center();
  await windowManager.show();
  await windowManager.setSkipTaskbar(false);

  Blocs.setup();

  return runApp(const ThemedCupertinoApp());
}
