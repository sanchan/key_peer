import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:key_peer/utils/key_event_controller.dart';
import 'package:key_peer/utils/keyboard_config/keyboard_key_info.dart';

class KeyRenderer extends StatefulWidget {
  const KeyRenderer({
    required this.keyInfo,
    required this.eventController,
    Key? key
  }) : super(key: key);

  final KeyEventController eventController;
  final KeyboardKeyInfo keyInfo;

  @override
  State<KeyRenderer> createState() => _KeyRendererState();
}

class _KeyRendererState extends State<KeyRenderer> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void dispose() {
    super.dispose();

    widget.eventController.removeListener(handleEventChange);
  }

  @override
  void initState() {
    super.initState();

    widget.eventController.addListener(handleEventChange);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200)
    )..value = 1.0;
  }

  LogicalKeyboardKey get logicalKey => widget.keyInfo.logicalKey;
  String get keyLabel => logicalKey.keyLabel;

  double get fontSize {
    if(keyLabel.length == 1) {
      return 16.0;
    }

    return 13.0;
  }

  Size get keySize => widget.keyInfo.size;
  AlignmentGeometry get keyTextAlignment {
    if(keyLabel.length == 1) {
      return Alignment.center;
    }

    switch (keyLabel) {
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

  String get text {

    switch (logicalKey.keyLabel) {
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
        return logicalKey.keyLabel.toLowerCase();
    }
  }

  void handleEventChange() {
    final event = widget.eventController.event;

    if(event?.logicalKey == logicalKey) {
      if(event is RawKeyDownEvent) {
        _animationController.reset();
      } else if (event is RawKeyUpEvent) {
        _animationController.forward();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (_, __) {
        final color = ColorTween(
          begin: Colors.blue,
          end: Colors.grey[900]!.withOpacity(0.5)
          // end: Colors.transparent
        ).animate(_animationController);

        return Container(
          height: keySize.height,
          width: keySize.width,
          padding: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: color.value,
            border: Border.all(
              color: Colors.white,
            ),
            borderRadius: BorderRadius.circular(6.0)
          ),
          child: Align(
            alignment: keyTextAlignment,
            child: Text(
              text,
              style: TextStyle(fontSize: fontSize, color: Colors.white),
            ),
          ),
        );
      },
    );
  }
}