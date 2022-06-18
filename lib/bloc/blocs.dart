
import 'package:get_it/get_it.dart';
import 'package:key_peer/bloc/cubits/errors_cubit.dart';
import 'package:key_peer/bloc/cubits/game_settings_cubit.dart';
import 'package:key_peer/bloc/cubits/keyboard_config_cubit.dart';
import 'package:key_peer/bloc/cubits/keyboard_cubit.dart';
import 'package:key_peer/bloc/cubits/speedometer_cubit.dart';
import 'package:key_peer/bloc/game_bloc/game_bloc.dart';

class Blocs {
  static final _getIt = GetIt.instance;

  static T get<T extends Object>() => _getIt.get<T>();

  static void setup() {
    _getIt
      ..registerSingleton(GameSettingsCubit())
      ..registerSingleton(KeyboardConfigCubit())
      ..registerSingleton(KeyboardCubit())
      ..registerSingleton(GameBloc())
      ..registerSingleton(ErrorsCubit())
      ..registerSingleton(SpeedometerCubit());
  }
}
