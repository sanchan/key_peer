

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:key_peer/keyboards/keyboard_en.dart';
import 'package:key_peer/settings_drawer.dart';
import 'package:key_peer/typed_text.dart';
import 'package:key_peer/utils/key_event_controller.dart';

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
      duration: const Duration(milliseconds: 250)
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
                final opacity = Tween<double>(
                  begin: 1.0,
                  end: 0.0
                ).animate(
                  CurvedAnimation(
                    parent: _drawerAnimation,
                    curve: const Interval(0.0, 0.4, curve: Curves.fastOutSlowIn)
                  )
                );

                return Positioned(
                  right: 16,
                  top: 16,
                  child: GestureDetector(
                    onTap: _handleToggleDrawer,
                    behavior: HitTestBehavior.translucent,
                    child: Opacity(
                      opacity: opacity.value,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        child: const Icon(
                          CupertinoIcons.settings,
                          color: CupertinoColors.white,
                        ),
                      ),
                    ),
                  ),
                );
              }
            ),

            AnimatedBuilder(
              animation: _drawerAnimation,
              builder: (_, __) {
                final offset = Tween<Offset>(
                  begin: const Offset(0,0),
                  end: const Offset(250, 0)
                ).animate(
                  CurvedAnimation(
                    parent: _drawerAnimation,
                    curve: const Interval(0.4, 1.0, curve: Curves.linear)
                  )
                );

                return Positioned(
                  right: -250 + offset.value.dx,
                  height: MediaQuery.of(context).size.height,
                  child: const SettingsDrawer()
                );
              }
            ),
          ],
        ),
      )
    );
  }
}