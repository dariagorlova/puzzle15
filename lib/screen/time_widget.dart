import 'dart:async';

import 'package:flutter/material.dart';
import 'package:puzzle15/main.dart';

class TimerWidget extends StatefulWidget {
  const TimerWidget({Key? key}) : super(key: key);

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  Timer? timer;
  void startTimer({bool reset = true}) {
    if (reset) {
      puzzleLogic.seconds = 0;
    }

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => puzzleLogic.seconds++);
    });
  }

  void stopTimer({bool reset = true}) {
    if (reset) {
      puzzleLogic.seconds = 0;
    }
    timer?.cancel();
  }

  void pause() {
    if (!(timer == null) && timer!.isActive) {
      stopTimer(reset: false);
    }
  }

  void resume() {
    if (!(timer == null) && !timer!.isActive) {
      startTimer(reset: false);
    }
  }

  @override
  void initState() {
    super.initState();
    puzzleLogic.launchTimer = startTimer;
    puzzleLogic.stopTimer = stopTimer;
    puzzleLogic.pauseTimer = pause;
    puzzleLogic.resumeTimer = resume;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.alarm,
          size: 32,
          color: Theme.of(context).primaryColor,
        ),
        Text(
          puzzleLogic.getDuration(puzzleLogic.seconds),
        ),
      ],
    );
  }
}
