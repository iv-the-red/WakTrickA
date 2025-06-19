# WakTrickA v1.0 (BETA)

⚠️ **BETA SOFTWARE** - Use at your own risk. This software is in early development and may contain bugs.

A tool that simulates coding activity in VS Code to maintain WakaTime streaks.

## What it does

- Finds empty lines in your VS Code file
- Adds temporary gibberish text
- Creates comments with timestamps
- Manages variables
- Cleans up after itself
- Repeats every 18-25 seconds

## Requirements

- Windows OS
- VS Code installed
- AutoHotkey v2.0+

## Installation

### 1. Download AutoHotkey v2

1. Go to https://www.autohotkey.com/
2. Download **AutoHotkey v2** (NOT v1.1)
3. Install it with default settings

### 2. Download the Script

1. Copy the script code into a new file
2. Save it with `.ahk` extension (e.g., `wakatime-simulator.ahk`)

## Usage

### Setup
1. Open VS Code with any file (JavaScript/TypeScript recommended)
2. Make sure the file has some content and empty lines
3. Double-click the `.ahk` file to run

### Controls
- **F9** - Pause/Resume
- **F10** - Exit
- **F11** - Show/Hide status window

### Status Window
Shows:
- Current status
- Cycle count
- Runtime
- Pause state

## Important Notes

⚠️ **WARNINGS:**
- This is BETA software - expect bugs
- Always backup your code before using
- Don't use on important files
- The script will modify your VS Code file temporarily
- Make sure VS Code is the active window when starting

## Troubleshooting

- **Script won't start**: Make sure you have AutoHotkey v2.0, not v1.1
- **VS Code not detected**: Make sure VS Code is running and visible
- **Gibberish not cleaned**: Press F9 to pause, manually clean up, then resume
- **Errors**: Try restarting both the script and VS Code

## Beta Disclaimer

This software is in beta testing. Use responsibly and only on test files. The developers are not responsible for any data loss or issues caused by this software.