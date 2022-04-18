import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KeyboardKeyInfo {
  const KeyboardKeyInfo({
    required this.keyLabel,
    required this.size,
    this.logicalKey,
  });

  final String keyLabel;
  final Size size;
  final LogicalKeyboardKey? logicalKey;
}