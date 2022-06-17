import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:key_peer/utils/types.dart';

class GameSettingsCubit extends Cubit<GameSettings> {
  GameSettingsCubit() : super(const GameSettings());
}

@immutable
class GameSettings {
  const GameSettings({
    this.currentLesson,
    this.repeatLetter = false,
    this.useCapitalLetters = false,
    this.useNumbers = false,
    this.usePunctuation = false,
    this.textLength = 25,
    this.maxErrors = 10,
  });

  final LessonConfig? currentLesson;
  final int maxErrors;
  final bool repeatLetter;
  final int textLength;
  final bool useCapitalLetters;
  final bool useNumbers;
  final bool usePunctuation;

  GameSettings copyWith({
    Copyable<LessonConfig>? currentLesson,
    Copyable<int>? maxErrors,
    Copyable<bool>? repeatLetter,
    Copyable<int>? textLength,
    Copyable<bool>? useCapitalLetters,
    Copyable<bool>? useNumbers,
    Copyable<bool>? usePunctuation,
  }) => GameSettings(
    currentLesson: currentLesson?.call() ?? this.currentLesson,
    repeatLetter: repeatLetter?.call() ?? this.repeatLetter,
    useCapitalLetters: useCapitalLetters?.call() ?? this.useCapitalLetters,
    useNumbers: useNumbers?.call() ?? this.useNumbers,
    usePunctuation: usePunctuation?.call() ?? this.usePunctuation,
    textLength: textLength?.call() ?? this.textLength,
    maxErrors: maxErrors?.call() ?? this.maxErrors,
  );
}

@immutable
class LessonConfig {
  const LessonConfig({
    required this.id,
    required this.characters,
  });

  final List<String> characters;
  final int id;
}
