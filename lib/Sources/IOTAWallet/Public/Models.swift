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

public class IOTAAccount: Decodable {
    
    public struct Address: Decodable, Hashable {
        public let address: String
        public let balance: Int
        public let keyIndex: Int
        
        public static func == (lhs: Address, rhs: Address) -> Bool {
            return lhs.address == rhs.address
        }
    }
    
    public let id: String
    public let alias: String
    public internal(set) var addresses: [Address]
}
