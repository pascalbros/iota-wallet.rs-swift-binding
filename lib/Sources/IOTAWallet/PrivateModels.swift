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

