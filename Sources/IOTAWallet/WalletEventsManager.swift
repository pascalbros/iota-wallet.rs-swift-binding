import Foundation
import _IOTAWallet

struct ManagerOptions: Codable {
    var storagePath: String?
    var clientOptions: String?
    var secretManager: String?
}

struct IOTANode: Codable {
    let url: String
    let auth: String?
    let disabled: Bool
}

struct ClientOption: Codable {
    let localPow: Bool
    let apiTimeout: WalletDuration
    let nodes: [IOTANode]
    
    var json: String {
        let json = try! JSONEncoder().encode(self)
        return String(data: json, encoding: .utf8)!
    }
}

struct SecretManager: Codable {
    let Mnemonic: String
    
    var json: String {
        let json = try! JSONEncoder().encode(self)
        return String(data: json, encoding: .utf8)!
    }
}

func managerOptions(nodeUrl: String = "https://localhost", secretManager: String?, storagePath: String, apiTimeoutInSeconds: Int = 20) -> ManagerOptions {
    let secretManager = SecretManager(Mnemonic: secretManager!).json
    let clientOptions = ClientOption(localPow: true, apiTimeout: WalletDuration(secs: apiTimeoutInSeconds, nanos: 0), nodes: [IOTANode(url: nodeUrl, auth: nil, disabled: false)]).json
    
    return ManagerOptions(storagePath: storagePath, clientOptions: clientOptions, secretManager: secretManager)
}

class MessageHandler {
    var handler: ((String) -> Void)
    init(_ handler: @escaping ((String) -> Void)) {
        self.handler = handler
    }
}

func onCallback(_ response: UnsafePointer<CChar>?, _ error: UnsafePointer<CChar>?, _ context: UnsafeMutableRawPointer!) {
    func decodeContext(response: String) {
        let obj = Unmanaged<MessageHandler>.fromOpaque(context).takeUnretainedValue()
        obj.handler(response)
    }
    guard let response = response?.stringValue ?? error?.stringValue else {
        decodeContext(response: "")
        return
    }
    decodeContext(response: response)
    log(String(utf8String: response) ?? "")
}

class WalletEventsManager {
    fileprivate(set) var isRunning: Bool = false
    fileprivate var hasBeenStarted = false
    fileprivate(set) var storagePath: String = URL.libraryDirectory.path
    fileprivate(set) var identifier: String
    
    var handler: OpaquePointer?
    
    init(storagePath: String = URL.libraryDirectory.path, secretManager: String, nodeUrl: String) {
        self.storagePath = storagePath
        identifier = WalletEventsManager.generateId(path: storagePath)
        let json = try! JSONEncoder().encode(managerOptions(nodeUrl: nodeUrl, secretManager: secretManager, storagePath: storagePath))
        let options = String(data: json, encoding: .utf8)!
        let errorMessagePointer = String(repeating: " ", count: 1024).mutablePointerValue
        handler = iota_initialize(options.pointerValue, errorMessagePointer, MemoryLayout<CChar>.size)
        if handler != nil {
            isRunning = true
        }
    }
    
    fileprivate func setup() {
        identifier = WalletEventsManager.generateId(path: storagePath)
    }
    
    static func generateId(path: String) -> String { String("\(path.hashValue)".suffix(8)) }
    
    func stop() {
        guard isRunning else { return }
        guard let handler = handler else { return }
        iota_destroy(handler)
        isRunning = false
    }
    
    func sendCommand(id: String, cmd: String, payload: Any?, callback: @escaping ((String) -> Void)) {
        guard isRunning else { return }
        let currentId = WalletUtils.randomId(from: id)+identifier
        guard let json = ["actorId": identifier, "id": currentId, "cmd": cmd, "payload": payload].json else {
            callback("{\"error\": \"serialization-error\"}")
            return
        }
        let messageHandler = Unmanaged.passRetained(MessageHandler(callback))
        iota_send_message(handler, json.pointerValue, onCallback, messageHandler.toOpaque())
    }
}
