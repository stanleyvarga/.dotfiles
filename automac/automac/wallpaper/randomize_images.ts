#!/usr/bin/env ts-node

import { $, fs, os, path } from "zx";

$.shell = "/usr/bin/zsh";

interface DayTime {
  length: number;
  images: string[];
}

interface Settings {
  state?: { wallpaper: string };
  total: number;
  files: {
    [key: string]: DayTime;
  };
}

const wallpapersDir = path.join(os.homedir(), "Wallpapers");
const settingsFile = `${process.env.HOME}/automac/wallpaper/settings.json`;

export function saveSettings(settingsFile: string, settings: Settings): void {
  fs.writeFileSync(settingsFile, JSON.stringify(settings, null, 2));
}

function getImageFiles(dir: string): string[] {
  return fs
    .readdirSync(dir)
    .filter((file: string) => /\.(jpg|jpeg|png)$/i.test(file))
    .map((file: string) => path.join(file));
}

function shuffleArray<T>(array: T[]): T[] {
  for (let i = array.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [array[i], array[j]] = [array[j], array[i]];
  }
  return array;
}

let settings: Settings = {
  total: 0,
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

// Ensure all expected directories are in settings
Object.keys(settings.files).forEach((dir) => {
  if (!settings.files[dir]) {
    settings.files[dir] = { length: 0, images: [] };
  }
});

let updatedDirs = 0;
let totalLength = 0;

Object.keys(settings.files).forEach((dir) => {
  const dirPath = path.join(wallpapersDir, dir);
  if (fs.existsSync(dirPath)) {
    const images: string[] = getImageFiles(dirPath);
    const currentLength = images.length;
    totalLength += currentLength;

    if (settings.files[dir].length !== currentLength || settings.files[dir].images.length === 0) {
      console.log(`Updating ${dir} image list...`);
      settings.files[dir] = {
        length: currentLength,
        images: shuffleArray(images),
      };
      updatedDirs++;
    } else {
      console.log(`${dir} image list is up to date.`);
    }
  } else {
    console.log(`Directory ${dir} does not exist. Resetting its settings.`);
    settings.files[dir] = { length: 0, images: [] };
    updatedDirs++;
  }
});

settings.total = totalLength;

if (updatedDirs > 0) {
  console.log(`Updated ${updatedDirs} directory/directories.`);
} else {
  console.log("All directories are up to date.");
}

// Save updated settings
saveSettings(settingsFile, settings);
