import 'package:flutter_bloc/flutter_bloc.dart';

class ErrorsCubit extends Cubit<int> {
  ErrorsCubit() : super(0);

  void increment() => emit(state + 1);

  void reset() => emit(0);
}
