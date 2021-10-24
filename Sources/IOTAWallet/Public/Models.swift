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
    weak var accountManager: IOTAAccountManager?
    public let id: String
    public let alias: String
    public internal(set) var addresses: [Address]
    
    private enum CodingKeys: String, CodingKey {
        case id, alias, addresses
    }
}

public struct BalanceResponse: Decodable {
    public let total: Int
    public let available: Int
    public let incoming: Int
    public let outgoing: Int
}

public struct NodeInfoResponse: Decodable {
    public let nodeinfo: NodeInfo
    public let url: String
}

public struct NodeInfo: Decodable {
    public let name: String
    public let version: String
    public let isHealthy: Bool
    public let networkId: String
    public let minPoWScore: Int
    public let messagesPerSecond: Double
    public let referencedMessagesPerSecond: Double
    public let referencedRate: Double
    public let latestMilestoneTimestamp: Int
    public let latestMilestoneIndex: Int
    public let confirmedMilestoneIndex: Int
    public let pruningIndex: Int
    public let features: [String]
}

public struct StrongholdStatus: Decodable {
    //"[IOTAWallet] " ["{\"id\":\"GetStrongholdStatus-z6l496281856\",\"type\":\"StrongholdStatus\",\"payload\":{\"snapshotPath\":\"/Users/pasquale.ambrosini/tmpIOTAWallet/wallet.stronghold\",\"snapshot\":{\"status\":\"Unlocked\",\"data\":{\"secs\":0,\"nanos\":0}}},\"action\":\"GetStrongholdStatus\"}"]
    public struct Snapshot: Decodable {
        public enum Status: String, Decodable {
            case locked = "Locked"
            case unlocked = "Unlocked"
        }
        public struct Data: Decodable {
            public let secs: Int
            public let nanos: Int
        }
        public let status: Status
        public let data: Data?
    }
    public let snapshotPath: String
    public let snapshot: Snapshot
}
