
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:key_peer/bloc/blocs.dart';
import 'package:key_peer/bloc/cubits/game_settings_cubit.dart';
import 'package:key_peer/bloc/cubits/scoreboard_cubit.dart';
import 'package:key_peer/bloc/game_bloc/events/add_key_event.dart';
import 'package:key_peer/bloc/game_bloc/events/game_bloc_event.dart';
import 'package:key_peer/bloc/game_bloc/events/generate_text_event.dart';
import 'package:key_peer/bloc/game_bloc/events/set_game_status_event.dart';
import 'package:key_peer/bloc/game_bloc/events/set_text_event.dart';
import 'package:key_peer/utils/enums.dart';
import 'package:key_peer/utils/types.dart';

class GameBloc extends Bloc<GameBlocEvent, GameState> {
  GameBloc() : super(const GameState()) {
    on<AddKeyEvent>(_handleAddKeyEvent);
    on<SetGameStatusEvent>(_handleSetGameStatus);
    on<SetTextEvent>(_handleSetText);
    on<GenerateTextEvent>(_handleGenerateTextEvent);
  }

  String get currentText => state.currentText;
  int get cursorPosition => state.cursorPosition;
  bool get isLessonCompleted => state.gameStatus == GameStatus.completed;
  List<GameKeyStatus> get statuses => state.statuses;

  void _handleAddKeyEvent(AddKeyEvent event, Emitter<GameState> emit) {
    final keyEvent = event.keyEvent;

    /// If game is completed and the user pressed the 'space' key, we want to generate a new text.
    if(state.gameStatus == GameStatus.completed && keyEvent?.logicalKey == LogicalKeyboardKey.space) {
      return Blocs.get<GameSettingsCubit>().generateText();
    }

    /// If keyEvent is 'null' or 'RawKeyUpEvent' we only want to track the event, but we don't have anything else to do.
    if(keyEvent == null || keyEvent is RawKeyUpEvent) {
      return emit(state.copyWith(
        keyEvent: () => keyEvent,
      ));
    }

    /// Ignore events
    if(currentText.isEmpty || isLessonCompleted)  {
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
        cursorPosition: () => min(state.cursorPosition + 1, currentText.length - 1),
      ));
    }

    /// If keyEvent doesn't carry a character, there's nothing else we need to do with it
    if(keyEvent.character == null) {
      return;
    }

    /// We know the key is a character, so we increment the total number of typed characters
    Blocs.get<ScoreboardCubit>().incrementTypedCharacters();

    /// Update characters status based on the keyEvent we recieved.
    final statuses = List.of(state.statuses);
    if(keyEvent.character == currentText[cursorPosition]) {
      switch (statuses[cursorPosition]) {
        case GameKeyStatus.none:
        case GameKeyStatus.correct:
          statuses[cursorPosition] = GameKeyStatus.correct;
          break;
        case GameKeyStatus.error:
        case GameKeyStatus.ammended:
          statuses[cursorPosition] = GameKeyStatus.ammended;
      }
    } else {
      statuses[cursorPosition] = GameKeyStatus.error;

      Blocs.get<ScoreboardCubit>().incrementErrors();
    }

    /// Update game status if we need it
    final gameStatus = statuses.every((status) => status == GameKeyStatus.none)
      ? GameStatus.none
      : statuses.every((status) => [GameKeyStatus.correct, GameKeyStatus.ammended].contains(status))
        ? GameStatus.completed
        : GameStatus.started;

    emit(state.copyWith(
      keyEvent: () => keyEvent,
      statuses: () => statuses,
      gameStatus: () => gameStatus,
      cursorPosition: () => min(state.cursorPosition + 1, currentText.length - 1),
    ));
  }

  void _handleSetGameStatus(SetGameStatusEvent event, Emitter<GameState> emit) => emit(state.copyWith(
    gameStatus: () => event.status,
  ));

  void _handleSetText(SetTextEvent event, Emitter<GameState> emit) {
    Blocs.get<ScoreboardCubit>().reset();

    emit(state.copyWith(
      currentText: () => event.text,
      statuses: () => event.text.split('').map((char) => GameKeyStatus.none).toList(),
      gameStatus: () => GameStatus.none,
      cursorPosition: () => 0,
    ));
  }

  void _handleGenerateTextEvent(GenerateTextEvent _, Emitter<GameState> __) {
    final state = Blocs.get<GameSettingsCubit>().state;

    setText(state.textGenerator.generate(state.textGeneratorSettings));
  }
}

extension GameBlocEmitters on GameBloc {
  void setText(String text) => add(SetTextEvent(text: text));

  void setStatus(GameStatus status) => add(SetGameStatusEvent(status: status));

  void addKeyEvent(RawKeyEvent? keyEvent) => add(AddKeyEvent(keyEvent: keyEvent));

  void generateTextEvent() => add(GenerateTextEvent());
}

@immutable
class GameState {
  const GameState({
    this.currentText = '',
    this.cursorPosition = 0,
    this.statuses = const [],
    this.gameStatus = GameStatus.none,
    this.keyEvent,
  });

  final String currentText;
  final int cursorPosition;
  final GameStatus gameStatus;
  final RawKeyEvent? keyEvent;
  final List<GameKeyStatus> statuses;

  GameState copyWith({
    Copyable<String>? currentText,
    Copyable<int>? cursorPosition,
    Copyable<List<GameKeyStatus>>? statuses,
    Copyable<GameStatus>? gameStatus,
    Copyable<RawKeyEvent>? keyEvent,
  }) => GameState(
    currentText: currentText?.call() ?? this.currentText,
    cursorPosition: cursorPosition?.call() ?? this.cursorPosition,
    statuses: statuses?.call() ?? this.statuses,
    gameStatus: gameStatus?.call() ?? this.gameStatus,
    keyEvent: keyEvent?.call() ?? this.keyEvent,
  );
}
