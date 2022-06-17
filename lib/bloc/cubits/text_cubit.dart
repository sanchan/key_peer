
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:key_peer/bloc/blocs.dart';
import 'package:key_peer/bloc/cubits/game_settings_cubit.dart';
import 'package:key_peer/models/text_generator.dart';
import 'package:key_peer/utils/enums.dart';
import 'package:key_peer/utils/types.dart';

class TextCubit extends Cubit<TextCubitState> {
  TextCubit() : super(const TextCubitState());

  GameSettings get _settings => Blocs.get<GameSettings>();

  TextGenerator get textGenerator => _settings.textGenerator;
  List<TypedKeyStatus> get statuses => state.statuses;
  // TODO Rename to 'text'
  String get targetText => state.targetText;

  void generateTargetText() {
    final targetText = textGenerator.generateText(_settings);
    final statuses = state.targetText.split('').map((char) => TypedKeyStatus.none).toList();

    emit(state.copyWith(
      targetText: () => targetText,
      statuses: () => statuses,
    ));
  }

  void reset() => emit(const TextCubitState());

  void updateStatus(int index, TypedKeyStatus status) {
    if(index < state.statuses.length) {
      state.statuses[index] = status;
    }
  }
}

@immutable
class TextCubitState {
  const TextCubitState({
    this.targetText = '',
    this.statuses = const [],
  });

  final List<TypedKeyStatus> statuses;
  // TODO Rename to 'text'
  final String targetText;

  TextCubitState copyWith({
    Copyable<String>? targetText,
    Copyable<List<TypedKeyStatus>>? statuses,
  }) => TextCubitState(
    targetText: targetText?.call() ?? this.targetText,
    statuses: statuses?.call() ?? this.statuses,
  );
}
