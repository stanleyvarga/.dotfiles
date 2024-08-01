import Cocoa
import UniformTypeIdentifiers

// Data Structures

struct WallpaperConfig: Codable {
    var months: [String: [String: Int]]
}

struct CurrentWallpaper: Codable {
    var path: String
    var daytime: String
}

// Constants

let basePath = "/Users/stanislavvarga"
let wallpapersPath = basePath + "/Documents/Wallpapers/"
let automacPath = basePath + "/automac/wallpaper/"
let configFileName = "settings.json"
let currentWallpaperFileName = "current_wallpaper.txt"
let checkInterval: TimeInterval = 5.0 // Check every minute

// Configuration Management

func loadConfig() -> WallpaperConfig? {
    let configURL = URL(fileURLWithPath: automacPath + configFileName)
    do {
        let data = try Data(contentsOf: configURL)
        let decoder = JSONDecoder()
        return try decoder.decode(WallpaperConfig.self, from: data)
    } catch {
        print("Failed to load or parse the config file: \(error.localizedDescription)")
        return nil
    }
}

// Current Wallpaper Management

func getCurrentWallpapers() -> [String: CurrentWallpaper]? {
    let currentWallpaperURL = URL(fileURLWithPath: automacPath + currentWallpaperFileName)
    do {
        let data = try Data(contentsOf: currentWallpaperURL)
        let decoder = JSONDecoder()
        return try decoder.decode([String: CurrentWallpaper].self, from: data)
    } catch {
        print("Failed to read or parse current wallpaper file: \(error.localizedDescription)")
        return nil
    }
}

func setCurrentWallpapers(_ wallpapers: [String: CurrentWallpaper]) {
    let currentWallpaperURL = URL(fileURLWithPath: automacPath + currentWallpaperFileName)
    do {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try encoder.encode(wallpapers)
        try data.write(to: currentWallpaperURL)
    } catch {
        print("Failed to write current wallpaper file: \(error.localizedDescription)")
    }
}

// Wallpaper Management

func setWallpaperBasedOnTime(config: WallpaperConfig) {
    let currentTime = getCurrentTimeOfDay(config: config)
    var currentWallpapers = getCurrentWallpapers() ?? [:]
    
    for (index, screen) in NSScreen.screens.enumerated() {
        let screenID = String(index)
        let currentWallpaper = currentWallpapers[screenID]
        
        if currentWallpaper?.daytime == "night" {
            print("Skipping update for screen \(screenID) as it's set to night")
            continue
        }
        
        if currentWallpaper?.daytime != currentTime {
            if let newWallpaper = selectNewWallpaper(for: currentTime) {
                setWallpaper(for: screen, with: URL(fileURLWithPath: newWallpaper))
                currentWallpapers[screenID] = CurrentWallpaper(path: newWallpaper, daytime: currentTime)
            }
        } else if let path = currentWallpaper?.path {
            setWallpaper(for: screen, with: URL(fileURLWithPath: path))
        }
    }
    
    setCurrentWallpapers(currentWallpapers)
}

func selectNewWallpaper(for timeOfDay: String) -> String? {
    let directoryURL = URL(fileURLWithPath: wallpapersPath + timeOfDay)
    do {
        let fileURLs = try FileManager.default.contentsOfDirectory(at: directoryURL, includingPropertiesForKeys: nil)
        return fileURLs.randomElement()?.path
    } catch {
        print("Failed to read directory: \(error.localizedDescription)")
        return nil
    }
}

func setWallpaper(for screen: NSScreen, with imageURL: URL) {
    do {
        try NSWorkspace.shared.setDesktopImageURL(imageURL, for: screen, options: [:])
    } catch {
        print("Error setting wallpaper: \(error.localizedDescription)")
    }
}

// Helper Functions

func getCurrentTimeOfDay(config: WallpaperConfig) -> String {
    let currentTime = Calendar.current.component(.hour, from: Date())
    let month = Calendar.current.monthSymbols[Calendar.current.component(.month, from: Date()) - 1].lowercased()
    
    let times = config.months[month] ?? config.months["january"]!
    let sortedTimes = times.sorted(by: { $0.value < $1.value })
    
    var selectedTime = "dusk"
    for (time, hour) in sortedTimes {
        if currentTime >= hour {
            selectedTime = time
        }
    }
    
    return selectedTime
}

// Full Screen Status Checker

func checkFullScreenStatus() -> Bool {
    let script = """
    tell application "System Events"
        set listOfProcesses to every application process whose visible is true and value of attribute "AXFullScreen" of window 1 is true
        return listOfProcesses is {}
    end tell
    """
    
    var error: NSDictionary?
    if let scriptObject = NSAppleScript(source: script) {
        let output = scriptObject.executeAndReturnError(&error)
        return output.booleanValue
    } else if let error = error {
        print("Error checking full-screen status: \(error)")
        return false
    }
    return false
}

// Main Execution

func startWallpaperChecker() {
    Timer.scheduledTimer(withTimeInterval: checkInterval, repeats: true) { timer in
        print("Checking wallpaper status...")
        
        if checkFullScreenStatus() {
            if let config = loadConfig() {
                setWallpaperBasedOnTime(config: config)
            }
        }
    }
    
    RunLoop.main.run()
}

startWallpaperChecker()
