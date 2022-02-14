# FlutterPuzzle
The “FlutterPuzzle” application has a main area and a sliding top panel with settings. Main area keeps a set of puzzle tiles. Top panel has a timer, steps count, three buttons:
- Change tiles color
- Change difficulty level
- Restart the game
The application works in portrait and landscape mode on Android, iOS, Web.
## The game rules.
The game starts when any tile is moved for the first time. Time and steps count are taken into account. If the user wants to change game difficulty or tiles color after the game starts, the game will be paused. Just tiles adjacent to an empty space can be swapped with it. The game ends, when all of the tiles are placed in ascending order and the last one contains an empty space.
## Options.
The difficulty level can be set by clicking on the middle button in the top panel. The main area will slide down and the difficulty options will be shown to user. To complete the choice, the same button have to be pressed again.
The same have to be done to change the tiles color. But the button with palette icon have to be pressed in this case.
To restart the game the right button have to be clicked.
## Endgame.
The “Congratulations” page appears, when the puzzle is solved. The additional information on this page:
- Time, spent for puzzle solving
- Number of steps
- “Restart game” button

[YouTube demonstration video](https://youtu.be/XU5qI-_Zh4c)