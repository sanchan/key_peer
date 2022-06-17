import 'package:flutter_bloc/flutter_bloc.dart';

class SpeedometerCubit extends Cubit<SpeedometerState> {
  SpeedometerCubit() : super(SpeedometerState(value: 0));

  void increment() => emit(state.copyWith(value: state.value + 1));

  void reset() => emit(SpeedometerState(value: 0));

  void setLabel(String label) => emit(state.copyWith(label: label));
}

class SpeedometerState {
  SpeedometerState({
    required this.value,
    this.label = 'chars/min',
  });

  final int value;
  final String label;

  SpeedometerState copyWith({
    int? value,
    String? label,
  })  => SpeedometerState(
    value: value ?? this.value,
    label: label ?? this.label,
  );
}
