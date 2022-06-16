import 'package:flutter/material.dart';

class KeyEventController extends ChangeNotifier {
  RawKeyEvent? event;

  void addEvent(RawKeyEvent event) {
    this.event = event;

    notifyListeners();
  }
}
