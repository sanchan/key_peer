import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:key_peer/bloc/blocs.dart';
import 'package:key_peer/bloc/game_bloc/game_bloc.dart';
import 'package:key_peer/models/text_generator_settings.dart';
import 'package:key_peer/utils/text_generator.dart';
import 'package:key_peer/utils/types.dart';

class GameSettingsCubit extends Cubit<GameSettings> {
  GameSettingsCubit() : super(const GameSettings());

  @override
  void onChange(Change<GameSettings> change) {
    super.onChange(change);

    Blocs.get<GameBloc>().generateTextEvent();
  }

  void generateText() => emit(state.copyWith());

  void setTextGeneratorCharacters(List<String> characters) => emit(state.copyWith(
    textGeneratorSettings: () => state.textGeneratorSettings.copyWith(
      characters: () => characters,
    ),
  ));

  void setTextMaxLength(int maxLength) => emit(state.copyWith(
    textGeneratorSettings: () => state.textGeneratorSettings.copyWith(
      textMaxLength: () => max(maxLength, 25),
    ),
  ));

  void setUseCapitalLetters({ required bool value }) => emit(state.copyWith(
    textGeneratorSettings: () => state.textGeneratorSettings.copyWith(
      useCapitalLetters: () => value,
    ),
  ));

  void setUseNumbers({ required bool value }) => emit(state.copyWith(
    textGeneratorSettings: () => state.textGeneratorSettings.copyWith(
      useNumbers: () => value,
    ),
  ));

  void setUsePunctuation({ required bool value }) => emit(state.copyWith(
    textGeneratorSettings: () => state.textGeneratorSettings.copyWith(
      usePunctuation: () => value,
    ),
  ));

  void setUseRepeatLetters({ required bool value }) => emit(state.copyWith(
    textGeneratorSettings: () => state.textGeneratorSettings.copyWith(
      useRepeatLetters: () => value,
    ),
  ));
}

@immutable
class GameSettings {
  const GameSettings({
    this.textGenerator = const TextGenerator(),
    this.textGeneratorSettings = const TextGeneratorSettings(),
    this.maxErrors = 10,
  });

  final int maxErrors;
  final TextGenerator textGenerator;
  final TextGeneratorSettings textGeneratorSettings;

  GameSettings copyWith({
    Copyable<TextGenerator>? textGenerator,
    Copyable<TextGeneratorSettings>? textGeneratorSettings,
    Copyable<int>? maxErrors,
  }) => GameSettings(
    textGenerator: textGenerator?.call() ?? this.textGenerator,
    textGeneratorSettings: textGeneratorSettings?.call() ?? this.textGeneratorSettings,
    maxErrors: maxErrors?.call() ?? this.maxErrors,
  );
}
