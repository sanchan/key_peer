import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:key_peer/keyboards/keyboard_en.dart';
import 'package:key_peer/utils/key_event_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      child: AnimatedBuilder(
        animation: _keyEventController,
        builder: (BuildContext context, Widget? child) {
          return Container(
            color: Colors.transparent,
            child: Column(
              children: [
                // Text(_keyEventController.fullText),
                const SizedBox(height: 26.0),
                Center(child: Text(_keyEventController.lastChar ?? '')),
                KeyboardEn(keyEventController: _keyEventController),
              ],
            ),
          );
        }
      )
    );
  }
}