import 'package:key_peer/state/models/keyboard_config.dart';
import 'package:key_peer/state/models/lesson_config.dart';
import 'package:key_peer/state/models/text_generator.dart';

class GameSettings {
  GameSettings({
    required this.textGenerator,
    required this.keyboardConfig,
    this.currentLesson,
    this.repeatLetter = false,
    this.useCapitalLetters = false,
    this.useNumbers = false,
    this.usePunctuation = false,
    this.textLength = 25,
    this.maxErrors = 10,
  });

  TextGenerator textGenerator;
  KeyboardConfig keyboardConfig;
  LessonConfig? currentLesson;
  int maxErrors;
  bool repeatLetter;
  int textLength;
  bool useCapitalLetters;
  bool useNumbers;
  bool usePunctuation;

  // GameSettings clone() => GameSettings(
  //   textGenerator: textGenerator,
  //   currentLesson: currentLesson,
  //   repeatLetter: repeatLetter,
  //   useCapitalLetters: useCapitalLetters,
  //   useNumbers: useNumbers,
  //   usePunctuation: usePunctuation,
  //   textLength: textLength,
  //   maxErrors: maxErrors,
  // );
}
