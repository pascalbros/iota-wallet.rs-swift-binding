import Foundation
import _IOTAWallet

private var walletsCallbacks: [String: WalletEventsManagerCallbacks] = Dictionary()

private class WalletEventsManagerCallbacks {
    var callbacks: [String: IotaCallback] = Dictionary()
    init() { }
}

class WalletEventsManager {
    
    static let shared = WalletEventsManager()
    
    fileprivate(set) var isRunning: Bool = false
    fileprivate var callbacks = WalletEventsManagerCallbacks()
    fileprivate var hasBeenStarted = false
    
    var identifier = "events-manager"//WalletUtils.randomString(length: 8)
    private init() {
        walletsCallbacks[identifier] = callbacks
    }
    
    func start(storagePath: String = URL.libraryDirectory.path) {
        if isRunning {
            stop()
        }
        iota_initialize({ pointer in
            guard let ref = callbacksRef(id: "events-manager") else { return }
            guard let item = pointer?.stringValue else { return }
            log(item)
            guard let decoded = item.decodedResponse else { return }
            guard !decoded.id.isEmpty else { return }
            guard let callback = ref.callbacks[decoded.id] else { return }
            DispatchQueue.main.async {
                callback(item)
            }
            ref.callbacks[decoded.id] = nil
        }, Constants.defaultActorName.pointerValue, storagePath.pointerValue)
        isRunning = true
    }
    
    func stop() {
        guard isRunning else { return }
        iota_destroy(Constants.defaultActorName.pointerValue)
        flushCommands()
        isRunning = false
    }
    
    func sendCommand(id: String, cmd: String, payload: Any?, callback: @escaping ((String) -> Void)) {
        guard isRunning else { return }
        let currentId = WalletUtils.randomId(to: id)
        guard let json = ["actorId": "my-actor", "id": currentId, "cmd": cmd, "payload": payload].json else {
            callback("{\"error\": \"serialization-error\"}")
            return
        }
        callbacks.callbacks[currentId] = callback
        iota_send_message(json)
    }
    
    func flushCommands() {
        callbacks.callbacks.removeAll()
    }
}

private func callbacksRef(id: String) -> WalletEventsManagerCallbacks? {
    walletsCallbacks[id]
}
