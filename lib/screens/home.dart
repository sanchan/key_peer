



import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:key_peer/blocs/blocs.dart';
import 'package:key_peer/blocs/cubits/keyboard_cubic.dart';
import 'package:key_peer/keyboards/keyboard_en.dart';
import 'package:key_peer/scoreboard.dart';
import 'package:key_peer/services/system_service.dart';
import 'package:key_peer/settings_drawer.dart';
import 'package:key_peer/typed_text.dart';
import 'package:window_manager/window_manager.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

// ignore: prefer_mixin
class _HomeState extends State<Home> with SingleTickerProviderStateMixin, WindowListener {
  static const _kDrawerWidth = 250.0;

  @override
  void dispose() {
    windowManager.removeListener(this);

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    windowManager.addListener(this);

    _drawerAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    )..value = 0.0;
  }

  @override
  Future<void> onWindowEnterFullScreen() async {
    setState(() {
      _isFullscreen = true;
    });
  }

  @override
  Future<void> onWindowLeaveFullScreen() async {
    setState(() {
      _isFullscreen = false;
    });
  }

  late AnimationController _drawerAnimation;
  final FocusNode _focusMainNode = FocusNode();
  final FocusNode _focusSettingsNode = FocusNode();
  bool _isDrawerOpen = false;
  bool _isFullscreen = false;

  void _handleCloseDrawer() {
    _drawerAnimation.reverse().orCancel;
    _isDrawerOpen = false;
    FocusScope.of(context).requestFocus(_focusMainNode);
  }

  void _handleToggleDrawer() {
    if(_drawerAnimation.isCompleted) {
      _handleCloseDrawer();
    } else {
      _isDrawerOpen = true;
      FocusScope.of(context).requestFocus(_focusSettingsNode);
      _drawerAnimation.forward().orCancel;
    }
  }

  KeyEventResult _onKey(_, RawKeyEvent event) {
    if(!_isDrawerOpen) {
      Blocs.get<KeyboardCubic>().addKeyEvent(event);
    }

    return _isDrawerOpen
      ? KeyEventResult.ignored
      : KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusMainNode,
      onKey: _onKey,
      autofocus: true,
      child: CupertinoPageScaffold(
        backgroundColor: _isFullscreen
          ? CupertinoColors.secondarySystemBackground
          : Colors.transparent,
        child: Stack(
          fit: StackFit.expand,
          children: [
            GestureDetector(
              onTap: _handleCloseDrawer,
              child: BlocBuilder<KeyboardCubic, RawKeyEvent?>(
                builder: (_, __) {
                  return Container(
                    color: Colors.transparent,
                    child: Column(
                      children: const [
                        SizedBox(height: 60.0),
                        Scoreboard(),
                        Spacer(),
                        TypedText(),
                        Spacer(),
                        KeyboardEn(),
                        SizedBox(height: 60.0),
                      ],
                    ),
                  );
                },
              ),
            ),

            AnimatedBuilder(
              animation: _drawerAnimation,
              builder: (_, __) {
                final opacity = Tween<double>(
                  begin: 1.0,
                  end: 0.0,
                ).animate(
                  CurvedAnimation(
                    parent: _drawerAnimation,
                    curve: const Interval(0.0, 0.4, curve: Curves.fastOutSlowIn),
                  ),
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
              },
            ),

            AnimatedBuilder(
              animation: _drawerAnimation,
              builder: (_, __) {
                final offset = Tween<Offset>(
                  begin: const Offset(0,0),
                  end: const Offset(_kDrawerWidth, 0),
                ).animate(
                  CurvedAnimation(
                    parent: _drawerAnimation,
                    curve: const Interval(0.4, 1.0),
                  ),
                );

                return Positioned(
                  right: -_kDrawerWidth + offset.value.dx,
                  height: MediaQuery.of(context).size.height,
                  child: const SettingsDrawer(),
                );
              },
            ),

            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: SystemService.confettiController,
                blastDirection: pi / 2,
                blastDirectionality: BlastDirectionality.explosive,
                minBlastForce: 50,
                maxBlastForce: 100,
                emissionFrequency: 0.01,
                numberOfParticles: 50,
                gravity: 0.7,
              ),
            ),
          ],
        ),
      ),
    );
  }
}