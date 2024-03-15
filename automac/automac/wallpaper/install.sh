# Unload if exists
if [ -f ~/Library/LaunchAgents/de.bernhard-baehr.sleepwatcher.plist ]; then
	launchctl unload -w ~/Library/LaunchAgents/de.bernhard-baehr.sleepwatcher.plist
fi

# Load script to run sleepwatcher on startup
launchctl load -w ~/Library/LaunchAgents/de.bernhard-baehr.sleepwatcher.plist
