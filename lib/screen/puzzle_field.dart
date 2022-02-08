import 'package:flutter/material.dart';
import 'package:puzzle15/main.dart';

class PuzzleField extends StatefulWidget {
  const PuzzleField({Key? key}) : super(key: key);

  @override
  State<PuzzleField> createState() => _PuzzleFieldState();
}

class _PuzzleFieldState extends State<PuzzleField> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: (MediaQuery.of(context).orientation == Orientation.portrait)
            ? MediaQuery.of(context).size.width * 0.9
            : MediaQuery.of(context).size.height * 0.7,
        height: (MediaQuery.of(context).orientation == Orientation.portrait)
            ? MediaQuery.of(context).size.width * 0.9
            : MediaQuery.of(context).size.height * 0.7,
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: 2,
            crossAxisSpacing: 2,
            crossAxisCount: puzzleLogic.getMatrix(),
          ),
          itemCount: puzzleLogic.puzzleData.length,
          itemBuilder: (context, index) {
            return Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width <
                        MediaQuery.of(context).size.height
                    ? MediaQuery.of(context).size.width /
                        puzzleLogic.getMatrix()
                    : MediaQuery.of(context).size.height /
                        puzzleLogic.getMatrix(),
                height: MediaQuery.of(context).size.width <
                        MediaQuery.of(context).size.height
                    ? MediaQuery.of(context).size.width /
                        puzzleLogic.getMatrix()
                    : MediaQuery.of(context).size.height /
                        puzzleLogic.getMatrix(),
                child: Padding(
                  padding: EdgeInsets.zero,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        puzzleLogic.swapParts(index);
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor: puzzleLogic.puzzleData[index] !=
                              puzzleLogic.getMatrix() * puzzleLogic.getMatrix()
                          ? MaterialStateProperty.all<Color>(
                              puzzleLogic.getColorByColorThemeIndex(
                                puzzleLogic.getColorThemeIndex(),
                              ),
                            )
                          : MaterialStateProperty.all<Color>(
                              Colors.transparent,
                            ),
                    ),
                    child: Text(
                      puzzleLogic.puzzleData[index] !=
                              puzzleLogic.getMatrix() * puzzleLogic.getMatrix()
                          ? puzzleLogic.puzzleData[index].toString()
                          : '',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).orientation ==
                                Orientation.portrait
                            ? puzzleLogic.puzzleButtonSize.toDouble()
                            : puzzleLogic.puzzleButtonSize.toDouble() * 0.8,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
