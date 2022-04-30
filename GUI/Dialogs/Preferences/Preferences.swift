// -----------------------------------------------------------------------------
// This file is part of VirtualC64
//
// Copyright (C) Dirk W. Hoffmann. www.dirkwhoffmann.de
// Licensed under the GNU General Public License v3
//
// See https://www.gnu.org for license information
// -----------------------------------------------------------------------------

/* This class stores all emulator settings that belong to the application level.
 * There is a single object of this class stored in the application delegate.
 * The object is shared among all emulator instances.
 *
 * See class "Configuration" for instance specific settings.
 */

class Preferences {
        
    //
    // General
    //

    // Snapshots
    var autoSnapshots = false {
        didSet { for c in myAppDelegate.controllers { c.validateSnapshotTimer() } }
    }
    var snapshotInterval = 0 {
        didSet { for c in myAppDelegate.controllers { c.validateSnapshotTimer() } }
    }

    // Screenshots
    var screenshotSource = 0
    var screenshotTarget = NSBitmapImageRep.FileType.png
    var screenshotTargetIntValue: Int {
        get { return Int(screenshotTarget.rawValue) }
        set { screenshotTarget = NSBitmapImageRep.FileType(rawValue: UInt(newValue))! }
    }
    
    // Screen captures
    var ffmpegPath = "" {
        didSet {
            for amiga in myAppDelegate.proxies {
                amiga.recorder.path = ffmpegPath
            }
        }
    }
    var captureSource = 0
    var bitRate = 512 {
        didSet {
            if bitRate < 64 { bitRate = 64 }
            if bitRate > 16384 { bitRate = 16384 }
        }
    }
    var aspectX = 768 {
        didSet {
            if aspectX < 1 { aspectX = 1 }
            if aspectX > 999 { aspectX = 999 }
        }
    }
    var aspectY = 702 {
        didSet {
            if aspectY < 1 { aspectY = 1 }
            if aspectY > 999 { aspectY = 999 }
        }
    }
    
    // Fullscreen
    var keepAspectRatio = false
    var exitOnEsc = false

    // Warp mode
    var warpMode = WarpMode.off {
        didSet { for c in myAppDelegate.controllers { c.updateWarp() } }
    }
    var warpModeIntValue: Int {
        get { return Int(warpMode.rawValue) }
        set { warpMode = WarpMode(rawValue: newValue)! }
    }
    
    // Misc
    var ejectWithoutAsking = false
    var closeWithoutAsking = false
    var pauseInBackground = false

    //
    // Controls
    //
    
    // Emulation keys
    var keyMaps: [[MacKey: Int]] = [ [:], [:], [:] ]

    // Joystick
    var disconnectJoyKeys = false
    var autofire = false {
        didSet {
            for c64 in myAppDelegate.proxies {
                c64.configure(.AUTOFIRE, enable: autofire)
            }
        }
    }
    var autofireBullets = 0 {
        didSet {
            for c64 in myAppDelegate.proxies {
                c64.configure(.AUTOFIRE_BULLETS, value: autofireBullets)
            }
        }
    }
    var autofireFrequency = 1.0 {
        didSet {
            let autofireDelay = Int(50.0 / autofireFrequency)
            for c64 in myAppDelegate.proxies {
                c64.configure(.AUTOFIRE_DELAY, value: autofireDelay)
            }
        }
    }
    
    // Mouse
    var retainMouseKeyComb = 0
    var retainMouseWithKeys = false
    var retainMouseByClick = false
    var retainMouseByEntering = false
    var releaseMouseKeyComb = 0
    var releaseMouseWithKeys = false
    var releaseMouseByShaking = false

    //
    // Keyboard
    //
    
    // Mapping
    var mapKeysByPosition = false
    var keyMap: [MacKey: C64Key] = [:]
    
    //
    // General
    //

    /*
    func loadGeneralUserDefaults() {
        
        let defaults = UserDefaults.standard
                        
        // Snapshots
        autoSnapshots = defaults.bool(forKey: Keys.Gen.autoSnapshots)
        snapshotInterval = defaults.integer(forKey: Keys.Gen.autoSnapshotInterval)

        // Screenshots
        screenshotSource = defaults.integer(forKey: Keys.Gen.screenshotSource)
        screenshotTargetIntValue = defaults.integer(forKey: Keys.Gen.screenshotTarget)
        
        // Captures
        captureSource = defaults.integer(forKey: Keys.Gen.captureSource)
        bitRate = defaults.integer(forKey: Keys.Gen.bitRate)
        aspectX = defaults.integer(forKey: Keys.Gen.aspectX)
        aspectY = defaults.integer(forKey: Keys.Gen.aspectY)

        // Fullscreen
        keepAspectRatio = defaults.bool(forKey: Keys.Gen.keepAspectRatio)
        exitOnEsc = defaults.bool(forKey: Keys.Gen.exitOnEsc)

        // Warp mode
        warpModeIntValue = defaults.integer(forKey: Keys.Gen.warpMode)
        
        // Misc
        ejectWithoutAsking = defaults.bool(forKey: Keys.Gen.ejectWithoutAsking)
        pauseInBackground = defaults.bool(forKey: Keys.Gen.pauseInBackground)
        closeWithoutAsking = defaults.bool(forKey: Keys.Gen.closeWithoutAsking)
    }
    
    func saveGeneralUserDefaults() {
        
        let defaults = UserDefaults.standard
                
        // Snapshots
        defaults.set(autoSnapshots, forKey: Keys.Gen.autoSnapshots)
        defaults.set(snapshotInterval, forKey: Keys.Gen.autoSnapshotInterval)

        // Screenshots
        defaults.set(screenshotSource, forKey: Keys.Gen.screenshotSource)
        defaults.set(screenshotTargetIntValue, forKey: Keys.Gen.screenshotTarget)

        // Captures
        defaults.set(captureSource, forKey: Keys.Gen.captureSource)
        defaults.set(bitRate, forKey: Keys.Gen.bitRate)
        defaults.set(aspectX, forKey: Keys.Gen.aspectX)
        defaults.set(aspectY, forKey: Keys.Gen.aspectY)

        // Fullscreen
        defaults.set(keepAspectRatio, forKey: Keys.Gen.keepAspectRatio)
        defaults.set(exitOnEsc, forKey: Keys.Gen.exitOnEsc)

        // Warp mode
        defaults.set(warpModeIntValue, forKey: Keys.Gen.warpMode)
        
        // Misc
        defaults.set(ejectWithoutAsking, forKey: Keys.Gen.driveEjectUnasked)
        defaults.set(pauseInBackground, forKey: Keys.Gen.pauseInBackground)
        defaults.set(closeWithoutAsking, forKey: Keys.Gen.closeWithoutAsking)
    }
    */

