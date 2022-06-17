import 'package:flutter_bloc/flutter_bloc.dart';

class ErrorsCubic extends Cubit<int> {
  ErrorsCubic() : super(0);

  void increment() => emit(state + 1);

  void reset() => emit(0);
}
