#!/bin/sh

LOG_FILE="$HOME/automac/wallpaper/daytime.log"
DATE=$(date +"%Y-%m-%d %H:%M:%S")
path="$HOME/automac/wallpaper"

# Remove all possible .DS_Store files
find . -name ".DS_Store" -type f -delete

minimize_windows() {
	osascript -e 'tell application "System Events" to set visible of every process whose visible is true to false'
	osascript -e 'tell application "System Events" to tell every process whose visible is true to set value of attribute "AXFullScreen" of window 1 to false'
}

# Figure out whether it is day, between sunrise and sunset
isDayTime() {
	current_hour=$(date +%H | sed 's/^0*//')  # Convert current hour to integer format
	current_season=$(getSeason)
	dawn=""
	sunrise=""
	morning=""
	noon=""
	afternoon=""
	sunset=""
	dusk=""
	night=""

	case $current_season in
		spring)
			dawn="06"
			sunrise="07"
			morning="09"
			noon="12"
			afternoon="15"
			sunset="18" 
			dusk="20" 
			night="21"
			;;
		summer)
			dawn="05"
			sunrise="06"
			morning="08"
			noon="12"
			afternoon="14"
			sunset="21"
			dusk="22"
			night="23"
			;;
		autumn)
			dawn="07"
			sunrise="08"
			morning="10"
			noon="12"
			afternoon="14"
			sunset="18"
			dusk="19"
			night="20"
			;;
		winter)
			dawn="08"
			sunrise="09"
			morning="11"
			noon="12"
			afternoon="13"
			sunset="17"
			dusk="18"
			night="19"
			;;
		*)
			echo "Error: Invalid season."
			exit 1
			;;
	esac

	if [ "$current_hour" -ge "$dawn" ] && [ "$current_hour" -lt "$sunrise" ]; then
		echo "dawn"
	elif [ "$current_hour" -ge "$sunrise" ] && [ "$current_hour" -lt "$morning" ]; then
		echo "sunrise"
	elif [ "$current_hour" -ge "$morning" ] && [ "$current_hour" -lt "$noon" ]; then
		echo "morning"
	elif [ "$current_hour" -ge "$noon" ] && [ "$current_hour" -lt "$afternoon" ]; then
		echo "noon"
	elif [ "$current_hour" -ge "$afternoon" ] && [ "$current_hour" -lt "$sunset" ]; then
		echo "afternoon"
	elif [ "$current_hour" -ge "$sunset" ] && [ "$current_hour" -lt "$dusk" ]; then
		echo "sunset"
	elif [ "$current_hour" -ge "$dusk" ] && [ "$current_hour" -lt "$night" ]; then
		echo "dusk"
	else
		echo "night"
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
	time_of_day=$(isDayTime)
	case $time_of_day in
		dawn)
			wallpaper=$(find "$path/daytime/dawn" -type f | shuf -n 1)
			;;
		sunrise)
			wallpaper=$(find "$path/daytime/sunrise" -type f | shuf -n 1)
			;;
		morning)
			wallpaper=$(find "$path/daytime/morning" -type f | shuf -n 1)
			;;
		noon)
			wallpaper=$(find "$path/daytime/noon" -type f | shuf -n 1)
			;;
		afternoon)
			wallpaper=$(find "$path/daytime/afternoon" -type f | shuf -n 1)
			;;
		sunset)
			wallpaper=$(find "$path/daytime/sunset" -type f | shuf -n 1)
			;;
		dusk)
			wallpaper=$(find "$path/daytime/dusk" -type f | shuf -n 1)
			;;
		night)
			wallpaper=$(find "$path/daytime/night" -type f | shuf -n 1)
			;;
		*)
			echo "Error: Invalid time of day."
			exit 1
			;;

	esac

	## ORIGINAL
	# minimize_windows
	# sleep 1

	# # Set the wallpaper using osascript and AppleScript
	# osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"$wallpaper\""
	
	# echo "[$DATE][$time_of_day] set wallpaper ($wallpaper)" >> $LOG_FILE
	## ORIGINAL


	## TEST
	# Get the list of all fullscreen applications
	fullscreen_apps=$(osascript -e 'tell application "System Events" to get name of every process whose value of attribute "AXFullScreen" of window 1 is true')

	# Minimize all fullscreen applications
	IFS=', ' read -r -a apps <<< "$fullscreen_apps"
	for app in "${apps[@]}"; do
			osascript -e "tell application \"System Events\" to tell process \"$app\" to set value of attribute \"AXFullScreen\" of window 1 to false"
	done
	sleep 1

	# Set the wallpaper using osascript and AppleScript
	osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"$wallpaper\""

	# Restore all applications to fullscreen
	for app in "${apps[@]}"; do
			osascript -e "tell application \"System Events\" to tell process \"$app\" to set value of attribute \"AXFullScreen\" of window 1 to true"
	done

	echo "[$DATE][$time_of_day] set wallpaper ($wallpaper)" >> $LOG_FILE
}


set_wallpaper