    //
    // Controls
    //

    /*
    func loadControlsUserDefaults() {
        
        let defaults = UserDefaults.standard
        
        // Emulation keys
        defaults.decode(&keyMaps[0], forKey: Keys.Con.mouseKeyMap)
        defaults.decode(&keyMaps[1], forKey: Keys.Con.joyKeyMap1)
        defaults.decode(&keyMaps[2], forKey: Keys.Con.joyKeyMap2)
        disconnectJoyKeys = defaults.bool(forKey: Keys.Con.disconnectJoyKeys)
        
        // Joysticks
        autofire = defaults.bool(forKey: Keys.Con.autofire)
        autofireBullets = defaults.integer(forKey: Keys.Con.autofireBullets)
        autofireFrequency = defaults.float(forKey: Keys.Con.autofireFrequency)
        
        // Mouse
        retainMouseKeyComb = defaults.integer(forKey: Keys.Con.retainMouseKeyComb)
        retainMouseWithKeys = defaults.bool(forKey: Keys.Con.retainMouseWithKeys)
        retainMouseByClick = defaults.bool(forKey: Keys.Con.retainMouseByClick)
        retainMouseByEntering = defaults.bool(forKey: Keys.Con.retainMouseByEntering)
        releaseMouseKeyComb = defaults.integer(forKey: Keys.Con.releaseMouseKeyComb)
        releaseMouseWithKeys = defaults.bool(forKey: Keys.Con.releaseMouseWithKeys)
        releaseMouseByShaking = defaults.bool(forKey: Keys.Con.releaseMouseByShaking)
    }

    func saveControlsUserDefaults() {
        
        let defaults = UserDefaults.standard
        
        // Emulation keys
        defaults.encode(keyMaps[0], forKey: Keys.Con.mouseKeyMap)
        defaults.encode(keyMaps[1], forKey: Keys.Con.joyKeyMap1)
        defaults.encode(keyMaps[2], forKey: Keys.Con.joyKeyMap2)
        defaults.set(disconnectJoyKeys, forKey: Keys.Con.disconnectJoyKeys)
        
        // Joysticks
        defaults.set(autofire, forKey: Keys.Con.autofire)
        defaults.set(autofireBullets, forKey: Keys.Con.autofireBullets)
        defaults.set(autofireFrequency, forKey: Keys.Con.autofireFrequency)
        
        // Mouse
        defaults.set(retainMouseKeyComb, forKey: Keys.Con.retainMouseKeyComb)
        defaults.set(retainMouseWithKeys, forKey: Keys.Con.retainMouseWithKeys)
        defaults.set(retainMouseByClick, forKey: Keys.Con.retainMouseByClick)
        defaults.set(retainMouseByEntering, forKey: Keys.Con.retainMouseByEntering)
        defaults.set(releaseMouseKeyComb, forKey: Keys.Con.releaseMouseKeyComb)
        defaults.set(releaseMouseWithKeys, forKey: Keys.Con.releaseMouseWithKeys)
        defaults.set(releaseMouseByShaking, forKey: Keys.Con.releaseMouseByShaking)
    }
    */
    
    //
    // Devices
    //

    /*
    func loadDevicesUserDefaults() {
        
    }
    
    func saveDevicesUserDefaults() {
        
    }
    */
    
    //
    // Keyboard
    //

    /*
    func loadKeyboardUserDefaults() {
        
        let defaults = UserDefaults.standard
        mapKeysByPosition = defaults.bool(forKey: Keys.Kbd.mapKeysByPosition)
        defaults.decode(&keyMap, forKey: Keys.Kbd.keyMap)
        
        // Remove double mappings (if any)
        var values: [Int] = []
        for (k, v) in keyMap {
            if values.contains(v.nr) {
                track("Removing conflicting key map assignment \(k.keyCode) -> \(v.nr)")
                keyMap[k] = nil
            }
            values.append(v.nr)
        }
    }
    
    func saveKeyboardUserDefaults() {
        
        let defaults = UserDefaults.standard
        defaults.encode(keyMap, forKey: Keys.Kbd.keyMap)
        defaults.set(mapKeysByPosition, forKey: Keys.Kbd.mapKeysByPosition)
    }
    */
}