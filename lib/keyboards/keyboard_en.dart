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
  final KeyboardConfigEn _keyboardConfig = const KeyboardConfigEn();
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

    final List<String> keys = _keyboardConfig.regulars.expand((e) => e).toList();
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
                  animation: _animations[key.regular]!,
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

  String get regularKey => keyInfo.regular;
  Size get keySize => keyInfo.size;

  String get text {
    if(regularKey.length == 1) {
      return regularKey;
    }

    switch (regularKey) {
      case '[BACKSPACE]':
        return 'delete';
      case '[TAB]':
        return 'tab';
      case '[CAPS]':
        return 'caps lock';
      case '[RETURN]':
        return 'return';
      case '[LEFT_SHIFT]':
      case '[RIGHT_SHIFT]':
        return 'shift';
      case '[LEFT_CMD]':
      case '[RIGHT_CMD]':
        return 'command';
      case '[FN]':
        return 'fn';
      case '[LEFT_CONTROL]':
      case '[RIGHT_CONTROL]':
        return 'control';
      case '[SPACE]':
        return '';
      case '[LEFT_OPTION]':
      case '[RIGHT_OPTION]':
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
      case '[TAB]':
      case '[CAPS]':
      case '[LEFT_SHIFT]':
      case '[FN]':
        return Alignment.bottomLeft;
      case '[BACKSPACE]':
      case '[RETURN]':
      case '[RIGHT_SHIFT]':
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