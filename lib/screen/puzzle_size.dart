import 'package:flutter/material.dart';
import 'package:puzzle15/main.dart';

class PuzzleSize extends StatefulWidget {
  const PuzzleSize({Key? key}) : super(key: key);

  @override
  State<PuzzleSize> createState() => _PuzzleSizeState();
}

class _PuzzleSizeState extends State<PuzzleSize> {
  static Map<String, int> sizeButtons = {
    'images/matrix3.png': 3,
    'images/matrix4.png': 4,
    'images/matrix5.png': 5,
    'images/matrix6.png': 6,
    'images/matrix7.png': 7,
  };

  List<Widget> _map2widgets(double size) {
    final result = <Widget>[];
    sizeButtons.forEach((key, value) {
      result.add(
        SizedBox(
          width: size,
          height: size,
          child: OutlinedButton(
            onPressed: () {
              setState(() {
                puzzleLogic.newMatrixSize = value;
              });
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.all(10),
              backgroundColor: Colors.transparent,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(6),
                ),
              ),
              side: BorderSide(
                color: (value == puzzleLogic.newMatrixSize)
                    ? Theme.of(context).highlightColor
                    : Colors.transparent,
                width: (value == puzzleLogic.newMatrixSize) ? 6 : 0,
              ),
            ),
            child: Image.asset(key, width: size - 6),
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
            ? MediaQuery.of(context).size.width / sizeButtons.length
            : MediaQuery.of(context).size.height / sizeButtons.length;
    if (size > 100) size = 100;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _map2widgets(size),
    );
  }
}
