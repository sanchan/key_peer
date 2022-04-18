
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:key_peer/keyboards/keyboard_en.dart';
import 'package:key_peer/settings_drawer.dart';
import 'package:key_peer/typed_text.dart';
import 'package:key_peer/utils/key_event_controller.dart';
import 'package:macos_ui/macos_ui.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final FocusNode _focusMainNode = FocusNode();
  final FocusNode _focusSettingsNode = FocusNode();
  final KeyEventController _keyEventController = KeyEventController();
  late AnimationController _drawerAnimation;
  bool isDrawerOpen = false;

  @override
  void initState() {
    super.initState();

    _drawerAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150)
    )..value = 0.0;
  }

  void _handleToggleDrawer() {
    if(_drawerAnimation.isCompleted) {
      _handleCloseDrawer();
    } else {
      isDrawerOpen = true;
      FocusScope.of(context).requestFocus(_focusSettingsNode);
      _drawerAnimation.forward();
    }
  }

  void _handleCloseDrawer() {
    _drawerAnimation.reverse();
    isDrawerOpen = false;
    FocusScope.of(context).requestFocus(_focusMainNode);
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusMainNode,
      onKey: (_, RawKeyEvent event) {
        if(!isDrawerOpen) {
          _keyEventController.addEvent(event);
        }

        print('isDrawerOpen $isDrawerOpen');

        return isDrawerOpen
          ? KeyEventResult.ignored
          : KeyEventResult.handled;
      },
      autofocus: true,
      child: CupertinoPageScaffold(
        backgroundColor: Colors.transparent,
        child: Stack(
          fit: StackFit.expand,
          children: [
            GestureDetector(
              onTap: _handleCloseDrawer,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: AnimatedBuilder(
                  animation: _keyEventController,
                  builder: (BuildContext context, Widget? child) {
                    return Container(
                      color: Colors.transparent,
                      child: Column(
                        children: [
                          TypedText(keyEventController: _keyEventController),
                          const SizedBox(height: 16.0),
                          const Spacer(),
                          KeyboardEn(keyEventController: _keyEventController),
                        ],
                      ),
                    );
                  }
                ),
              ),
            ),
            AnimatedBuilder(
              animation: _drawerAnimation,
              builder: (_, __) {
                final offset = Tween<Offset>(
                  begin: const Offset(0,0),
                  end: const Offset(300, 0)
                ).animate(_drawerAnimation);

                return Positioned(
                  right: -300 + offset.value.dx,
                  height: MediaQuery.of(context).size.height,
                  child: SettingsDrawer(
                    focusNode: _focusSettingsNode
                  )
                );
              }
            ),

            AnimatedBuilder(
              animation: _drawerAnimation,
              builder: (_, __) {
                final offset = Tween<Offset>(
                  begin: const Offset(0,0),
                  end: const Offset(300, 0)
                ).animate(_drawerAnimation);

                final backgroundOpacity = Tween<double>(
                  begin: 0,
                  end: 1
                ).animate(_drawerAnimation);

                return Positioned(
                  right: max(16 + offset.value.dx - 60, 16),
                  top: 16,
                  child: GestureDetector(
                    onTap: _handleToggleDrawer,
                    child: Container(
                      color: MacosColors.alternatingContentBackgroundColor.withOpacity(backgroundOpacity.value),
                      padding: const EdgeInsets.all(5),
                      child: const Icon(
                        CupertinoIcons.settings,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              }
            ),
          ],
        ),
      )
    );
  }
}