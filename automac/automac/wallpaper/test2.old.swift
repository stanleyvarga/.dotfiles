import Cocoa
import UniformTypeIdentifiers

// Data Structures

struct WallpaperConfig: Codable {
    var months: [String: [String: Int]]
}

struct CurrentWallpaper: Codable {
    var socWallpaper: String
    var screens: [String: ScreenWallpaper]
}

struct ScreenWallpaper: Codable {
    var daytime: String
    var wallpaper: String
}

// Constants

let basePath = "/Users/stanislavvarga"
let wallpapersPath = basePath + "/Documents/Wallpapers/"
let automacPath = basePath + "/automac/wallpaper/"
let configFileName = "settings.json"
let currentWallpaperFileName = "current_wallpaper.json"
let checkInterval: TimeInterval = 5.0 // Check every 5 seconds

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

func getCurrentWallpapers() -> CurrentWallpaper? {
    let currentWallpaperURL = URL(fileURLWithPath: automacPath + currentWallpaperFileName)
    do {
        let data = try Data(contentsOf: currentWallpaperURL)
        let decoder = JSONDecoder()
        var currentWallpapers = try decoder.decode(CurrentWallpaper.self, from: data)
				print("Current wallpaper \(currentWallpapers)")
        
        // Ensure all screens are initialized
        // for screenID in NSScreen.screens.indices.map({ String($0) }) {
        //     if currentWallpapers.screens[screenID] == nil {
        //         currentWallpapers.screens[screenID] = ScreenWallpaper(daytime: "", wallpaper: "")
        //     }
        // }
        
        return currentWallpapers
    } catch {
        print("Failed to read or parse current wallpaper file: \(error.localizedDescription)")
        return nil
    }
}


func setCurrentWallpapers(_ wallpapers: CurrentWallpaper) {
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
    guard var currentWallpapers = getCurrentWallpapers() else { return }
    
    var needUpdate = false
    
    // Handle empty or non-existent `socWallpaper`
    if currentWallpapers.socWallpaper.isEmpty || !FileManager.default.fileExists(atPath: currentWallpapers.socWallpaper) {
        if let newWallpaper = selectNewWallpaper(for: currentTime) {
            currentWallpapers.socWallpaper = newWallpaper
            needUpdate = true
        }
        print("Set new socWallpaper: \(currentWallpapers.socWallpaper)")
    }
    
    for (index, screen) in NSScreen.screens.enumerated() {
        let screenID = String(index)
        var currentScreenWallpaper = currentWallpapers.screens[screenID]!
        
        // Handle empty `daytime`, `wallpaper`, mismatch, or non-existent wallpaper
        if currentScreenWallpaper.daytime.isEmpty || 
           currentScreenWallpaper.wallpaper.isEmpty || 
           currentScreenWallpaper.wallpaper != currentWallpapers.socWallpaper || 
           !FileManager.default.fileExists(atPath: currentScreenWallpaper.wallpaper) {
            
            currentScreenWallpaper.daytime = currentTime
            currentScreenWallpaper.wallpaper = currentWallpapers.socWallpaper
            needUpdate = true
            print("Updated screen \(screenID) with new wallpaper: \(currentScreenWallpaper.wallpaper)")
        } else {
            print("Screen \(screenID) already has the correct wallpaper: \(currentScreenWallpaper.wallpaper)")
        }
        
        setWallpaper(for: screen, with: URL(fileURLWithPath: currentScreenWallpaper.wallpaper))
        currentWallpapers.screens[screenID] = currentScreenWallpaper
    }
    
    if needUpdate {
        setCurrentWallpapers(currentWallpapers)
    }
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
				
				for (index, screen) in NSScreen.screens.enumerated() {
					print("Screen \(index + 1): \(screen)")
        }
        
        if checkFullScreenStatus() {
            if let config = loadConfig() {
                setWallpaperBasedOnTime(config: config)
            }
        }
    }
    
    RunLoop.main.run()
}

startWallpaperChecker()
