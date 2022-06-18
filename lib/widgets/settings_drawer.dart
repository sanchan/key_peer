import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:key_peer/bloc/blocs.dart';
import 'package:key_peer/bloc/cubits/game_settings_cubit.dart';
import 'package:key_peer/models/text_generator.dart';
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
  final List _lessons = [];

  void _handleChangeCapitalLetters(bool value) {
    Blocs.get<GameSettingsCubit>().setUseCapitalLetters(value: value);
  }

  // final List<LessonConfig> _lessons = [
  //   const LessonConfig(
  //     id: 1,
  //     characters: ['e', 't', 'a', 'o'],
  //   ),
  //   const LessonConfig(
  //     id: 2,
  //     characters: ['n', 'i', 'h', 's', 'r'],
  //   ),
  //   const LessonConfig(
  //     id: 3,
  //     characters: ['d', 'l', 'u', 'm'],
  //   ),
  //   const LessonConfig(
  //     id: 4,
  //     characters: ['w', 'c', 'g', 'f'],
  //   ),
  //   const LessonConfig(
  //     id: 5,
  //     characters: ['y', 'p', 'b', 'v', 'k'],
  //   ),
  //   const LessonConfig(
  //     id: 6,
  //     characters: ["'", 'j', 'x', 'q', 'z'],
  //   ),
  // ];

  void _handleChangeCharacters(List<String> characters) {
    Blocs.get<GameSettingsCubit>().setTextGeneratorCharacters(characters);
  }

  void _handleChangeNumbers(bool value) {
    Blocs.get<GameSettingsCubit>().setUseNumbers(value: value);
  }

  void _handleChangePunctuation(bool value) {
    Blocs.get<GameSettingsCubit>().setUsePunctuation(value: value);
  }

  void _handleChangeTextLength(int? length) {
    if(length == null) {
      return;
    }

    Blocs.get<GameSettingsCubit>().setTextMaxLength(length);
  }

  void _handleChangeUseRepeatLetters(bool value) {
    Blocs.get<GameSettingsCubit>().setUseRepeatLetters(value: value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MacosColors.alternatingContentBackgroundColor,
        border: Border(
          left: BorderSide(color: lighten(MacosColors.alternatingContentBackgroundColor, 0.05)),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 16.0,
      ),
      width: 250,
      child: SingleChildScrollView(
        child: BlocSelector<GameSettingsCubit, GameSettings, TextGeneratorSettings>(
          selector: (state) => state.textGeneratorSettings,
          builder: (_, TextGeneratorSettings settings) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SettingsBlockTitle(title: 'Lessons'),
                _SettingsBlock(
                  children: _lessons.asMap().entries.map((lesson) {
                    return GestureDetector(
                      onTap: () => _handleChangeCharacters(lesson.value),
                      child: _SettingsBlockItem(
                        isFirst: lesson.key == 0,
                        isLast: lesson.key == _lessons.length - 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Lesson ${lesson.key + 1}: ${lesson.value.characters.join(' ')}'),
                            // if(settings.currentLesson?.id == lesson.value.id)
                            const MacosIcon(CupertinoIcons.check_mark, size: 16,),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const _SettingsBlockTitle(title: 'Text modifiers'),
                _SettingsBlock(
                  children: [
                    _SettingsBlockItem(
                      isFirst: true,
                      isLast: false,
                      child: _SettingsSwitchItem(
                        label: 'Capital letters',
                        value: settings.useCapitalLetters,
                        onChanged: _handleChangeCapitalLetters,
                      ),
                    ),
                    _SettingsBlockItem(
                      isFirst: false,
                      isLast: false,
                      child: _SettingsSwitchItem(
                        label: 'Numbers',
                        value: settings.useNumbers,
                        onChanged: _handleChangeNumbers,
                      ),
                    ),
                    _SettingsBlockItem(
                      isFirst: false,
                      isLast: false,
                      child: _SettingsSwitchItem(
                        label: 'Punctuation',
                        value: settings.usePunctuation,
                        onChanged: _handleChangePunctuation,
                      ),
                    ),
                    _SettingsBlockItem(
                      isFirst: false,
                      isLast: false,
                      child: _SettingsSwitchItem(
                        label: 'Repeat letters',
                        value: settings.useRepeatLetters,
                        onChanged: _handleChangeUseRepeatLetters,
                      ),
                    ),
                    _SettingsBlockItem(
                      isFirst: false,
                      isLast: true,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Text length'),
                          MacosPopupButton<int>(
                            value: settings.textMaxLength,
                            onChanged: _handleChangeTextLength,
                            items: <int>[70, 40, 25]
                              .map<MacosPopupMenuItem<int>>((int value) {
                                return MacosPopupMenuItem<int>(
                                  value: value,
                                  child: Text('$value'),
                                );
                              }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
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
        style: MacosTheme.of(context).typography.body.copyWith(color: Colors.grey[400]),
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
          top: BorderSide(color: lighten(MacosColors.alternatingContentBackgroundColor, 0.05)),
          bottom: BorderSide(color: lighten(MacosColors.alternatingContentBackgroundColor, 0.05)),
        ),
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

  final Widget child;
  final bool isFirst;
  final bool isLast;

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
        ),
      ),
      child: child,
    );
  }
}

class _SettingsSwitchItem extends StatelessWidget {
  const _SettingsSwitchItem({
    Key? key,
    required this.label,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  final String label;
  final Function(bool) onChanged;
  final bool value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        MacosSwitch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
