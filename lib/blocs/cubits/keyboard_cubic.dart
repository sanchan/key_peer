import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class KeyboardCubic extends Cubit<RawKeyEvent?> {
  KeyboardCubic() : super(null);

  void addKeyEvent(RawKeyEvent event) => emit(event);
}
