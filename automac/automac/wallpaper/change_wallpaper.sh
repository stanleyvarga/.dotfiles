#!/bin/zsh

# Define the dictionary of time periods for each month
typeset -A MONTHS
MONTHS=(
    [january]="dawn:6 sunrise:7 morning:9 noon:12 sunset:18 dusk:20 night:21"
    [february]="dawn:5 sunrise:6 morning:8 noon:12 sunset:21 dusk:22 night:23"
    [march]="dawn:7 sunrise:8 morning:10 noon:12 sunset:16 dusk:17 night:19"
    [april]="dawn:8 sunrise:9 morning:11 noon:12 sunset:17 dusk:18 night:19"
    [may]="dawn:6 sunrise:7 morning:9 noon:12 sunset:18 dusk:20 night:21"
    [june]="dawn:5 sunrise:6 morning:8 noon:12 sunset:21 dusk:22 night:23"
    [july]="dawn:7 sunrise:8 morning:10 noon:12 sunset:16 dusk:17 night:19"
    [august]="dawn:8 sunrise:9 morning:11 noon:12 sunset:17 dusk:18 night:19"
    [september]="dawn:7 sunrise:8 morning:10 noon:12 sunset:16 dusk:17 night:19"
    [october]="dawn:8 sunrise:9 morning:11 noon:12 sunset:17 dusk:18 night:19"
    [november]="dawn:7 sunrise:8 morning:10 noon:12 sunset:18 dusk:20 night:21"
    [december]="dawn:8 sunrise:9 noon:12 morning:11 sunset:17 dusk:18 night:19"
)

get_random_image() {
    local dir="$1"
    local images=($dir/*.(jpg|png|gif)(N))
    if (( ${#images} > 0 )); then
        echo ${images[$RANDOM % ${#images} + 1]}
    fi
}
k
# Get current month and hour
current_month=${(L)$(date +%B)}
current_hour=$((10#$(date +%H)))
current_time=$(date +%H:%M:%S)
current_date=$(date +%Y-%m-%d)

state_file="$HOME/automac/wallpaper/state.txt"

# Path to wallpapers directory
wallpapers_dir="$HOME/Wallpapers"

# Find the appropriate time of day
time_of_day=""
for period in dawn sunrise morning noon sunset dusk night; do
    hour=${${MONTHS[$current_month]##*$period:}%%[[:space:]]*}
    if [[ $hour == *[[:digit:]]* ]]; then
        if (( current_hour >= hour )); then
            time_of_day="$period"
        else
            break
        fi
    else
        print "Warning: Could not extract hour for $period"
    fi
done

# If no matching time found, default to "night"
if [[ -z "$time_of_day" ]]; then
    time_of_day="night"
fi

# Read the previous state
previous_state=$(< "$state_file")

# Check if the time of day has changed
if [[ "$time_of_day" != "$previous_state" ]]; then
    # Get a random wallpaper for the current time of day
    wallpaper_dir="$wallpapers_dir/$time_of_day"
    
    image=$(get_random_image "$wallpaper_dir")

    if [[ -z "$image" ]]; then
        print "[$current_date $current_time][EMPTY WALLPAPER]" >> wallpaper.log
        exit
    fi

    # Change the wallpaper
    /usr/libexec/PlistBuddy -c "set AllSpacesAndDisplays:Desktop:Content:Choices:0:Files:0:relative file:///$image" ~/Library/Application\ Support/com.apple.wallpaper/Store/Index.plist
    killall WallpaperAgent

    # Update the state file
    print "$time_of_day" > "$state_file"
    print "[$current_date $current_time][CHANGE_WALLPAPER] $image" >> wallpaper.log
else
    print "🙅 No change. Current time of day: $time_of_day"
    print "[$current_date $current_time][NO_CHANGE]" >> wallpaper.log
fi
