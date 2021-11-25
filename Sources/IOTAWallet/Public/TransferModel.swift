import Foundation

// MARK: - TransferResponsePayload
struct TransferResponse: Codable {
    let id: String
    let version: Int
    let parents: [String]
    let payloadLength: Int
    let payload: TransferPayload
    let timestamp: String
    let nonce: Int
    let broadcasted: Bool
    let reattachmentMessageID: String?

    enum CodingKeys: String, CodingKey {
        case id, version, parents, payloadLength, payload, timestamp, nonce, broadcasted
        case reattachmentMessageID = "reattachmentMessageId"
    }
}

// MARK: - TransferPayload
struct TransferPayload: Codable {
    let type: String
    let data: TransferPayloadData
}

// MARK: - TransferPayloadData
struct TransferPayloadData: Codable {
    let essence: TransferEssence
    let unlockBlocks: [TransferUnlockBlock]

    enum CodingKeys: String, CodingKey {
        case essence
        case unlockBlocks = "unlock_blocks"
    }
}

// MARK: - TransferEssence
struct TransferEssence: Codable {
    let type: String
    let data: TransferEssenceData
}

// MARK: - TransferEssenceData
struct TransferEssenceData: Codable {
    let inputs: [TransferInput]
    let outputs: [TransferOutput]
    //let payload: String?
    let dataInternal, incoming: Bool
    let value, remainderValue: Int

    enum CodingKeys: String, CodingKey {
        case inputs, outputs, payload
        case dataInternal = "internal"
        case incoming, value, remainderValue
    }
}

// MARK: - TransferInput
struct TransferInput: Codable {
    let type: String
    let data: TransferInputData
}

// MARK: - TransferInputData
struct TransferInputData: Codable {
    let input: String
    let metadata: TransferMetadata
}

// MARK: - TransferMetadata
struct TransferMetadata: Codable {
    let transactionID, messageID: String
    let index, amount: Int
    let isSpent: Bool
    let address, kind: String

    enum CodingKeys: String, CodingKey {
        case transactionID = "transactionId"
        case messageID = "messageId"
        case index, amount, isSpent, address, kind
    }
}

// MARK: - TransferOutput
struct TransferOutput: Codable {
    let type: String
    let data: TransferOutputData
}

// MARK: - TransferOutputData
struct TransferOutputData: Codable {
    let address: String
    let amount: Int
    let remainder: Bool
}

// MARK: - TransferUnlockBlock
struct TransferUnlockBlock: Codable {
    let type: String
    let data: TransferUnlockBlockData
}

// MARK: - TransferUnlockBlockData
struct TransferUnlockBlockData: Codable {
    let type: String
    let data: TransferData
}

// MARK: - TransferDataData
struct TransferData: Codable {
    let publicKey, signature: [Int]

    enum CodingKeys: String, CodingKey {
        case publicKey = "public_key"
        case signature
    }
}
