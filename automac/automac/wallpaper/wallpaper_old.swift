import Cocoa
import UniformTypeIdentifiers

// Define a structure to hold configuration for each desktop
struct DesktopConfig: Codable {
    var lastSetTime: String
    var lastWallpaper: String
}

// Load the configuration from the JSON file
struct WallpaperConfig: Codable {
    var months: [String: [String: Int]]
    var desktop: [Int: DesktopConfig]
}

// Helper function to load configuration data from a JSON file
func loadConfig() -> WallpaperConfig? {
    let configURL = URL(fileURLWithPath: "\(automacPath)settings.json")
    do {
        let data = try Data(contentsOf: configURL)
        let decoder = JSONDecoder()
        return try decoder.decode(WallpaperConfig.self, from: data)
    } catch {
        print("Failed to load or parse the config file: \(error.localizedDescription)")
        return nil
    }
}

// Helper function to save the updated configuration to the JSON file
func saveConfig(_ config: WallpaperConfig) {
    let configURL = URL(fileURLWithPath: "\(automacPath)settings.json")
    do {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try encoder.encode(config)
        try data.write(to: configURL)
    } catch {
        print("Failed to save the config file: \(error.localizedDescription)")
    }
}

func setWallpaper(for screen: NSScreen, with imageURL: URL) {
    do {
        try NSWorkspace.shared.setDesktopImageURL(imageURL, for: screen, options: [:])
    } catch {
        print("Error setting wallpaper: \(error.localizedDescription)")
    }
}

let basePath = "/Users/stanislavvarga"
let wallpapersPath = basePath + "/Documents/Wallpapers/"
let automacPath  = basePath + "/automac/wallpaper/"

func setWallpaperBasedOnTime(for screenID: Int) {
    guard var config = loadConfig() else { return }
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

    // Check if the time of day has changed
    if selectedTime != config.desktop[screenID]?.lastSetTime {
        if screenID == 1 {
            setNewWallpaper(for: screenID, selectedTime: selectedTime, config: &config)
        } else {
            copyWallpaperFromScreenOne(to: screenID, config: &config)
        }
        saveConfig(config)
    }
}

func setNewWallpaper(for screenID: Int, selectedTime: String, config: inout WallpaperConfig) {
    let directoryURL = URL(fileURLWithPath: wallpapersPath + selectedTime)
    do {
        let fileURLs = try FileManager.default.contentsOfDirectory(at: directoryURL, includingPropertiesForKeys: nil)
        if let selectedFile = fileURLs.randomElement() {
            if let screen = NSScreen.screens.first(where: { NSScreen.screens.firstIndex(of: $0) == screenID - 1 }) {
                setWallpaper(for: screen, with: selectedFile)
                updateConfigForScreen(screenID: screenID, selectedTime: selectedTime, selectedFile: selectedFile, config: &config)
            }
        } else {
            print("No image files found in directory: \(directoryURL.path)")
        }
    } catch {
        print("Failed to read directory: \(error.localizedDescription)")
    }
}

func copyWallpaperFromScreenOne(to screenID: Int, config: inout WallpaperConfig) {
    guard let screenOneConfig = config.desktop[1],
          !screenOneConfig.lastWallpaper.isEmpty,
          let screen = NSScreen.screens.first(where: { NSScreen.screens.firstIndex(of: $0) == screenID - 1 }) else {
        return
    }
    
    let wallpaperURL = URL(fileURLWithPath: wallpapersPath + screenOneConfig.lastSetTime + "/" + screenOneConfig.lastWallpaper)
    setWallpaper(for: screen, with: wallpaperURL)
    updateConfigForScreen(screenID: screenID, selectedTime: screenOneConfig.lastSetTime, selectedFile: wallpaperURL, config: &config)
}

func updateConfigForScreen(screenID: Int, selectedTime: String, selectedFile: URL, config: inout WallpaperConfig) {
    config.desktop[screenID]?.lastSetTime = selectedTime
    config.desktop[screenID]?.lastWallpaper = selectedFile.lastPathComponent
}

func checkFullScreenStatus() {
    let script = """
    tell application "System Events"
        set listOfProcesses to every application process whose visible is true and value of attribute "AXFullScreen" of window 1 is true
        return listOfProcesses is {}
    end tell
    """
    
    var error: NSDictionary?
    if let scriptObject = NSAppleScript(source: script) {
        let output = scriptObject.executeAndReturnError(&error)
        if output.booleanValue {
            for screenID in 1...NSScreen.screens.count {
                setWallpaperBasedOnTime(for: screenID)
            }
        }
    } else if let error = error {
        print("Error checking full-screen status: \(error)")
    }
}

Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { timer in
    print("Checking full-screen status...")

    // print out id's of each screen
    for (index, screen) in NSScreen.screens.enumerated() {
        print("Screen \(index + 1): \(screen)")
    }

    checkFullScreenStatus()
}

RunLoop.main.run()
