# Unload sleepwatcher if it exists
sleepwatcher_plist="$HOME/Library/LaunchAgents/de.bernhard-baehr.sleepwatcher.plist"
if [ -f "$sleepwatcher_plist" ]; then
  launchctl unload -w "$sleepwatcher_plist"
fi

# Unload wallpaper_scheduler if it exists
wallpaper_scheduler_plist="$HOME/Library/LaunchAgents/com.automac.wallpaper_scheduler.plist"
if [ -f "$wallpaper_scheduler_plist" ]; then
  launchctl unload -w "$wallpaper_scheduler_plist"
fi

launchctl load -w "$sleepwatcher_plist"
launchctl load -w "$wallpaper_scheduler_plist"

launchctl list | grep wallpaper_scheduler
launchctl list | grep sleepwatcher

chmod +x $HOME/automac/wallpaper/dynamic_wallpaper.ts
chmod +x $HOME/automac/wallpaper/dynamic_wallpaper.sh
chmod +x $HOME/automac/wallpaper/randomize_images.sh
