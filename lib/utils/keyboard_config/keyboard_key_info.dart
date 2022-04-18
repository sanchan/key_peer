import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KeyboardKeyInfo {
  const KeyboardKeyInfo({
    required this.regular,
    required this.size,
    this.logicalKey,
  });

  final String regular;
  final Size size;
  final LogicalKeyboardKey? logicalKey;
}