import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:key_peer/bloc/blocs.dart';
import 'package:key_peer/bloc/game_bloc/game_bloc.dart';
import 'package:key_peer/utils/types.dart';

class ScoreboardCubit extends Cubit<ScoreboardState> {
  ScoreboardCubit() : super(const ScoreboardState());

  int get _totalCharacters => Blocs.get<GameBloc>().currentText.length;

  void incrementErrors() {
    final errors = state.errors + 1;
    final accuracy = max((_totalCharacters - errors) / _totalCharacters * 100, 0).round();

    emit(state.copyWith(
      accuracy: () => accuracy,
      errors: () => errors,
    ));
  }

  void incrementTypedCharacters() => emit(state.copyWith(typedCharacters: () => state.typedCharacters + 1));

  void reset() => emit(const ScoreboardState());
}

@immutable
class ScoreboardState {
  const ScoreboardState({
    this.typedCharacters = 0,
    this.accuracy = 100,
    this.errors = 0,
  });

  final int accuracy;
  final int errors;
  final int typedCharacters;

  ScoreboardState copyWith({
    Copyable<int>? typedCharacters,
    Copyable<int>? accuracy,
    Copyable<int>? errors,
  })  => ScoreboardState(
    typedCharacters: typedCharacters?.call() ?? this.typedCharacters,
    accuracy: accuracy?.call() ?? this.accuracy,
    errors: errors?.call() ?? this.errors,
  );
}
