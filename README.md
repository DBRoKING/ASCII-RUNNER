# ASCII RUNNER
#### Video Demo: https://youtu.be/S_Ab-zLZ3ec
#### Description:
ASCII RUNNER is an endless runner game created with LÖVE2D and Lua, where you control an ASCII character `(0>)` and jump over randomly generated obstacles such as fire, bombs, dragons, and more. The game progressively gets more difficult as the player's score increases, and high scores are saved for replayability. The game’s hybrid visual style merges ASCII art and emojis to create a unique experience.

**Implementation**

- **main.lua**: Contains all the game logic, including player movement, physics, obstacle generation, and collision detection. The player can jump by pressing the _SPACEBAR_, and obstacles are spawned at random intervals. As the game progresses, obstacles become more frequent, and the player's speed gradually increases based on their score.

  - **Player Mechanics**: The player’s physics are governed by a simple gravity and jump force. When the player presses the spacebar, the jump force is applied, and gravity pulls the player back down after the jump. The jump force is set to -18, and gravity is set to 1.0 for a smooth jumping effect.

  - **Obstacle Generation**: Obstacles are spawned randomly at varying intervals based on the player's score. The `spawnRate` variable is dynamically adjusted by `1.5 - (score * 0.005)`, which ensures that obstacles appear more frequently as the player progresses.

  - **Score Tracking**: The game keeps track of the current score, which increases over time as the player survives longer. The highest score is saved internally within the game's folder during gameplay. The high score is updated if the player surpasses their previous best score, and this data is saved at the end of the session. The game reads this data when it starts and displays the high score on the main menu. Note that the file highscore.txt is not visible in the file system; it is managed by the game itself and exists only for the duration of the session.

- **music/**: Contains three retro-style soundtracks that accompany and loops at different parts of the game:
  - **starttheme.mp3**: Plays when the player is in the main menu of the game.
  - **background.mp3**: Loops while the player is playing.
  - **restarttheme.mp3**: Played when the game is over and the player is given the option to restart.

**Key Features**
- **Intuitive One-Button Control**: Players can control the character with the spacebar to jump over obstacles. This simplicity allows for a quick and easy gameplay experience, making it accessible for all players.

- **Dynamic Difficulty**: As the player progresses, the game speed increases based on the score. This ensures that the game remains challenging as the player survives longer, preventing the game from becoming too easy after reaching a certain point.

- **Persistent High Score**: The highest score is saved across sessions, so players can always come back to try to beat their own best score. The high score is displayed in the menu and updated after every game session.

- **Hybrid ASCII/Emoji Visual Style**: The game uses a combination of ASCII characters and emojis to represent both the player and obstacles. This quirky visual style makes the game stand out and adds a fun, playful feel to the experience.

- **Responsive Collision Detection**: The game implements collision detection that accurately registers when the player hits an obstacle. The player’s collision box is carefully matched with the obstacles' boundaries to ensure fair gameplay.

**How to Play**
1. Install [LÖVE2D](https://love2d.org) (v11.4 or later recommended).
2. Download the project files to your computer.
3. Drag the folder containing the project files onto the LÖVE executable to run the game.
4. Enter your player name when prompted in the main menu.
5. Press the spacebar to make your character jump over obstacles.
6. Try to survive as long as possible and achieve the highest score!

**Evolution from Scratch**

This project is a significant step forward from my earlier work in [Night City (Scratch Project)](https://scratch.mit.edu/projects/1066746307), where I first learned programming concepts in a block-based environment. The transition to Lua and LÖVE2D allowed me to explore more complex programming concepts such as collision detection, file I/O for saving scores, and the implementation of sound effects.

- **From Block-Based to Text-Based Programming**: My earlier projects on Scratch provided me with a foundation in game mechanics and logic. Moving to Lua allowed me to implement more advanced features such as random obstacle generation, physics, and data persistence. The transition to text-based programming has greatly improved my understanding of how games are built and how different elements interact with each other.

- **Advanced Collision Detection**: In Scratch, I used simple touch detection for collisions. In ASCII RUNNER, I wrote a more advanced system for checking player-obstacle collisions that considers both the player's and the obstacles' shapes. This ensures the game is more accurate and challenging, especially when dealing with moving obstacles.

- **File I/O for High Score Tracking**: One of the key advancements in this project is the ability to save and load high scores from a text file using `love.filesystem.write()` and `love.filesystem.read()`. This allows the game to track scores across sessions, giving players the ability to compare their performance over time.

**Developer Info**
- **Created by**: Dinuga Dewdun (DBRoKING)
- **GitHub**: [DBRoKING](https://github.com/DBRoKING)
- **edX**: dinugadewdun
- **Location**: Colombo, Sri Lanka
- **Date**: April 10, 2025

**Acknowledgments**
I would like to thank the CS50 course for providing the foundation that allowed me to build this project. The lessons in programming, along with the inspiration from other students’ projects, were invaluable in creating ASCII RUNNER. This project was a great way for me to consolidate the knowledge I gained throughout the course, and it marked my journey from visual programming to more advanced text-based coding.

*CS50x 2025 Final Project Submission*
