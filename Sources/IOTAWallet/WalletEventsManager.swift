import Foundation
import _IOTAWallet

private var walletsCallbacks: [String: WalletEventsManagerCallbacks] = Dictionary()

private class WalletEventsManagerCallbacks {
    var callbacks: [String: IotaCallback] = Dictionary()
    init() { }
}

func onMessage(_ pointer: UnsafePointer<CChar>?) {
    guard let item = pointer?.stringValue else { return }
    log(item)
    guard let decoded = item.decodedResponse else { return }
    let refId = decoded.id.suffix(8)
    guard let ref = callbacksRef(id: String(refId)) else { return }
    guard !decoded.id.isEmpty else { return }
    guard let callback = ref.callbacks[decoded.id] else { return }
    DispatchQueue.main.async {
        callback(item)
    }
    ref.callbacks[decoded.id] = nil
}

class WalletEventsManager {
    
    static let shared = WalletEventsManager()
    
    fileprivate(set) var isRunning: Bool = false
    fileprivate var callbacks = WalletEventsManagerCallbacks()
    fileprivate var hasBeenStarted = false
    fileprivate(set) var storagePath: String = URL.libraryDirectory.path
    fileprivate(set) var identifier: String
    
    init() {
        identifier = WalletEventsManager.generateId(path: storagePath)
    }
    
    fileprivate func setup() {
        identifier = WalletEventsManager.generateId(path: storagePath)
        walletsCallbacks[identifier] = callbacks
    }
    
    static func generateId(path: String) -> String { String("\(path.hashValue)".suffix(8)) }
    
    func start(storagePath: String = URL.libraryDirectory.path) {
        if isRunning && storagePath == self.storagePath &&
            FileManager.default.fileExists(atPath: storagePath) { return }
        if isRunning {
            stop()
        }
        setup()
        iota_initialize(onMessage(_:), identifier.pointerValue, storagePath.pointerValue)
        isRunning = true
    }
    
    func stop() {
        guard isRunning else { return }
        iota_destroy(identifier.pointerValue)
        flushCommands()
        isRunning = false
    }
    
    func sendCommand(id: String, cmd: String, payload: Any?, callback: @escaping ((String) -> Void)) {
        guard isRunning else { return }
        let currentId = WalletUtils.randomId(from: id)+identifier
        guard let json = ["actorId": identifier, "id": currentId, "cmd": cmd, "payload": payload].json else {
            callback("{\"error\": \"serialization-error\"}")
            return
        }
        callbacks.callbacks[currentId] = callback
        iota_send_message(json)
    }
    
    func flushCommands() {
        callbacks.callbacks.removeAll()
        walletsCallbacks[identifier] = nil
    }
}

private func callbacksRef(id: String) -> WalletEventsManagerCallbacks? {
    walletsCallbacks[id]
}
