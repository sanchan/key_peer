import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class KeyboardCubit extends Cubit<RawKeyEvent?> {
  KeyboardCubit() : super(null);

  void addKeyEvent(RawKeyEvent? event) => emit(event);
}
