
import 'package:flutter/material.dart';
import 'package:key_peer/bloc/game_bloc/events/game_bloc_event.dart';

@immutable
class AddKeyEvent extends GameBlocEvent {
  AddKeyEvent({
    this.keyEvent,
  });

  final RawKeyEvent? keyEvent;
}
