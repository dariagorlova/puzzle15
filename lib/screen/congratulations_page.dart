import 'package:flutter/material.dart';
import 'package:puzzle15/main.dart';

class CongratulationsPage extends StatelessWidget {
  const CongratulationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Flex(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        direction: MediaQuery.of(context).orientation == Orientation.portrait
            ? Axis.vertical
            : Axis.horizontal,
        children: [
          SizedBox(
            height: 40,
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Image.asset('images/cup.png'),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const ResultRow(),
                  SizedBox(
                    height: 20,
                  ),
                  FlatButton.icon(
                    onPressed: () => Navigator.pop(context),
                    label: Text(''),
                    icon: Icon(
                      Icons.refresh,
                      size: 150,
                      color: Theme.of(context).highlightColor,
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
}

class ResultRow extends StatelessWidget {
  const ResultRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.alarm,
          size: 32,
          color: Theme.of(context).dialogBackgroundColor,
        ),
        Text(
          puzzleLogic.getDuration(puzzleLogic.seconds),
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).dialogBackgroundColor,
          ),
        ),
        const SizedBox(
          width: 50,
        ),
        Icon(
          Icons.swap_horiz_rounded,
          size: 32,
          color: Theme.of(context).dialogBackgroundColor,
        ),
        Text(
          puzzleLogic.steps.toString(),
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).dialogBackgroundColor,
          ),
        ),
      ],
    );
  }
}
