import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:key_peer/blocs/cubits/keyboard_cubic.dart';
import 'package:key_peer/utils/keyboard_config/keyboard_key_info.dart';

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
  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..value = 1.0;
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

  double get fontSize {
    if (_keyLabel.length == 1) {
      return 16.0;
    }

    return 13.0;
  }

  late AnimationController _animationController;

  void _handleEventChange(BuildContext _, RawKeyEvent? event) {
    if (event?.logicalKey == _logicalKey) {
      if (event is RawKeyDownEvent) {
        _animationController.reset();
      } else if (event is RawKeyUpEvent) {
        _animationController.forward().orCancel;
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return BlocListener<KeyboardCubic, RawKeyEvent?>(
      listener: _handleEventChange,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (_, __) {
          final color = ColorTween(
            begin: Colors.blue,
            end: Colors.grey[900]?.withOpacity(0.5),
            // end: Colors.transparent
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
                style: TextStyle(fontSize: fontSize, color: Colors.white),
              ),
            ),
          );
        },
      ),
    );
  }
}
