
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:key_peer/bloc/cubits/game_settings_cubit.dart';
import 'package:key_peer/bloc/cubits/keyboard_settings_cubit.dart';
import 'package:key_peer/bloc/cubits/scoreboard_cubit.dart';
import 'package:key_peer/bloc/game_bloc/game_bloc.dart';

@immutable
class Blocs {
  static final _getIt = GetIt.instance;

  static T get<T extends Object>() => _getIt.get<T>();

  static void setup() {
    _getIt
      ..registerSingleton(KeyboardSettingsCubit())
      ..registerSingleton(ScoreboardCubit())
      ..registerSingleton(GameSettingsCubit())
      ..registerSingleton(GameBloc());
  }
}
