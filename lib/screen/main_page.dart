import 'package:flutter/material.dart';
import 'package:puzzle15/main.dart';
import 'package:puzzle15/screen/puzzle_colors.dart';
import 'package:puzzle15/screen/puzzle_field.dart';
import 'package:puzzle15/screen/puzzle_size.dart';
import 'package:puzzle15/screen/steps_widget.dart';
import 'package:puzzle15/screen/time_widget.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => MainPageState();
}

enum BTN_PRESSED { none, palette, matrixSize }

class MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  BTN_PRESSED buttonIndex = BTN_PRESSED.none;
  late AnimationController _controller;

  bool get _isPanelVisible {
    final status = _controller.status;
    return status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      value: 1,
      vsync: this,
    );
    puzzleLogic.showCongratulation = showCongratulationsPage;
    puzzleLogic.generatePuzzleData();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future<void> showCongratulationsPage() async {
    await Navigator.pushNamed(context, '/congratulations');
    puzzleLogic.generatePuzzleData();
  }

  Animation<RelativeRect> _getPanelAnimation(
    BuildContext context,
    BoxConstraints constraints,
  ) {
    final layerTitleHeight = constraints.biggest.height - 120;
    final layerSize = constraints.biggest;
    final layerTop = layerSize.height - layerTitleHeight;

    return RelativeRectTween(
      begin: RelativeRect.fromLTRB(
        0,
        layerTop,
        0,
        layerTop - layerSize.height,
      ),
      end: RelativeRect.fill,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );
  }

  Widget _buildStack(BuildContext context, BoxConstraints constraints) {
    final animation = _getPanelAnimation(context, constraints);
    final middleWidth = constraints.biggest.width / 2.0;
    final middleHeight = constraints.biggest.height / 2.0;
    final puzzleWidgetSize =
        (MediaQuery.of(context).orientation == Orientation.portrait)
            ? MediaQuery.of(context).size.width * 0.9
            : MediaQuery.of(context).size.height * 0.7;
    return Container(
      color: Theme.of(context).dialogBackgroundColor,
      child: Stack(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: (buttonIndex == BTN_PRESSED.palette)
                    ? const PuzzleColors()
                    : (buttonIndex == BTN_PRESSED.matrixSize)
                        ? const PuzzleSize()
                        : null,
              ),
            ],
          ),
          PositionedTransition(
            rect: animation,
            child: Material(
              color: Theme.of(context).backgroundColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              elevation: 12,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Positioned(
                    top: middleHeight - puzzleWidgetSize / 2,
                    left: middleWidth - puzzleWidgetSize / 2,
                    child: (buttonIndex != BTN_PRESSED.none &&
                            MediaQuery.of(context).orientation ==
                                Orientation.landscape)
                        ? const Text('')
                        :
                        // ignore: prefer_const_constructors
                        PuzzleField(),
                  ),
                  Positioned(
                    top: 10,
                    left: middleWidth - 75,
                    child: (buttonIndex == BTN_PRESSED.none)
                        ? const Text('')
                        : Icon(
                            Icons.pause_circle_outline,
                            size: 150,
                            color: Theme.of(context).dialogBackgroundColor,
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            // ignore: prefer_const_constructors
            TimerWidget(),
            const SizedBox(
              width: 10,
            ),
            // ignore: prefer_const_constructors
            StepsWidget(),
          ],
        ),
        actions: [
          IconButton(
            onPressed: (BTN_PRESSED.matrixSize == buttonIndex)
                ? null
                : () {
                    setState(() {
                      buttonIndex = (BTN_PRESSED.none != buttonIndex)
                          ? BTN_PRESSED.none
                          : BTN_PRESSED.palette;

                      if (_isPanelVisible) {
                        puzzleLogic.pauseTimer?.call();
                        puzzleLogic.isPaused = true;
                      } else {
                        puzzleLogic.isPaused = false;
                        if (puzzleLogic.steps > 0) {
                          puzzleLogic.resumeTimer?.call();
                        }
                      }

                      if (buttonIndex == BTN_PRESSED.none &&
                          puzzleLogic.newColorThemeIndex !=
                              puzzleLogic.getColorThemeIndex()) {
                        puzzleLogic.setColorThemeIndex(
                          puzzleLogic.newColorThemeIndex!,
                        );
                      }
                    });

                    _controller.fling(velocity: _isPanelVisible ? -1.0 : 1.0);
                  },
            icon: Icon(
              Icons.palette_outlined,
              size: 35,
              color: (BTN_PRESSED.palette == buttonIndex)
                  ? Theme.of(context).highlightColor
                  : (BTN_PRESSED.none == buttonIndex)
                      ? Theme.of(context).primaryColor
                      : ThemeData().unselectedWidgetColor,
            ),
          ),
          IconButton(
            onPressed: (BTN_PRESSED.palette == buttonIndex)
                ? null
                : () {
                    setState(() {
                      buttonIndex = (BTN_PRESSED.none != buttonIndex)
                          ? BTN_PRESSED.none
                          : BTN_PRESSED.matrixSize;

                      if (_isPanelVisible) {
                        puzzleLogic.pauseTimer?.call();
                        puzzleLogic.isPaused = true;
                      }

                      if (buttonIndex == BTN_PRESSED.none) {
                        if (puzzleLogic.newMatrixSize !=
                            puzzleLogic.getMatrix()) {
                          puzzleLogic
                            ..setMatrix(puzzleLogic.newMatrixSize!)
                            ..generatePuzzleData()
                            ..stopTimer?.call(reset: true)
                            ..isPaused = false;
                        } else {
                          puzzleLogic.isPaused = false;
                          if (puzzleLogic.steps > 0) {
                            puzzleLogic.resumeTimer?.call();
                          }
                        }
                      }
                    });
                    _controller.fling(velocity: _isPanelVisible ? -1.0 : 1.0);
                  },
            icon: Image.asset(
              'images/btn${puzzleLogic.getMatrix()}.png',
              width: 35,
              color: (BTN_PRESSED.matrixSize == buttonIndex)
                  ? Theme.of(context).highlightColor
                  : (BTN_PRESSED.none == buttonIndex)
                      ? Theme.of(context).primaryColor
                      : ThemeData().unselectedWidgetColor,
            ),
          ),
          IconButton(
            onPressed: (BTN_PRESSED.none != buttonIndex)
                ? null
                : () {
                    setState(() {
                      puzzleLogic.generatePuzzleData();
                    });
                  },
            icon: const Icon(
              Icons.refresh,
              size: 35,
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: _buildStack,
      ),
    );
  }
}
