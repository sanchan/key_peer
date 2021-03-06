import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:key_peer/bloc/game_bloc/game_bloc.dart';
import 'package:key_peer/models/keyboard_key_info.dart';
import 'package:key_peer/utils/enums.dart';

class KeyRenderer extends StatefulWidget {
  const KeyRenderer({
    required this.keyInfo,
    Key? key,
  }) : super(key: key);

  final KeyboardKeyInfo keyInfo;

  @override
  State<KeyRenderer> createState() => _KeyRendererState();
}

class _KeyRendererState extends State<KeyRenderer> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 60),
      reverseDuration: const Duration(milliseconds: 200),
    );
  }

  String get _keyLabel => _logicalKey.keyLabel;
  Size get _keySize => widget.keyInfo.size;
  AlignmentGeometry get _keyTextAlignment {
    if (_keyLabel.length == 1) {
      return Alignment.center;
    }

    switch (_keyLabel) {
      case 'Tab':
      case 'Caps Lock':
      case 'Shift Left':
      case 'Fn':
        return Alignment.bottomLeft;
      case 'Backspace':
      case 'Enter':
      case 'Shift Right':
        return Alignment.bottomRight;
      default:
        return Alignment.bottomCenter;
    }
  }

  LogicalKeyboardKey get _logicalKey => widget.keyInfo.key;
  String get _text {
    switch (_logicalKey.keyLabel) {
      case 'Backspace':
        return 'delete';
      case 'Tab':
        return 'tab';
      case 'Caps Lock':
        return 'caps lock';
      case 'Enter':
        return 'return';
      case 'Shift Left':
      case 'Shift Right':
        return 'shift';
      case 'Meta Left':
      case 'Meta Right':
        return 'command';
      case 'Fn':
        return 'Fn';
      case 'Control Left':
      case '[RIGHT_CONTROL]':
        return 'control';
      case ' ':
        return '';
      case 'Alt Left':
      case 'Alt Right':
        return 'option';
      default:
        return _logicalKey.keyLabel;
    }
  }

  double get _fontSize {
    if (_keyLabel.length == 1) {
      return 16.0;
    }

    return 13.0;
  }

  void _handleEventChange(BuildContext _, GameState state) {
    final event = state.keyEvent;

    switch (event.runtimeType) {
      case RawKeyDownEvent:
        if (event?.logicalKey == _logicalKey) {
          _animationController.forward().ignore();
        }
        break;
      case Null:
      case RawKeyUpEvent:
        _animationController.reverse().ignore();
        break;
      default:
    }

    if(_keyLabel == ' ' && state.gameStatus == GameStatus.completed) {
      _animationController.repeat(
        reverse: true,
        period: const Duration(milliseconds: 1000),
      ).ignore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GameBloc, GameState>(
      listener: _handleEventChange,
      listenWhen: (GameState previous, GameState current) => previous.keyEvent != current.keyEvent,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (_, __) {
          final color = ColorTween(
            begin: Colors.grey[900]?.withOpacity(0.5),
            end: Colors.blue,
          ).animate(_animationController);

          return Container(
            height: _keySize.height,
            width: _keySize.width,
            padding: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              color: color.value,
              border: Border.all(
                color: Colors.white,
              ),
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: Align(
              alignment: _keyTextAlignment,
              child: Text(
                _text,
                style: TextStyle(fontSize: _fontSize, color: Colors.white),
              ),
            ),
          );
        },
      ),
    );
  }
}
