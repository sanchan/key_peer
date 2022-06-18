
import 'package:flutter/material.dart';
import 'package:key_peer/bloc/game_bloc/events/game_bloc_event.dart';

@immutable
class SetTextEvent extends GameBlocEvent {
  SetTextEvent({
    required this.text,
  });

  final String text;
}
