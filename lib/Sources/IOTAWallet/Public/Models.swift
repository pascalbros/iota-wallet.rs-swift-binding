import Foundation

public struct IOTAResponseError: Error, Decodable {
    
    public struct Details: Decodable {
        public let type: String
        public let error: String
    }
    static let unknown = IOTAResponseError(type: "Unknown", payload: Details(type: "", error: ""))
    public let type: String
    public let payload: Details
    static func decode(from: String) -> IOTAResponseError {
        IOTAResponseError.decode(from) ?? IOTAResponseError.unknown
    }
}

public enum LogLevel: Int {
    case none
    case errors
    case warnings
    case debug
}

public enum SignerType: String {
    case stronghold = "Stronghold"
}

public struct IOTAAccount: Decodable {
    
    public struct Address: Decodable {
        let address: String
        let balance: Int
        let keyIndex: Int
    }
    
    let id: String
    let alias: String
    let addresses: [Address]
}
