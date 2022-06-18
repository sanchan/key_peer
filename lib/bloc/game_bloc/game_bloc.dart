
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:key_peer/bloc/game_bloc/events/add_key_event.dart';
import 'package:key_peer/bloc/game_bloc/events/game_bloc_event.dart';
import 'package:key_peer/bloc/game_bloc/events/set_game_status_event.dart';
import 'package:key_peer/bloc/game_bloc/events/set_text_event.dart';
import 'package:key_peer/models/text_generator.dart';
import 'package:key_peer/utils/enums.dart';
import 'package:key_peer/utils/types.dart';

class GameBloc extends Bloc<GameBlocEvent, GameState> {
  GameBloc() : super(const GameState()) {
    on<SetTextEvent>(_handleSetText);
    on<SetGameStatusEvent>(_handleSetGameStatus);
    on<AddKeyEvent>(_handleAddKeyEvent);
  }

  GameSettings get _settings => state.gameSettings;
  int get cursorPosition => state.cursorPosition;
  bool get isLessonCompleted => state.gameStatus == GameStatus.completed;
  List<TypedKeyStatus> get statuses => state.statuses;
  String get targetText => state.currentText;
  TextGenerator get textGenerator => _settings.textGenerator;

  void _handleAddKeyEvent(AddKeyEvent event, Emitter<GameState> emit) {
    final keyEvent = event.keyEvent;

    /// If keyEvent is 'null' or 'RawKeyUpEvent' we only want to track the event, but we don't have anything else to do.
    if(keyEvent == null || keyEvent is RawKeyUpEvent) {
      return emit(state.copyWith(
        keyEvent: () => keyEvent,
      ));
    }

    /// Ignore events
    if(targetText.isEmpty || isLessonCompleted)  {
      return;
    }

    /// Move cursor when pressing left|right arrows or backspace.
    if(
      keyEvent.logicalKey == LogicalKeyboardKey.backspace ||
      keyEvent.logicalKey == LogicalKeyboardKey.arrowLeft
    ) {
      return emit(state.copyWith(
        cursorPosition: () => max(state.cursorPosition - 1, 0),
      ));
    } else if(keyEvent.logicalKey == LogicalKeyboardKey.arrowRight) {
      return emit(state.copyWith(
        cursorPosition: () => min(state.cursorPosition + 1, targetText.length - 1),
      ));
    }

    /// Update characters status based on the keyEvent we recieved.
    final statuses = List.of(state.statuses);
    final modifiers = keyEvent.data.modifiersPressed;
    final keyLabel =
      modifiers.containsKey(ModifierKey.shiftModifier) ||
      modifiers.containsKey(ModifierKey.capsLockModifier)
        ? keyEvent.logicalKey.keyLabel.toUpperCase()
        : keyEvent.logicalKey.keyLabel.toLowerCase();

    if(keyLabel == targetText[cursorPosition]) {
      if(
        statuses[cursorPosition] == TypedKeyStatus.none ||
        statuses[cursorPosition] == TypedKeyStatus.correct
      ) {
        statuses[cursorPosition] = TypedKeyStatus.correct;
      } else {
        statuses[cursorPosition] = TypedKeyStatus.corrected;
      }
    } else {
      statuses[cursorPosition] = TypedKeyStatus.error;
    }

    /// Update game status if we need it
    final gameStatus = statuses.every((status) => status == TypedKeyStatus.none)
      ? GameStatus.none
      : statuses.every((status) => [TypedKeyStatus.correct, TypedKeyStatus.corrected].contains(status))
        ? GameStatus.completed
        : GameStatus.started;

    emit(state.copyWith(
      keyEvent: () => keyEvent,
      statuses: () => statuses,
      gameStatus: () => gameStatus,
      cursorPosition: () => min(state.cursorPosition + 1, targetText.length - 1),
    ));
  }

  void _handleSetGameStatus(SetGameStatusEvent event, Emitter<GameState> emit) => emit(state.copyWith(
    gameStatus: () => event.status,
  ));

  void _handleSetText(SetTextEvent event, Emitter<GameState> emit) => emit(state.copyWith(
    currentText: () => event.text,
    statuses: () => event.text.split('').map((char) => TypedKeyStatus.none).toList(),
    cursorPosition: () => 0,
  ));
}

extension GameBlocEmitters on GameBloc {
  void setText(String text) => add(SetTextEvent(text: text));

  void generateText() => add(SetTextEvent(text: 'qwerty'));
  // void generateText() => setText(state.textGenerator.generateText(state.gameSettings));

  void setStatus(GameStatus status) => add(SetGameStatusEvent(status: status));

  void addKeyEvent(RawKeyEvent? keyEvent) => add(AddKeyEvent(keyEvent: keyEvent));
}

@immutable
class GameState {
  const GameState({
    this.gameSettings = const GameSettings(),
    this.currentText = '',
    this.cursorPosition = 0,
    this.statuses = const [],
    this.gameStatus = GameStatus.none,
    this.keyEvent,
  });

  final String currentText;
  final int cursorPosition;
  final GameSettings gameSettings;
  final GameStatus gameStatus;
  final RawKeyEvent? keyEvent;
  final List<TypedKeyStatus> statuses;

  GameState copyWith({
    Copyable<GameSettings>? gameSettings,
    Copyable<String>? currentText,
    Copyable<int>? cursorPosition,
    Copyable<List<TypedKeyStatus>>? statuses,
    Copyable<GameStatus>? gameStatus,
    Copyable<RawKeyEvent>? keyEvent,
  }) => GameState(
    gameSettings: gameSettings?.call() ?? this.gameSettings,
    currentText: currentText?.call() ?? this.currentText,
    cursorPosition: cursorPosition?.call() ?? this.cursorPosition,
    statuses: statuses?.call() ?? this.statuses,
    gameStatus: gameStatus?.call() ?? this.gameStatus,
    keyEvent: keyEvent?.call() ?? this.keyEvent,
  );
}

@immutable
class GameSettings {
  const GameSettings({
    this.textGenerator = const TextGenerator(),
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
  final TextGenerator textGenerator;
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
