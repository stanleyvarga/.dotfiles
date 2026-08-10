# Sound Files

This directory contains sound files that can be played from the command line.

## Available Sounds

- `among-us.mp3` - Among Us sound effect
- `yeah-boy.mp3` - Yeah boy sound effect

## Usage

### Automatic Playback & Activity Simulation

The `coffee` script automatically:
1. **Simulates keyboard activity** every 4 minutes to keep Microsoft Teams active (prevents status from going yellow/orange)
2. **Plays the Among Us sound** after each activity cycle as a fun reminder

This keeps you appearing active in Teams without interfering with your work.

### Manual Playback

Use the `play-sound` utility to play sounds manually:

```bash
# Play default sound (among-us)
bin/bin/play-sound

# Play specific sound
bin/bin/play-sound among-us
bin/bin/play-sound yeah-boy

# List all available sounds
bin/bin/play-sound --list
```

### Activity Simulation

Use the `activity-simulator` to manually simulate activity:

```bash
# Simulate keyboard activity for 20 seconds (default)
bin/bin/activity-simulator

# Simulate keyboard activity for 10 seconds
bin/bin/activity-simulator 10

# Simulate mouse activity (requires accessibility permissions)
bin/bin/activity-simulator 15 mouse

# Simulate both keyboard and mouse activity
bin/bin/activity-simulator 20 both
```

### Direct Command

You can also use the built-in macOS `afplay` command directly:

```bash
afplay sound/among-us.mp3
afplay sound/yeah-boy.mp3
```

## How It Works

- **`afplay`**: Built-in macOS command for playing audio files
- **`play-sound`**: Custom utility script for easy sound management
- **`activity-simulator`**: Simulates user activity to keep Teams active
- **Automatic integration**: Built into the coffee script for periodic reminders and activity simulation

## Activity Simulation Methods

1. **Keyboard**: Presses and releases the Shift key subtly (no accessibility permissions required)
2. **Mouse**: Moves cursor in small patterns (requires accessibility permissions)
3. **Combined**: Uses both methods simultaneously

## Adding New Sounds

1. Place your `.mp3` file in this directory
2. Use `play-sound --list` to see all available sounds
3. Play with `play-sound your-sound-name` (without the .mp3 extension)

## Requirements

- macOS (for `afplay` command and AppleScript)
- Zsh shell
- MP3 audio files
- `bc` command for math calculations (usually pre-installed)

## Teams Status Management

The activity simulation helps prevent Microsoft Teams from showing you as:
- 🟡 Yellow (away)
- 🟠 Orange (busy/do not disturb)

By simulating subtle keyboard activity every 4 minutes, Teams will see you as actively using the computer.
