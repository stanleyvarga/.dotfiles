#!/usr/bin/env ts-node

import { $, fs, os, path } from "zx";

// Define types

interface WallpaperCount {
  [key: string]: string;
}

type MonthTimes = {
  [key: string]: string;
};

type DayTime = {
  length: number;
  images: string[];
};

interface Settings {
  state: { current: string };
  files: {
    dawn: DayTime;
    sunrise: DayTime;
    morning: DayTime;
    noon: DayTime;
    sunset: DayTime;
    dusk: DayTime;
    night: DayTime;
  };
}

// Constants
const MONTHS: MonthTimes = {
  january: "dawn:6 sunrise:7 morning:9 noon:12 sunset:18 dusk:20 night:21",
  february: "dawn:5 sunrise:6 morning:8 noon:12 sunset:21 dusk:22 night:23",
  march: "dawn:7 sunrise:8 morning:10 noon:12 sunset:16 dusk:17 night:19",
  april: "dawn:8 sunrise:9 morning:11 noon:12 sunset:17 dusk:18 night:19",
  may: "dawn:6 sunrise:7 morning:9 noon:12 sunset:18 dusk:20 night:21",
  june: "dawn:5 sunrise:6 morning:8 noon:12 sunset:21 dusk:22 night:23",
  july: "dawn:7 sunrise:8 morning:10 noon:12 sunset:16 dusk:17 night:19",
  august: "dawn:7 sunrise:8 morning:10 noon:11 sunset:19 dusk:20 night:21",
  september: "dawn:7 sunrise:8 morning:9 noon:12 sunset:17 dusk:18 night:19",
  october: "dawn:8 sunrise:9 morning:11 noon:12 sunset:17 dusk:18 night:19",
  november: "dawn:7 sunrise:8 morning:10 noon:12 sunset:18 dusk:20 night:21",
  december: "dawn:8 sunrise:9 noon:12 morning:11 sunset:17 dusk:18 night:19",
};

const currentMonth: string = new Date().toLocaleString("default", { month: "long" }).toLowerCase();
const currentHour: number = new Date().getHours();
const currentTime: string = new Date().toLocaleTimeString();
const currentDate: string = new Date().toLocaleDateString("en-GB").replace(/\//g, "-");
const logFile: string = path.join(os.homedir(), "automac/logs/change_wallpaper.log");
const wallpapersDir: string = path.join(os.homedir(), "Wallpapers");
const settingsFile: string = path.join(os.homedir(), "automac/wallpaper/settings.json");
const wallpaperCountFile: string = path.join(os.homedir(), "automac/wallpaper/history.json");

function getRandomImage(images: string[]): string | undefined {
  return images[0];
}

function saveSettings(settingsFile: string, settings: Settings): void {
  fs.writeFileSync(settingsFile, JSON.stringify(settings, null, 2));
}

function updateWallpaperCount(imagePath: string): void {
  let wallpaperCount: { [key: string]: number } = {};
  if (fs.existsSync(wallpaperCountFile)) {
    wallpaperCount = JSON.parse(fs.readFileSync(wallpaperCountFile, "utf-8"));
  }

  const relativeImagePath = path.relative(wallpapersDir, imagePath);

  if (relativeImagePath in wallpaperCount) {
    wallpaperCount[relativeImagePath] = Number(wallpaperCount[relativeImagePath]) + 1;
  } else {
    wallpaperCount[relativeImagePath] = 1;
  }

  // Sort the object by value (count) in descending order
  const sortedWallpaperCount = Object.fromEntries(Object.entries(wallpaperCount).sort(([, a], [, b]) => b - a));

  fs.writeFileSync(wallpaperCountFile, JSON.stringify(sortedWallpaperCount, null, 2));
}

async function main() {
  let timeOfDay: string = "";
  for (const [period, hour] of MONTHS[currentMonth].split(" ").map((x) => x.split(":"))) {
    if (currentHour >= parseInt(hour)) {
      timeOfDay = period;
    } else {
      break;
    }
  }

  if (!timeOfDay) {
    timeOfDay = "night";
  }

  let settings: Settings = {
    state: { current: "" },
    files: {
      dawn: { length: 0, images: [] },
      sunrise: { length: 0, images: [] },
      morning: { length: 0, images: [] },
      noon: { length: 0, images: [] },
      sunset: { length: 0, images: [] },
      dusk: { length: 0, images: [] },
      night: { length: 0, images: [] },
    },
  };

  if (fs.existsSync(settingsFile)) {
    settings = JSON.parse(fs.readFileSync(settingsFile, "utf-8"));
  }

  const previousState = settings.state.current;

  if (timeOfDay !== previousState) {
    if (settings.files[timeOfDay as keyof Settings["files"]].images.length === 0) {
      console.log("No images found. Running randomize.ts...");
      try {
        await $`bun randomize_images.ts`;
        console.log("Randomize script ran successfully.");
      } catch (error) {
        console.error("Error running script:", error);
      }
    }
    settings = JSON.parse(fs.readFileSync(settingsFile, "utf-8"));

    const fullImagePath = `${wallpapersDir}/${timeOfDay}/${getRandomImage(settings.files[timeOfDay as keyof Settings["files"]].images)}`;

    if (!fullImagePath) {
      await $`echo "[${currentDate} ${currentTime}] No image found" >> ${logFile}`;
      process.exit(1);
    }

    // Remove first element from the array
    settings.files[timeOfDay as keyof Settings["files"]].images.shift();

    const plistFile = path.join(os.homedir(), "Library/Application Support/com.apple.wallpaper/Store/Index.plist");

    if (fs.existsSync(plistFile)) {
      try {
        await $`/usr/libexec/PlistBuddy -c "set AllSpacesAndDisplays:Desktop:Content:Choices:0:Files:0:relative file:///${fullImagePath}" ${plistFile}`.quiet();
        await $`killall WallpaperAgent`.quiet();
      } catch (error) {
        console.error("Error changing wallpaper:", error);
        await $`echo "[${currentDate} ${currentTime}] Error changing wallpaper: ${error}" >> ${logFile}`;
      }
    } else {
      console.log("Plist file not found. Trying alternative method to change wallpaper.");
      try {
        await $`osascript -e 'tell application "Finder" to set desktop picture to POSIX file "${fullImagePath}"'`.quiet();
      } catch (error) {
        console.error("Error changing wallpaper with alternative method:", error);
        await $`echo "[${currentDate} ${currentTime}] Error changing wallpaper with alternative method: ${error}" >> ${logFile}`;
      }
    }

    // Update the wallpaper count
    updateWallpaperCount(fullImagePath);

    settings.state.current = timeOfDay;
    saveSettings(settingsFile, settings);
  } else {
    await $`echo "[${currentDate} ${currentTime}] Skipping update, wallpaper for ${timeOfDay} already set" >> ${logFile}`;
  }
}

main().catch(console.error);
