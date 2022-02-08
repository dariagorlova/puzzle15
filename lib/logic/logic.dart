import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

extension SwappableList<E> on List<E> {
  void swap(int first, int second) {
    final temp = this[first];
    this[first] = this[second];
    this[second] = temp;
  }
}

typedef Callback = void Function({bool reset});

class PuzzleLogic {
  late SharedPreferences prefs;
  void init(int size, int colorIndex) {
    _matrixSize = size;
    _colorThemeIndex = colorIndex;
    newMatrixSize = _matrixSize;
    newColorThemeIndex = _colorThemeIndex;
  }

  int steps = 0;
  VoidCallback? updateSteps;

  VoidCallback? showCongratulation;

  int seconds = 0;
  bool isPaused = false;
  Callback? launchTimer;
  Callback? stopTimer;
  VoidCallback? pauseTimer;
  VoidCallback? resumeTimer;

  String getDuration(int sec) {
    final seconds = (sec % 60).toString().padLeft(2, '0');
    final minutes = ((sec / 60) % 60).toInt().toString().padLeft(2, '0');

    return '$minutes:$seconds';
  }

  late int _matrixSize;
  int? newMatrixSize;
  late int _colorThemeIndex;
  int? newColorThemeIndex;
  final List<int> puzzleData = [];
  int puzzleButtonSize = 0;

  int getMatrix() => _matrixSize;
  void setMatrix(int newSize) {
    _matrixSize = newSize;
    prefs.setInt('matrix', _matrixSize);
  }

  int getColorThemeIndex() => _colorThemeIndex;
  void setColorThemeIndex(int newColorIndex) {
    _colorThemeIndex = newColorIndex;
    prefs.setInt('color', _colorThemeIndex);
  }

  Color getColorByColorThemeIndex(int index) {
    switch (index) {
      case 0:
        return Colors.blue.shade500;
      case 1:
        return Colors.red.shade700;
      case 2:
        return Colors.green;
      case 3:
        return Colors.brown;
      case 4:
        return Colors.purple;
      default:
        return Colors.transparent;
    }
  }

  bool isPuzzleSolved() {
    var res = true;
    puzzleData.asMap().forEach((key, value) {
      if (key + 1 != value) {
        res = false;
      }
    });
    return res;
  }

  void generatePuzzleData() {
    final lastElement = getMatrix() * getMatrix();
    puzzleData.clear();
    for (var i = 1; i <= lastElement; i++) {
      puzzleData.add(i);
    }
    puzzleData.shuffle();

    if (!_isSolvable()) {
      var zeroPos = -1;
      for (final element in puzzleData) {
        if (element == lastElement) {
          zeroPos = puzzleData.indexOf(element);
          break;
        }
      }
      final last =
          (zeroPos == lastElement - 1) ? lastElement - 2 : lastElement - 1;
      final previous = (zeroPos == last - 1) ? last - 2 : last - 1;
      puzzleData.swap(last, previous);
    }
    steps = 0;
    stopTimer?.call(reset: true);
    puzzleButtonSize = (10 - getMatrix()) * 10 - 15;
    isPaused = false;
  }

  bool _isSolvable() {
    var inversions = 0;
    var zeroPos = 0;
    final size = _matrixSize * _matrixSize;
    for (var i = 0; i < size; i++) {
      final n = puzzleData[i];
      if (n == size) {
        zeroPos = i;
      }
      for (var j = i + 1; j < size; j++) {
        final m = puzzleData[j];
        if (i != j && m != size && n != size && n > m) {
          inversions++;
        }
      }
    }
    final z = _matrixSize - zeroPos ~/ _matrixSize;
    if (_matrixSize.isEven) {
      if (z.isEven) {
        return inversions.isOdd;
      }
    }
    return inversions.isEven;
  }

  void swapParts(int curIndex) {
    if (isPaused) {
      return;
    }

    final lastElement = _matrixSize * _matrixSize;
    var swapWith = -1;
    //UP curIndex-matrixSize
    if (curIndex - _matrixSize > -1) {
      if (puzzleData[curIndex - _matrixSize] == lastElement) {
        swapWith = curIndex - _matrixSize;
      }
    }

    //DOWN curIndex+matrixSize
    if (curIndex + _matrixSize < lastElement) {
      if (puzzleData[curIndex + _matrixSize] == lastElement) {
        swapWith = curIndex + _matrixSize;
      }
    }

    //LEFT curIndex-1
    if (curIndex - 1 > -1 &&
        (curIndex ~/ _matrixSize) == ((curIndex - 1) ~/ _matrixSize)) {
      if (puzzleData[curIndex - 1] == lastElement) {
        swapWith = curIndex - 1;
      }
    }

    //RIGHT curIndex+1
    if (curIndex + 1 < lastElement &&
        (curIndex ~/ _matrixSize) == ((curIndex + 1) ~/ _matrixSize)) {
      if (puzzleData[curIndex + 1] == lastElement) {
        swapWith = curIndex + 1;
      }
    }

    if (swapWith != -1) {
      if (steps == 0) {
        launchTimer?.call(reset: true);
      }

      updateSteps?.call();
      puzzleData.swap(curIndex, swapWith);

      if (isPuzzleSolved()) {
        stopTimer?.call(reset: false);
        showCongratulation?.call();
      }
    }
  }
}
