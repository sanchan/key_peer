
import 'package:flutter/material.dart';
import 'package:key_peer/bloc/game_bloc/events/game_settings_event/game_settings_event.dart';

@immutable
class SetTextEvent extends GameSettingsEvent {
  SetTextEvent({
    required this.text,
  });

  final String text;
}
