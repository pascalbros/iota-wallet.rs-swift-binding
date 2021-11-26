import Foundation

// MARK: - TransferResponsePayload
public struct TransferResponse: Codable {
    public let id: String
    public let version: Int
    public let parents: [String]
    public let payloadLength: Int
    public let payload: TransferPayload
    public let timestamp: String
    public let nonce: Int
    public let broadcasted: Bool
    public let reattachmentMessageID: String?

    public enum CodingKeys: String, CodingKey {
        case id, version, parents, payloadLength, payload, timestamp, nonce, broadcasted
        case reattachmentMessageID = "reattachmentMessageId"
    }
}

// MARK: - TransferPayload
public struct TransferPayload: Codable {
    public let type: String
    public let data: TransferPayloadData
}

// MARK: - TransferPayloadData
public struct TransferPayloadData: Codable {
    public let essence: TransferEssence
    public let unlockBlocks: [TransferUnlockBlock]

    public enum CodingKeys: String, CodingKey {
        case essence
        case unlockBlocks = "unlock_blocks"
    }
}

// MARK: - TransferEssence
public struct TransferEssence: Codable {
    public let type: String
    public let data: TransferEssenceData
}

// MARK: - TransferEssenceData
public struct TransferEssenceData: Codable {
    public let inputs: [TransferInput]
    public let outputs: [TransferOutput]
    //public let payload: String?
    public let dataInternal, incoming: Bool
    public let value, remainderValue: Int

    public enum CodingKeys: String, CodingKey {
        case inputs, outputs
        case dataInternal = "internal"
        case incoming, value, remainderValue
    }
}

// MARK: - TransferInput
public struct TransferInput: Codable {
    public let type: String
    public let data: TransferInputData
}

// MARK: - TransferInputData
public struct TransferInputData: Codable {
    public let input: String
    public let metadata: TransferMetadata
}

// MARK: - TransferMetadata
public struct TransferMetadata: Codable {
    public let transactionID, messageID: String
    public let index, amount: Int
    public let isSpent: Bool
    public let address, kind: String

    public enum CodingKeys: String, CodingKey {
        case transactionID = "transactionId"
        case messageID = "messageId"
        case index, amount, isSpent, address, kind
    }
}

// MARK: - TransferOutput
public struct TransferOutput: Codable {
    public let type: String
    public let data: TransferOutputData
}

// MARK: - TransferOutputData
public struct TransferOutputData: Codable {
    public let address: String
    public let amount: Int
    public let remainder: Bool
}

// MARK: - TransferUnlockBlock
public struct TransferUnlockBlock: Codable {
    public let type: String
    public let data: TransferUnlockBlockData
}

// MARK: - TransferUnlockBlockData
public struct TransferUnlockBlockData: Codable {
    public let type: String
    public let data: TransferData
}

// MARK: - TransferDataData
public struct TransferData: Codable {
    public let publicKey, signature: [Int]

    public enum CodingKeys: String, CodingKey {
        case publicKey = "public_key"
        case signature
    }
}
