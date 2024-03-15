#!/bin/sh

LOG_FILE="$HOME/automac/wallpaper/bg.log"
DATE=$(date +"%Y-%m-%d %H:%M:%S")
path="$HOME/automac/wallpaper"

# Remove all possible .DS_Store files
find . -name ".DS_Store" -type f -delete

# Figure out whether it is day, between sunrise and sunset
isDayTime() {
	current_hour=$(date +%H | sed 's/^0*//')  # Convert current hour to integer format
	current_season=$(getSeason)
	sunrise=""
	sunset=""

	case $current_season in
		spring)
			sunrise="06"
			sunset="20"
			;;
		summer)
			sunrise="05"
			sunset="21"
			;;
		autumn)
			sunrise="07"
			sunset="19"
			;;
		winter)
			sunrise="08"
			sunset="17"
			;;
		*)
			echo "Error: Invalid season."
			exit 1
			;;
	esac

	if [ "$current_hour" -gt "$sunrise" ] && [ "$current_hour" -lt "$sunset" ]; then
		return 1
	else
		return 0
	fi
}

getSeason() {
	current_month=$(date +%m)
	case $current_month in
		03|04|05)
			echo "spring"
			;;
		06|07|08)
			echo "summer"
			;;
		09|10|11)
			echo "autumn"
			;;
		12|01|02)
			echo "winter"
			;;
		*)
			echo "Error: Invalid month."
			exit 1
			;;
	esac
}

# Set the wallpaper based on the current time
set_wallpaper() {
	if isDayTime; then
		# Find the image in the $path/light directory and get the path with the correct extension
		wallpaper=$(find "$path/light" -type f -print -quit)
	else
		# Find the image in the $path/dark directory and get the path with the correct extension
		wallpaper=$(find "$path/dark" -type f -print -quit)
	fi
	
	minimize_windows
	
	sleep 1
	# Set the wallpaper using osascript and AppleScript
	osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"$wallpaper\""

	echo "[$DATE] set wallpaper ($wallpaper)" >> $LOG_FILE
}

minimize_windows() {
	osascript -e 'tell application "System Events" to set visible of every process whose visible is true to false'
	osascript -e 'tell application "System Events" to tell every process whose visible is true to set value of attribute "AXFullScreen" of window 1 to false'
}

set_wallpaper
	