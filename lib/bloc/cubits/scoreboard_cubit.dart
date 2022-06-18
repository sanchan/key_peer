import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:key_peer/bloc/blocs.dart';
import 'package:key_peer/bloc/game_bloc/game_bloc.dart';
import 'package:key_peer/utils/types.dart';

class ScoreboardCubit extends Cubit<ScoreboardState> {
  ScoreboardCubit() : super(const ScoreboardState());

  int get _totalCharacters => Blocs.get<GameBloc>().currentText.length;

  void setSpeed(int speed) => emit(state.copyWith(speed: () => speed));
  void setAccuracy(int accuracy) => emit(state.copyWith(accuracy: () => accuracy));
  void incrementTypedCharacters() => emit(state.copyWith(typedCharacters: () => state.typedCharacters + 1));
  void incrementErrors() {
    final errors = state.errors + 1;
    final accuracy = max((_totalCharacters - errors) / _totalCharacters * 100, 0).round();

    emit(state.copyWith(
      accuracy: () => accuracy,
      errors: () => errors,
    ));
  }
  void reset() => emit(const ScoreboardState());
}

@immutable
class ScoreboardState {
  const ScoreboardState({
    this.speedLabel = 'chars/min',
    this.speed = 0,
    this.accuracyLabel = 'accuracy',
    this.accuracy = 100,
    this.errorsLabel = 'errors',
    this.errors = 0,
    this.typedCharacters = 0,
  });

  final String speedLabel;
  final int speed;
  final String accuracyLabel;
  final int accuracy;
  final String errorsLabel;
  final int errors;
  final int typedCharacters;

  ScoreboardState copyWith({
    Copyable<String>? speedLabel,
    Copyable<int>? speed,
    Copyable<String>? accuracyLabel,
    Copyable<int>? accuracy,
    Copyable<String>? errorsLabel,
    Copyable<int>? errors,
    Copyable<int>? typedCharacters,
  })  => ScoreboardState(
    speedLabel: speedLabel?.call() ?? this.speedLabel,
    speed: speed?.call() ?? this.speed,
    accuracyLabel: accuracyLabel?.call() ?? this.accuracyLabel,
    accuracy: accuracy?.call() ?? this.accuracy,
    errorsLabel: errorsLabel?.call() ?? this.errorsLabel,
    errors: errors?.call() ?? this.errors,
    typedCharacters: typedCharacters?.call() ?? this.typedCharacters,
  );
}
