import 'package:flutter/material.dart';
import 'package:key_peer/utils/key_event_controller.dart';
import 'package:key_peer/utils/keyboard_config/en.dart';
import 'package:key_peer/utils/keyboard_config/keyboard_key_info.dart';

class KeyboardEn extends StatefulWidget {
  const KeyboardEn({
    Key? key,
    required this.keyEventController,
  }) : super(key: key);

  final KeyEventController keyEventController;

  @override
  State<KeyboardEn> createState() => _KeyboardEnState();
}

class _KeyboardEnState extends State<KeyboardEn> with TickerProviderStateMixin {
  final KeyboardConfigEn _keyboardConfig = KeyboardConfigEn();
  final Map<String, AnimationController> _animations = {};

  @override
  void dispose() {
    super.dispose();

    _eventController.removeListener(handleEventChange);
  }

  @override
  void initState() {
    super.initState();

    _eventController.addListener(handleEventChange);

    final List<String> keys = _keyboardConfig.keyLabels.expand((e) => e).toList();
    for (var key in keys) {
      _animations[key] = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 200)
      )..value = 1.0;
    }
  }

  void handleEventChange() {
    final animation = _animations[_eventController.lastChar];

    if(animation != null) {
      animation
        ..reset()
        ..forward();
    }
  }

  KeyEventController get _eventController => widget.keyEventController;

  @override
  Widget build(BuildContext context) {

    return Column(
      children: _keyboardConfig.keys.map((row) =>
        Padding(
          padding: EdgeInsets.symmetric(vertical: _keyboardConfig.keySpacing/1.5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: row.map((key) => 
              Padding(
                padding: EdgeInsets.symmetric(horizontal: _keyboardConfig.keySpacing),
                child: KeyRenderer(
                  keyInfo: key,
                  animation: _animations[key.keyLabel]!,
                ),
              )
            ).toList(),
          ),
        )
      ).toList(),
    );
  }
}

class KeyRenderer extends StatelessWidget {
  final KeyboardKeyInfo keyInfo;
  final Animation<double> animation;

  const KeyRenderer({
    required this.keyInfo,
    required this.animation,
    Key? key
  }) : super(key: key);

  String get regularKey => keyInfo.keyLabel;
  Size get keySize => keyInfo.size;

  String get text {
    if(regularKey.length == 1) {
      return regularKey;
    }

    switch (regularKey) {
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
        return '';
    }
  }

  AlignmentGeometry get keyTextAlignment {
    if(regularKey.length == 1) {
      return Alignment.center;
    }

    switch (regularKey) {
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

  double get fontSize {
    if(regularKey.length == 1) {
      return 16.0;
    }

    return 13.0;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (_, __) {
        final color = ColorTween(
          begin: Colors.blue,
          end: Colors.black
        ).animate(animation);

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
              style: TextStyle(fontSize: fontSize),
            ),
          ),
        );
      },
    );
  }
}