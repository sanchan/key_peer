
import 'package:flutter/material.dart';
import 'package:key_peer/keyboards/keyboard_en.dart';
import 'package:key_peer/typed_text.dart';
import 'package:key_peer/utils/key_event_controller.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final KeyEventController _keyEventController = KeyEventController();

  @override
  Widget build(BuildContext context) {
    return Focus(
      onKey: (FocusNode node, RawKeyEvent event) {
        _keyEventController.addEvent(event);

        return KeyEventResult.handled;
      },
      autofocus: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: AnimatedBuilder(
          animation: _keyEventController,
          builder: (BuildContext context, Widget? child) {
            return Container(
              color: Colors.transparent,
              child: Column(
                children: [
                  // Text(_keyEventController.fullText),
                  TypedText(keyEventController: _keyEventController),
                  const SizedBox(height: 16.0),
                  const Spacer(),
                  KeyboardEn(keyEventController: _keyEventController),
                ],
              ),
            );
          }
        ),
      )
    );
  }
}