
import 'package:key_peer/bloc/cubits/game_settings_cubit.dart';
import 'package:key_peer/utils/enums.dart';

class GameState {
  GameState({
    required this.status,
    required this.settings,
    required this.targetText,
    required this.keyStatuses,
  });

  final GameStatus status;
  final GameSettings settings;
  final String targetText;
  final List<TypedKeyStatus> keyStatuses;
}
