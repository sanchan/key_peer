import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KeyboardKeyInfo {
  const KeyboardKeyInfo({
    required this.size,
    required this.logicalKey,
  });

  final Size size;
  final LogicalKeyboardKey logicalKey;
}