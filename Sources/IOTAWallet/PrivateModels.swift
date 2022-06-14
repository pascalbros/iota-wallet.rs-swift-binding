import Foundation

typealias IotaCallback = (String) -> Void

struct IOTAError: Error { }

struct WalletResponse<T: Decodable>: Decodable {
    let type: String
    let payload: T?
    var isError: Bool { type == "Error" }
}

struct WalletGenericResponse: Decodable {
    let type: String
    var isError: Bool { type == "Error" }
}

struct WalletSyncResponse: Decodable {
    var publicAddresses: [IOTAAccount.Address]
}

struct WalletDuration: Codable {
    let secs: Int
    let nanos: Int
    var dict: [String: Int] { ["secs": secs, "nanos": nanos] }
}
