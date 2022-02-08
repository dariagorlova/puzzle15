import 'package:flutter/material.dart';
import 'package:puzzle15/main.dart';

class StepsWidget extends StatefulWidget {
  const StepsWidget({Key? key}) : super(key: key);

  @override
  State<StepsWidget> createState() => _StepsWidgetState();
}

class _StepsWidgetState extends State<StepsWidget> {
  void updateWidget() {
    setState(() {
      puzzleLogic.steps++;
    });
  }

  @override
  void initState() {
    super.initState();
    puzzleLogic.updateSteps = updateWidget;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.swap_horiz_rounded,
          size: 32,
          color: Theme.of(context).primaryColor,
        ),
        Text(
          puzzleLogic.steps.toString(),
        ),
      ],
    );
  }
}
