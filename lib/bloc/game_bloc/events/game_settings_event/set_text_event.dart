
import 'package:key_peer/bloc/game_bloc/events/game_settings_event/game_settings_event.dart';

class SetTextEvent extends GameSettingsEvent {
  SetTextEvent({
    required this.text,
  });

  final String text;
}
