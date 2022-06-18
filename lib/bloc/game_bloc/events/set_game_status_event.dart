import 'package:flutter/material.dart';
import 'package:key_peer/bloc/game_bloc/events/game_bloc_event.dart';
import 'package:key_peer/utils/enums.dart';

@immutable
class SetGameStatusEvent extends GameBlocEvent {
  SetGameStatusEvent({
    required this.status,
  });

  final GameStatus status;
}
