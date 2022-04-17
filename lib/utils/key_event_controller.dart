import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KeyEventController extends ChangeNotifier {
  String? _lastChar;
  String _fullText = '';

  String? get lastChar => _lastChar;
  String get fullText => _fullText;

  void addEvent(RawKeyEvent event) {
    bool shouldNotify = false;

    if(event.character != null) {
      _lastChar = event.character;
      shouldNotify = true;
    }

    if(event.logicalKey == LogicalKeyboardKey.backspace && _fullText.isNotEmpty) {
      _fullText = _fullText.substring(0, _fullText.length - 1);
      shouldNotify = true;
    } else {
      if(event.character != null) {
        _fullText += event.character!;
        shouldNotify = true;
      }
    }

    if(shouldNotify) {
      notifyListeners();
    }
  }
}