import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

class SettingsDrawer extends StatefulWidget {
  const SettingsDrawer({
    Key? key,
    required this.focusNode
  }) : super(key: key);

  final FocusNode focusNode;

  @override
  State<SettingsDrawer> createState() => _SettingsDrawerState();
}

class _SettingsDrawerState extends State<SettingsDrawer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: MacosColors.alternatingContentBackgroundColor,
      padding: const EdgeInsets.all(8.0),
      width: 300,
      child: Column(
        children: [
          const SizedBox(
            height: 45,
            child: Center(child: Text('Settings',))
          ),
          const Divider(height: 1.0, color: Color.fromARGB(255, 135, 137, 141)),
          CupertinoTextField(
            decoration: const BoxDecoration(
              color: Colors.transparent,
              // border: Border.all(width: 1.0, color: const Color.fromARGB(255, 135, 137, 141))
            ),
            focusNode: widget.focusNode,
            maxLines: 10,
            onChanged: (text) {
              print(text);
            },
          ),
          const Divider(height: 1.0, color: Color.fromARGB(255, 135, 137, 141)),
          CupertinoButton.filled(
            onPressed: () {

            },
            child: const Text('Save'),
          )
        ],
      ),
    );
  }
}