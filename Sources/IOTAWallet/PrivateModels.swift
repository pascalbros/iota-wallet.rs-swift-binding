import Foundation

typealias IotaCallback = (String) -> Void

struct IOTAError: Error { }

struct WalletResponse<T: Decodable>: Decodable {
    let id: String
    let type: String
    let payload: T?
    var isError: Bool { type == "Error" }
}

struct WalletGenericResponse: Decodable {
    let id: String
    let type: String
    var isError: Bool { type == "Error" }
}

struct WalletSyncResponse: Decodable {
    let id: String
    var addresses: [IOTAAccount.Address]
}

struct WalletDuration: Codable {
    let secs: Int
    let nanos: Int
    var dict: [String: Int] { ["secs": secs, "nanos": nanos] }
}
