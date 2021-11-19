#if canImport(Concurrency)
import Foundation
import Concurrency

@available(iOS 15.0.0, macOS 12.0.0, *)
extension IOTAAccount {
    
    /// Synchronizes the account with the Tangle.
    /// - Returns: The result or error
    public func sync() async -> Result<Bool, IOTAResponseError> {
        await withCheckedContinuation({ sself in
            sync { sself.resume(returning: $0) }
        })
    }
    
    /// Generates a new unused address and returns it.
    /// - Returns: The address or error
    func generateAddress() async -> Result<IOTAAccount.Address, IOTAResponseError> {
        await withCheckedContinuation({ sself in
            generateAddress { sself.resume(returning: $0) }
        })
    }
    
    /// Returns the latest address (the one with the biggest keyIndex).
    /// - Returns: The address or error
    func latestAddress() async -> Result<IOTAAccount.Address, IOTAResponseError> {
        await withCheckedContinuation({ sself in
            latestAddress { sself.resume(returning: $0) }
        })
    }
    
    /// Returns the account's balance information object.
    /// - Returns: The balance response or error
    func balance() async -> Result<BalanceResponse, IOTAResponseError> {
        await withCheckedContinuation({ sself in
            balance { sself.resume(returning: $0) }
        })
    }

    /// Gets information about the node.
    /// - Parameters:
    ///   - url: The node url
    ///   - jwt: The node auth JWT token
    ///   - username: The node auth username
    ///   - password: The node auth password
    /// - Returns: The node info or error
    func nodeInfo(url: String,
                  jwt: String = "",
                  username: String = "",
                  password: String = "") async -> Result<NodeInfoResponse, IOTAResponseError> {
        await withCheckedContinuation({ sself in
            nodeInfo(url: url, jwt: jwt, username: username, password: password) { sself.resume(returning: $0) }
        })
    }
    
    /// Updates the account alias.
    /// - Parameters:
    ///   - newAlias: The new alias
    /// - Returns: The result or error
    func setAlias(_ newAlias: String) async -> Result<Bool, IOTAResponseError> {
        await withCheckedContinuation({ sself in
            setAlias(newAlias) { sself.resume(returning: $0) }
        })
    }

    /// Returns the account's addresses.
    /// - Returns: The addresses or error
    func addresses() async -> Result<[Address], IOTAResponseError> {
        await withCheckedContinuation({ sself in
            addresses { sself.resume(returning: $0) }
        })
    }
    
    /// Return the account's unspent addresses
    /// - Returns: The list of addresses or error
    func unspentAddresses() async -> Result<[Address], IOTAResponseError> {
        await withCheckedContinuation({ sself in
            unspentAddresses { sself.resume(returning: $0) }
        })
    }
    
    /// Returns the account's spent addresses
    /// - Returns: The list of addresses or error
    func spentAddresses() async -> Result<[Address], IOTAResponseError> {
        await withCheckedContinuation({ sself in
            spentAddresses { sself.resume(returning: $0) }
        })
    }

    /// Returns the account's unused addresses
    /// - Returns: The list of addresses or error
    func unusedAddress() async -> Result<Address?, IOTAResponseError> {
        await withCheckedContinuation({ sself in
            unusedAddress { sself.resume(returning: $0) }
        })
    }
    
    /// Send funds to the given address.
    /// - Parameters:
    ///   - address: The bech32 string of the transfer address
    ///   - amount: The transfer amount
    ///   - options: The transfer options
    /// - Returns: The result or error
    func sendTransfer(address: String, amount: Int, options: TransferOptions? = nil) async -> Result<Bool, IOTAResponseError> {
        await withCheckedContinuation({ sself in
            sendTransfer(address: address, amount: amount, options: options) { sself.resume(returning: $0) }
        })
    }
}
#endif
