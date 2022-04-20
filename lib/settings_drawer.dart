import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:key_peer/services/lesson_config.dart';
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
  ValueNotifier<LessonConfig?> get _currentLesson => SystemService.currentLesson;

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
      id: 6,
      characters: ['\'', 'j', 'x', 'q', 'z']
    ),
  ];

  void _changeLesson(LessonConfig lessonConfig) {
    SystemService.currentLesson.value = lessonConfig;
    SystemService.generateTargetText(lessonConfig.characters);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MacosColors.alternatingContentBackgroundColor,
        border: Border(
          left: BorderSide(width: 1, color: lighten(MacosColors.alternatingContentBackgroundColor, 0.05)),
        )
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 16.0,
      ),
      width: 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SettingsBlockTitle(title: 'Lessons'),
          ValueListenableBuilder(
            valueListenable: _currentLesson,
            builder: (_, LessonConfig? currentLesson, __) {
              return _SettingsBlock(
                children: _lessons.asMap().entries.map((lesson) {
                  return GestureDetector(
                    onTap: () => _changeLesson(lesson.value),
                    child: _SettingsBlockItem(
                      isFirst: lesson.key == 0,
                      isLast: lesson.key == _lessons.length - 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Lesson ${lesson.key + 1}: ${lesson.value.characters.join(' ')}'),
                          if(currentLesson?.id == lesson.value.id)
                          const MacosIcon(CupertinoIcons.check_mark, size: 16,)
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),

          const _SettingsBlockTitle(title: 'Text modifiers'),
          _SettingsBlock(
            children: [
              _SettingsBlockItem(
                isFirst: true,
                isLast: false,
                child: _SettingsCheckboxItem(
                  label: 'Capital letters',
                  notifier: SystemService.useCapitalLetters,
                ),
              )
            ]
          )
        ],
      ),
    );
  }
}

class _SettingsBlockTitle extends StatelessWidget {
  const _SettingsBlockTitle({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      child: Text(
        title.toUpperCase(),
        style: MacosTheme.of(context).typography.body.copyWith(color: Colors.grey[400])
      ),
    );
  }
}

class _SettingsBlock extends StatelessWidget {
  const _SettingsBlock({
    Key? key,
    required this.children,
  }) : super(key: key);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
        color: darken(MacosColors.alternatingContentBackgroundColor, 0.02),
        border: Border(
          top: BorderSide(width: 1, color: lighten(MacosColors.alternatingContentBackgroundColor, 0.05)),
          bottom: BorderSide(width: 1, color: lighten(MacosColors.alternatingContentBackgroundColor, 0.05)),
        )
      ),
      child: ListView(
        shrinkWrap: true,
        children: children,
      ),
    );
  }
}

class _SettingsBlockItem extends StatelessWidget {
  const _SettingsBlockItem({
    Key? key,
    required this.isFirst,
    required this.isLast,
    required this.child,
  }) : super(key: key);

  final bool isFirst;
  final bool isLast;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      decoration: BoxDecoration(
        border: Border(
          top: isFirst
            ? BorderSide.none
            : BorderSide(width: 0.5, color: darken(MacosColors.alternatingContentBackgroundColor, 0.05)),
          bottom: isLast
            ? BorderSide.none
            : BorderSide(width: 0.5, color: lighten(MacosColors.alternatingContentBackgroundColor, 0.05)),
        )
      ),
      child: child,
    );
  }
}

class _SettingsCheckboxItem extends StatelessWidget {
  const _SettingsCheckboxItem({
    Key? key,
    required this.label,
    required this.notifier,
  }) : super(key: key);

  final String label;
  final ValueNotifier<bool> notifier;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: notifier,
      builder: (_, bool value, __) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            MacosSwitch(
              value: value,
              onChanged: (_) {
                notifier.value = !value;
              }
            )
          ],
        );
      },
    );
  }
}