import 'package:flutter/material.dart';
import 'package:key_peer/utils/key_event_controller.dart';
import 'package:key_peer/utils/keyboard_config/en.dart';

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
  Map<String, AnimationController> _animations = {};

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
      children: _keyboardConfig.regulars.map((row) =>
        Padding(
          padding: EdgeInsets.symmetric(vertical: _keyboardConfig.keySpacing / 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: row.map((key) => 
              Padding(
                padding: EdgeInsets.symmetric(horizontal: _keyboardConfig.keySpacing),
                child: KeyRenderer(
                  animation: _animations[key]!,
                  keyboardConfig: _keyboardConfig,
                  regularKey: key,
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
  final Animation<double> animation;
  final KeyboardConfigEn keyboardConfig;
  final String regularKey;

  const KeyRenderer({
    required this.animation,
    required this.keyboardConfig,
    required this.regularKey,
    Key? key
  }) : super(key: key);

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
          height: keyboardConfig.sizeOf(regularKey).height,
          width: keyboardConfig.sizeOf(regularKey).width,
          decoration: BoxDecoration(
            color: color.value,
            border: Border.all(
              color: Colors.white,
            ),
            borderRadius: BorderRadius.circular(6.0)
          ),
          child: Text(regularKey),
        );
      },
    );
  }
}