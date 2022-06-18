import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

@immutable
class KeyboardKeyInfo {
  const KeyboardKeyInfo({
    required this.key,
    required this.altKey,
    required this.size,
  });

  final LogicalKeyboardKey altKey;
  final LogicalKeyboardKey key;
  final Size size;
}
