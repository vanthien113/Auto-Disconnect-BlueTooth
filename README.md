# DisconnectBL (Bluetooth Auto-Disconnect Tool)

DisconnectBL is a lightweight macOS utility designed to automatically manage your Bluetooth device connections when your screen locks or unlocks. This is especially useful for headphones or earphones that you want to disconnect when stepping away from your Mac, allowing them to freely connect to your phone or other devices.

## Features
- **Auto-Disconnect on Lock**: Instantly disconnects your selected Bluetooth device when you lock the screen or put the Mac to sleep.
- **Auto-Reconnect on Unlock**: Automatically reconnects to the device when you unlock the Mac. It includes a smart retry mechanism to ensure successful reconnection even if the Bluetooth module takes a few moments to wake up.
- **Menu Bar App**: A clean, native SwiftUI menu bar interface.
- **Launch at Login**: Easily configure the app to start automatically when you log into your Mac directly from the menu.

## Requirements
- macOS 13.0 or later (utilizes modern `ServiceManagement` for launch-at-login behavior).

## How to Build
The project is built using native Swift tools via the command line, keeping the structure simple without requiring a heavy Xcode project setup.

Simply run the included script:
```bash
./build.sh
```

This will:
1. Compile the Swift source files.
2. Bundle the modern custom App Icon (`.icns`).
3. Generate the required `Info.plist`.
4. Sign the application.

The output will be an executable `DisconnectBL.app` bundle right in the project directory.

## Usage
1. Open the application. A headphone icon will appear in your Mac's menu bar.
2. Click the menu bar icon to view the list of paired Bluetooth devices.
3. Select the device you want the app to manage. A checkmark will appear next to it to indicate the current target.
4. You can easily test it by locking your screen (`Control + Command + Q`). Your device will disconnect immediately. Unlock your screen to see it automatically reconnect!
5. Toggle "Launch at Login" if you want the app to run in the background every time you start your Mac.

## Tech Stack
- **SwiftUI** for the user interface.
- **IOBluetooth** for low-level connection management.
- **DistributedNotificationCenter** for listening to system lock/unlock events.
