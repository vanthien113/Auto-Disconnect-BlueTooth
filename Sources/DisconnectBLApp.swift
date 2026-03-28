import SwiftUI
import ServiceManagement

class AppDelegate: NSObject, NSApplicationDelegate {
    let bluetoothManager = BluetoothManager()
    let lockObserver = ScreenLockObserver()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        lockObserver.onLock = { [weak self] in
            self?.bluetoothManager.disconnectTarget()
        }
        lockObserver.onUnlock = { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self?.bluetoothManager.connectTarget()
            }
        }
    }
}

@main
struct DisconnectBLApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        MenuBarExtra {
            AppMenuView(bluetoothManager: appDelegate.bluetoothManager)
        } label: {
            HStack {
                Image(systemName: "headphones")
                Text("DBL")
            }
        }
    }
}

struct AppMenuView: View {
    @ObservedObject var bluetoothManager: BluetoothManager
    @State private var launchAtLogin = SMAppService.mainApp.status == .enabled
    
    var body: some View {
        Button("Refresh Devices") {
            bluetoothManager.refreshDevices()
        }
        Divider()
        
        if bluetoothManager.pairedDevices.isEmpty {
            Text("No Paired Devices")
        } else {
            ForEach(bluetoothManager.pairedDevices) { device in
                Button(action: {
                    bluetoothManager.targetedDeviceID = device.id
                }) {
                    HStack {
                        Text(device.name)
                        if bluetoothManager.targetedDeviceID == device.id {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        }
        
        Divider()
        if let target = bluetoothManager.pairedDevices.first(where: { $0.id == bluetoothManager.targetedDeviceID }) {
            Text("Target: \(target.name)")
            Text("Status: \(target.isConnected ? "Connected" : "Disconnected")")
        } else {
            Text("Target: None Selected")
        }
        
        Divider()
        
        Toggle("Launch at Login", isOn: $launchAtLogin)
            .onChange(of: launchAtLogin) { newValue in
                do {
                    if newValue {
                        try SMAppService.mainApp.register()
                    } else {
                        try SMAppService.mainApp.unregister()
                    }
                } catch {
                    print("Failed to toggle Launch at Login: \(error)")
                    launchAtLogin = SMAppService.mainApp.status == .enabled
                }
            }
        
        Button("Quit") {
            NSApplication.shared.terminate(nil)
        }
    }
}
