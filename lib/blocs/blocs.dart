
import 'package:get_it/get_it.dart';
import 'package:key_peer/blocs/cubits/errors_cubic.dart';
import 'package:key_peer/blocs/cubits/keyboard_config_cubic.dart';
import 'package:key_peer/blocs/cubits/keyboard_cubic.dart';
import 'package:key_peer/blocs/cubits/speedometer_cubic.dart';

class Blocs {
  static final _getIt = GetIt.instance;

  static T get<T extends Object>() => _getIt.get<T>();

  static void setup() {
    _getIt
      ..registerSingleton(KeyboardConfigCubic())
      ..registerSingleton(KeyboardCubic())
      ..registerSingleton(SpeedometerCubic())
      ..registerSingleton(ErrorsCubic());
  }
}
