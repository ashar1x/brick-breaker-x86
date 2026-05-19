# Brick Breaker - x86 Assembly

A fully playable Brick Breaker game written entirely in x86 Assembly using MASM and the Irvine32 library. It runs in the Windows console with background music, power-ups, a high score leaderboard, and multiple screens. Built as a fourth semester COAL (Computer Organization and Assembly Language) project.

---

## What is this?

Brick Breaker, but every single line is Assembly. The ball physics, collision detection, paddle movement, power-up logic, score tracking, file I/O for high scores, and MP3 playback are all handled in raw x86 — no C++, no shortcuts.

---

## Features

- Brick grid with collision detection and ball physics
- Paddle controlled with keyboard input
- Power-up system with multiple power-up types
- Background music via Windows Multimedia API (plays MP3)
- Home screen, name entry, main menu, and instructions screen
- High score leaderboard saved to and loaded from a file
- Multiple game screens managed through a menu loop

---

## How to Run

> Windows only. Requires MASM (Microsoft Macro Assembler) and the Irvine32 library.

**Assemble and link:**
```
ml /c /coff Main.asm
link /subsystem:console Main.obj Irvine32.lib kernel32.lib winmm.lib
```

Or use the included VS Code tasks (`tasks.json`) if you have MASM set up with VS Code.

Make sure `menu.mp3`, `trumpet.mp3`, and `scores.dat` are in the same folder as the executable.

---

## Project Structure

```
Main.asm                  # entry point, audio control, game loop
GameScreen.asm            # core gameplay: ball, paddle, bricks, collision
PowerUp.asm               # power-up types and effects
HomeScreen.asm            # intro screen
NameScreen.asm            # player name entry
MainMenuScreen.asm        # main menu with options
InstructionsScreen.asm    # how to play screen
HighScoreScreen.asm       # leaderboard display
menu.mp3                  # background music for menus
trumpet.mp3               # in-game audio
scores.dat                # persisted high score data
.vscode/tasks.json        # build tasks for VS Code
```

---

## Notes

Fourth semester COAL project. Writing a game in Assembly means managing every register, every memory address, and every jump manually. No abstractions, no standard library calls beyond Irvine32. Getting the ball physics and collision detection working in pure x86 took more effort than it probably should have.

---

## License

Feel free to use or learn from this. Credit appreciated but not required.
