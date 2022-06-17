import 'package:flutter/material.dart';


@Deprecated('Delete me, using Blocs')
class KeyEventController extends ChangeNotifier {
  RawKeyEvent? event;

  void addEvent(RawKeyEvent event) {
    this.event = event;

    notifyListeners();
  }
}
