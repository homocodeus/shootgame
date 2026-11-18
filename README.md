# Star Guard

A Goose arcade space shooter using the built-in gfx and ui modules.

The official Windows compiler is installed locally in .tools/runtime. No PATH setup is needed.

Run: double-click start.bat, or run ./run.ps1 in PowerShell.

Move with A/D or arrow keys. Hold Space to shoot. P pauses, R restarts, Escape quits.
Destroy drones for points. Each drone crossing the defense line costs a shield. Spawns and enemies accelerate as your score rises.

The compiler source is downloaded in .tools/goose for reference. Compiler checking has not yet completed; gameplay is not play-tested.


## macOS

Copy this project to your Mac. Requires macOS 13.3 or newer and an internet connection on first launch.

In Terminal, change to the project folder and run:

```sh
bash Start-Mac.command
```

The launcher detects Apple silicon or Intel and downloads the official Goose v2026.4 compiler into .tools/mac. Subsequent launches use that local copy.

To enable launching from Finder, run `chmod +x Start-Mac.command` once, then double-click Start-Mac.command.

The Mac launcher has not been tested on macOS. Game compilation and gameplay remain unverified.
