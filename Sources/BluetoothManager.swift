import Foundation
import IOBluetooth
import Combine

class BluetoothDevice: Identifiable, ObservableObject, Hashable {
    let rawDevice: IOBluetoothDevice
    let id: String
    
    @Published var name: String
    @Published var isConnected: Bool
    
    init(device: IOBluetoothDevice) {
        self.rawDevice = device
        self.id = device.addressString ?? UUID().uuidString
        self.name = device.name ?? "Unknown Device"
        self.isConnected = device.isConnected()
    }
    
    func connect() -> Bool {
        let result = rawDevice.openConnection()
        DispatchQueue.main.async {
            self.isConnected = self.rawDevice.isConnected()
        }
        return result == kIOReturnSuccess
    }
    
    func disconnect() -> Bool {
        let result = rawDevice.closeConnection()
        DispatchQueue.main.async {
            self.isConnected = self.rawDevice.isConnected()
        }
        return result == kIOReturnSuccess
    }

    static func == (lhs: BluetoothDevice, rhs: BluetoothDevice) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

class BluetoothManager: ObservableObject {
    @Published var pairedDevices: [BluetoothDevice] = []
    @Published var targetedDeviceID: String? = nil {
        didSet {
            UserDefaults.standard.set(targetedDeviceID, forKey: "TargetedDeviceID")
        }
    }
    
    init() {
        self.targetedDeviceID = UserDefaults.standard.string(forKey: "TargetedDeviceID")
        refreshDevices()
    }
    
    func refreshDevices() {
        if let devices = IOBluetoothDevice.pairedDevices() as? [IOBluetoothDevice] {
            DispatchQueue.main.async {
                self.pairedDevices = devices.map { BluetoothDevice(device: $0) }
            }
        }
    }
    
    func disconnectTarget() {
        guard let id = targetedDeviceID else { return }
        if let device = pairedDevices.first(where: { $0.id == id }), device.isConnected {
            print("Disconnecting target: \(device.name)")
            let _ = device.disconnect()
            refreshDevices()
        }
    }
    
    func connectTarget(retries: Int = 3, delay: TimeInterval = 3.0) {
        guard let id = targetedDeviceID else { return }
        if let device = pairedDevices.first(where: { $0.id == id }) {
            if device.rawDevice.isConnected() {
                DispatchQueue.main.async {
                    device.isConnected = true
                }
                return
            }
            
            print("Connecting target: \(device.name)")
            DispatchQueue.global().async {
                let success = device.connect()
                if success {
                    DispatchQueue.main.async {
                        self.refreshDevices()
                    }
                } else if retries > 0 {
                    print("Connect failed, retrying in \(delay)s...")
                    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                        self.connectTarget(retries: retries - 1, delay: delay)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.refreshDevices()
                    }
                }
            }
        }
    }
}
