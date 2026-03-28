import Foundation

class ScreenLockObserver: ObservableObject {
    var onLock: (() -> Void)?
    var onUnlock: (() -> Void)?
    
    init() {
        let dnc = DistributedNotificationCenter.default()
        dnc.addObserver(forName: NSNotification.Name("com.apple.screenIsLocked"), object: nil, queue: .main) { _ in
            print("Screen is locked")
            self.onLock?()
        }
        
        dnc.addObserver(forName: NSNotification.Name("com.apple.screenIsUnlocked"), object: nil, queue: .main) { _ in
            print("Screen is unlocked")
            self.onUnlock?()
        }
    }
    
    deinit {
        DistributedNotificationCenter.default().removeObserver(self)
    }
}
