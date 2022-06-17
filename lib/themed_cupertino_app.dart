import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:key_peer/screens/home.dart';
import 'package:key_peer/state/blocs.dart';
import 'package:key_peer/state/cubits/errors_cubic.dart';
import 'package:key_peer/state/cubits/keyboard_config_cubic.dart';
import 'package:key_peer/state/cubits/keyboard_cubic.dart';
import 'package:key_peer/state/cubits/speedometer_cubic.dart';
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
      home: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => Blocs.get<KeyboardConfigCubic>()),
          BlocProvider(create: (_) => Blocs.get<KeyboardCubic>()),
          BlocProvider(create: (_) => Blocs.get<SpeedometerCubic>()),
          BlocProvider(create: (_) => Blocs.get<ErrorsCubic>()),
        ],
        child: const Home(),
      ),
    );
  }
}
