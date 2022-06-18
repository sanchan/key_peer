import 'package:flutter/material.dart';
import 'package:key_peer/bloc/game_bloc/events/game_status_event/game_status_event.dart';
import 'package:key_peer/utils/enums.dart';

@immutable
class SetGameStatusEvent extends GameStatusEvent {
  SetGameStatusEvent({
    required this.gameStatus,
  });

  final GameStatus gameStatus;
}
