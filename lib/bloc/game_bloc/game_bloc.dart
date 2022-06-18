
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:key_peer/bloc/blocs.dart';
import 'package:key_peer/bloc/cubits/game_settings_cubit.dart';
import 'package:key_peer/bloc/game_bloc/events/game_bloc_event.dart';
import 'package:key_peer/bloc/game_bloc/events/game_settings_event/set_text_event.dart';
import 'package:key_peer/bloc/game_bloc/events/game_status_event/set_game_status_event.dart';
import 'package:key_peer/models/text_generator.dart';
import 'package:key_peer/utils/enums.dart';
import 'package:key_peer/utils/types.dart';

class GameBloc extends Bloc<GameBlocEvent, GameState> {
  GameBloc() : super(const GameState()) {
    on<SetTextEvent>(_handleSetText);
    on<SetGameStatusEvent>(_handleSetGameStatus);
  }

  // TODO Move GameSettings to here
  GameSettings get _settings => Blocs.get<GameSettingsCubit>().state;
  List<TypedKeyStatus> get statuses => state.statuses;
  String get targetText => state.targetText;
  TextGenerator get textGenerator => _settings.textGenerator;

  void _handleSetText(SetTextEvent event, Emitter<GameState> emit) => emit(state.copyWith(
    targetText: () => event.text,
    statuses: () => event.text.split('').map((char) => TypedKeyStatus.none).toList(),
    cursorPosition: () => 0,
  ));

  void _handleSetGameStatus(SetGameStatusEvent event, Emitter<GameState> emit) => emit(state.copyWith(
    gameStatus: () => event.gameStatus,
  ));
}

extension GameBlocEmitters on GameBloc {
  void setText(String text) {
    add(SetTextEvent(text: text));
  }

  void generateText() {
    setText(textGenerator.generateText(_settings));
  }

  void setStatus(GameStatus status) => emit(state.copyWith(
    gameStatus: () => status,
  ));

  void reset() => emit(const GameState());

  void updateStatus(int index, TypedKeyStatus status) {
    final statuses = List.of(state.statuses);
    if(index < statuses.length) {
      statuses[index] = status;
    }

    final gameStatus = statuses.every((status) => status == TypedKeyStatus.none)
      ? GameStatus.none
      : statuses.every((status) => [TypedKeyStatus.correct, TypedKeyStatus.corrected].contains(status))
        ? GameStatus.completed
        : GameStatus.started;

    emit(state.copyWith(
      statuses: () => statuses,
      gameStatus: () => gameStatus,
    ));
  }
}

@immutable
class GameState {
  const GameState({
    this.targetText = '',
    this.cursorPosition = 0,
    this.statuses = const [],
    this.gameStatus = GameStatus.none,
  });

  final List<TypedKeyStatus> statuses;
  // TODO Rename to 'text'
  final String targetText;
  final int cursorPosition;
  final GameStatus gameStatus;

  GameState copyWith({
    Copyable<String>? targetText,
    Copyable<int>? cursorPosition,
    Copyable<List<TypedKeyStatus>>? statuses,
    Copyable<GameStatus>? gameStatus,
  }) => GameState(
    targetText: targetText?.call() ?? this.targetText,
    cursorPosition: cursorPosition?.call() ?? this.cursorPosition,
    statuses: statuses?.call() ?? this.statuses,
    gameStatus: gameStatus?.call() ?? this.gameStatus,
  );
}
