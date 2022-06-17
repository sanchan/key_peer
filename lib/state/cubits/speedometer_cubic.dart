import 'package:flutter_bloc/flutter_bloc.dart';

class SpeedometerCubic extends Cubit<SpeedometerState> {
  SpeedometerCubic() : super(SpeedometerState(value: 0));

  void increment() => emit(state.copyWith(value: state.value + 1));

  void reset() => emit(SpeedometerState(value: 0));

  void setLabel(String label) => emit(state.copyWith(label: label));
}

class SpeedometerState {
  SpeedometerState({
    required this.value,
    this.label = 'chars/min',
  });

  int value;
  String label;

  SpeedometerState copyWith({
    int? value,
    String? label,
  })  => SpeedometerState(
    value: value ?? this.value,
    label: label ?? this.label,
  );
}
