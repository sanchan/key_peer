import 'package:flutter/services.dart';
import 'package:key_peer/utils/keyboard_config/keyboard_config.dart';

class KeyboardConfigEn extends KeyboardConfig {
  KeyboardConfigEn() : super(
    keyLabels: const [
      ['`', '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '-', '=', 'Backspace'],
      ['Tab', 'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p', '[', ']', '\\'],
      ['Caps Lock', 'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', ';', '\'', 'Enter'],
      ['Shift Left', 'z', 'x', 'c', 'v', 'b', 'n', 'm', ',', '.', '/', 'Shift Right'],
      ['Fn', 'Control Left', 'Alt Left', 'Meta Left', ' ', 'Meta Right', 'Alt Right', '[___]']
    ],
    logicals: const {
      'Backspace': LogicalKeyboardKey.backspace,
      'Tab': LogicalKeyboardKey.tab,
      'Caps Lock': LogicalKeyboardKey.capsLock,
      'Enter': LogicalKeyboardKey.enter,
      'Shift Left': LogicalKeyboardKey.shiftLeft,
      'Shift Right': LogicalKeyboardKey.shiftRight,

      'Meta Left': LogicalKeyboardKey.metaLeft,
      ' ': LogicalKeyboardKey.space,
      'Meta Right': LogicalKeyboardKey.metaRight,
    },
    customWidths: const {
      'Backspace': 1.5,
      'Tab': 1.5,
      'Caps Lock': 1.84,
      'Enter': 1.84,
      'Shift Left': 2.4,
      'Shift Right': 2.4,

      'Meta Left': 1.25,
      ' ': 6.15,
      'Meta Right': 1.25,
      '[___]': 3,
    }
  );
}