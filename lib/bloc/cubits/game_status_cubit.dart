

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:key_peer/utils/enums.dart';

class GameStatusCubit extends Cubit<GameStatus> {
  GameStatusCubit() : super(GameStatus.none);

  void setStatus(GameStatus event) => emit(event);
}
