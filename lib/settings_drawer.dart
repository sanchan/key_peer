import 'package:flutter/material.dart';
import 'package:key_peer/services/system.dart';
import 'package:key_peer/utils/colors.dart';
import 'package:macos_ui/macos_ui.dart';

class SettingsDrawer extends StatefulWidget {
  const SettingsDrawer({
    Key? key,
  }) : super(key: key);

  @override
  State<SettingsDrawer> createState() => _SettingsDrawerState();
}

class _SettingsDrawerState extends State<SettingsDrawer> {
  final List<LessonConfig> _lessons = [
    const LessonConfig(
      id: 1,
      characters: ['e', 't', 'a', 'o']
    ),
    const LessonConfig(
      id: 2,
      characters: ['n', 'i', 'h', 's', 'r']
    ),
    const LessonConfig(
      id: 3,
      characters: ['d', 'l', 'u', 'm']
    ),
    const LessonConfig(
      id: 4,
      characters: ['w', 'c', 'g', 'f']
    ),
    const LessonConfig(
      id: 5,
      characters: ['y', 'p', 'b', 'v', 'k']
    ),
    const LessonConfig(
      id: 5,
      characters: ['\'', 'j', 'x', 'q', 'z']
    ),
  ];

  void _changeLesson(LessonConfig lessonConfig) {
    SystemService.generateTargetText(lessonConfig.characters);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: MacosColors.alternatingContentBackgroundColor,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 16.0,
      ),
      width: 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            child: Text(
              'LESSONS',
              style: MacosTheme.of(context).typography.body.copyWith(color: Colors.grey[400])
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16.0),
            decoration: BoxDecoration(
              color: darken(MacosColors.alternatingContentBackgroundColor, 0.02),
              border: Border(
                top: BorderSide(width: 1, color: lighten(MacosColors.alternatingContentBackgroundColor, 0.05)),
                bottom: BorderSide(width: 1, color: lighten(MacosColors.alternatingContentBackgroundColor, 0.05)),
              )
            ),
            height: 200,
            child: ListView(
              children: _lessons.asMap().entries.map((lesson) {
                return GestureDetector(
                  onTap: () => _changeLesson(lesson.value),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                    ),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: lesson.key != _lessons.length -1
                          ? BorderSide(width: 0.5, color: lighten(MacosColors.alternatingContentBackgroundColor, 0.05))
                          : BorderSide.none,
                        top: lesson.key != 0
                          ? BorderSide(width: 0.5, color: darken(MacosColors.alternatingContentBackgroundColor, 0.05))
                          : BorderSide.none
                      )
                    ),
                    child: Text(
                      'Lesson ${lesson.key + 1}: ${lesson.value.characters.join(' ')}'
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class LessonConfig {
  const LessonConfig({
    required this.id,
    required this.characters
  });

  final List<String> characters;
  final int id;
}