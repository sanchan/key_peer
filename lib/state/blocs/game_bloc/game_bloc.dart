
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:key_peer/state/blocs/game_bloc/events/game_bloc_event.dart';
import 'package:key_peer/state/blocs/game_bloc/game_state.dart';
import 'package:key_peer/utils/enums.dart';

class GameBloc extends Bloc<GameBlocEvent, GameState> {
  GameBloc() : super(GameState());


   void generateTargetText() {
    targetText.value = _textGenerator.generateText(settings.value);
    statuses.value = targetText.value.characters.map((char) => TypedKeyStatus.none).toList();
  }

  void updateStatus(int index, TypedKeyStatus status) {
    if(index < statuses.value.length) {
      statuses.value[index] = status;
    }
  }
}
