import 'package:flutter/material.dart';
import 'package:puzzle15/main.dart';

class PuzzleColors extends StatefulWidget {
  const PuzzleColors({Key? key}) : super(key: key);

  @override
  State<PuzzleColors> createState() => _PuzzleColorsState();
}

class _PuzzleColorsState extends State<PuzzleColors> {
  static Map<Color, int> colorButtons = {
    Colors.blue.shade500: 0,
    Colors.red.shade700: 1,
    Colors.green: 2,
    Colors.brown: 3,
    Colors.purple: 4,
  };

  List<Widget> _map2widgets(double size) {
    final result = <Widget>[];
    colorButtons.forEach((key, value) {
      result.add(
        SizedBox(
          width: size,
          height: size,
          child: OutlinedButton(
            onPressed: () {
              setState(() {
                puzzleLogic.newColorThemeIndex = value;
              });
            },
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.zero,
              backgroundColor: key,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(6),
                ),
              ),
              side: BorderSide(
                color: (value == puzzleLogic.newColorThemeIndex)
                    ? Theme.of(context).highlightColor
                    : Colors.transparent,
                width: (value == puzzleLogic.newColorThemeIndex) ? 6 : 0,
              ),
            ),
            child: Text(
              '${puzzleLogic.getMatrix()}',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: size - 15,
              ),
            ),
          ),
        ),
      );
    });
    return result;
  }

  @override
  Widget build(BuildContext context) {
    var size =
        (MediaQuery.of(context).size.width < MediaQuery.of(context).size.height)
            ? MediaQuery.of(context).size.width / colorButtons.length
            : MediaQuery.of(context).size.height / colorButtons.length;
    if (size > 100) size = 100;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _map2widgets(size),
    );
  }
}
