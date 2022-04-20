import 'package:key_peer/services/lesson_config.dart';

class Settings {
  Settings({
    this.currentLesson,
    this.repeatLetter = false,
    this.useCapitalLetters = false,
    this.useNumbers = false,
    this.usePunctuation = false,
    this.textLength = 25,
    this.maxErrors = 10,
  });

  LessonConfig? currentLesson;
  int maxErrors;
  int textLength;
  bool repeatLetter;
  bool useCapitalLetters;
  bool useNumbers;
  bool usePunctuation;

  Settings clone() => Settings(
    currentLesson: currentLesson,
    repeatLetter: repeatLetter,
    useCapitalLetters: useCapitalLetters,
    useNumbers: useNumbers,
    usePunctuation: usePunctuation,
    textLength: textLength,
    maxErrors: maxErrors,
  );
}