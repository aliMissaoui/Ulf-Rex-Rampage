import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:trex/game/game.dart';

void main() async {
  Flame.device.fullScreen();
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setOrientation(DeviceOrientation.landscapeLeft);
  runApp(
    MaterialApp(
      title: 'TRexGame',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: TRexGameWrapper(),
      ),
    ),
  );
}

class TRexGameWrapper extends StatefulWidget {
  @override
  _TRexGameWrapperState createState() => _TRexGameWrapperState();
}

class _TRexGameWrapperState extends State<TRexGameWrapper> {
  bool splashGone = false;
  TRexGame? game;
  final _focusNode = FocusNode();

  bool _isLandscape = false;

  void _toggleOrientation() {
    setState(() {
      _isLandscape = !_isLandscape;
      if (_isLandscape) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      } else {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    Flame.images.loadAll(["sprite.png"]).then(
      (image) => {
        setState(() {
          game = TRexGame(spriteImage: image[0]);
          _focusNode.requestFocus();
        })
      },
    );
  }

  void onRawKeyEvent(RawKeyEvent event) {
    if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.space) {
      game!.onAction();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (game == null) {
      return const Center(
        child: Text("Loading"),
      );
    }
    return Container(
      color: Colors.white,
      constraints: const BoxConstraints.expand(),
      child: Column(
        children: [
          GestureDetector(
              onTap: _toggleOrientation,
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.asset(
                    _isLandscape
                        ? 'assets/portrait.png'
                        : 'assets/landscape.png',
                    height: 48,
                  ),
                ),
              )),
          Expanded(
            child: RawKeyboardListener(
              focusNode: _focusNode,
              onKey: onRawKeyEvent,
              child: GameWidget(
                game: game!,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
