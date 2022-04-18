import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KeyEventController extends ChangeNotifier {
  RawKeyEvent? event;
  String? _lastChar;
  String _fullText = '';

  String? get lastChar => _lastChar;
  String get fullText => _fullText;

  void addEvent(RawKeyEvent event) {
    this.event = event;

    if(event.character != null) {
      _lastChar = event.character;
    }

    if(event.logicalKey == LogicalKeyboardKey.backspace && _fullText.isNotEmpty) {
      _fullText = _fullText.substring(0, _fullText.length - 1);
    } else {
      if(event.character != null) {
        _fullText += event.character!;
      }
    }

    notifyListeners();
  }
}