import Foundation

//
extension IOTAAccount {
    
    /// Synchronizes the account with the Tangle.
    /// - Parameter onResult: The result or error
    public func sync(onResult: ((Result<Bool, IOTAResponseError>) -> Void)?) {
        accountManager?.walletManager?.sendCommand(id: "SyncAccount",
                                                   cmd: "CallAccountMethod",
                                                   payload: ["accountId": id, "method": ["name": "SyncAccount", "data": [:]]]) { [weak self] result in
            if let account = WalletResponse<WalletSyncResponse>.decode(result)?.payload {
                self?.addresses = account.addresses
                onResult?(.success(true))
            } else {
                onResult?(.failure(IOTAResponseError.decode(from: result)))
            }
        }
    }
    
    /// Generates a new unused address and returns it.
    /// - Parameter onResult: The address or error
    public func generateAddress(onResult: ((Result<IOTAAccount.Address, IOTAResponseError>) -> Void)?) {
        accountManager?.walletManager?.sendCommand(id: "GenerateAddress",
                                                   cmd: "CallAccountMethod",
                                                   payload: ["accountId": id, "method": ["name": "GenerateAddress"]]) { [weak self] result in
            if let address = WalletResponse<IOTAAccount.Address>.decode(result)?.payload {
                if !(self?.addresses.contains(address) ?? true) {
                    self?.addresses.append(address)
                }
                onResult?(.success(address))
            } else {
                onResult?(.failure(IOTAResponseError.decode(from: result)))
            }
        }
    }
    
    /// Returns the latest address (the one with the biggest keyIndex).
    /// - Parameter onResult: The address or error
    public func latestAddress(onResult: ((Result<IOTAAccount.Address, IOTAResponseError>) -> Void)?) {
        accountManager?.walletManager?.sendCommand(id: "GetLatestAddress",
                                                   cmd: "CallAccountMethod",
                                                   payload: ["accountId": id, "method": ["name": "GetLatestAddress"]]) { result in
            if let address = WalletResponse<IOTAAccount.Address>.decode(result)?.payload {
                onResult?(.success(address))
            } else {
                onResult?(.failure(IOTAResponseError.decode(from: result)))
            }
        }
    }
    
    /// Returns the account's balance information object.
    /// - Parameter onResult: The balance response or error
    public func balance(onResult: ((Result<BalanceResponse, IOTAResponseError>) -> Void)?) {
        accountManager?.walletManager?.sendCommand(id: "GetBalance",
                                                   cmd: "CallAccountMethod",
                                                   payload: ["accountId": id, "method": ["name": "GetBalance"]]) { result in
            if let balance = WalletResponse<BalanceResponse>.decode(result)?.payload {
                onResult?(.success(balance))
            } else {
                onResult?(.failure(IOTAResponseError.decode(from: result)))
            }
        }
    }
    
    /// Gets information about the node.
    /// - Parameters:
    ///   - url: The node url
    ///   - jwt: The node auth JWT token
    ///   - username: The node auth username
    ///   - password: The node auth password
    ///   - onResult: The node info or error
    public func nodeInfo(url: String, jwt: String = "", username: String = "", password: String = "", onResult: ((Result<NodeInfoResponse, IOTAResponseError>) -> Void)?) {
        
        accountManager?.walletManager?.sendCommand(id: "GetNodeInfo",
                                                   cmd: "CallAccountMethod",
                                                   payload: ["accountId": id,
                                                             "method": ["name": "GetNodeInfo", "data": [url, jwt, [username, password]]]
                                                            ]) { result in
            if let nodeInfo = WalletResponse<NodeInfoResponse>.decode(result)?.payload {
                onResult?(.success(nodeInfo))
            } else {
                onResult?(.failure(IOTAResponseError.decode(from: result)))
            }
        }
    }
    
    /// Updates the account alias.
    /// - Parameters:
    ///   - newAlias: The new alias
    ///   - onResult: The result or error
    public func setAlias(_ newAlias: String, onResult: ((Result<Bool, IOTAResponseError>) -> Void)?) {
        accountManager?.walletManager?.sendCommand(id: "SetAlias",
                                                   cmd: "CallAccountMethod",
                                                   payload: ["accountId": id,
                                                             "method": ["name": "SetAlias", "data": newAlias]
                                                            ]) { result in
            let isError = result.decodedResponse?.isError ?? false
            onResult?(isError ? .failure(IOTAResponseError.decode(from: result)) : .success(true))
        }
    }
    
    /// Returns the account's addresses.
    /// - Parameter onResult: The addresses or error
    public func addresses(onResult: ((Result<[Address], IOTAResponseError>) -> Void)?) {
        accountManager?.walletManager?.sendCommand(id: "ListAddresses",
                                                   cmd: "CallAccountMethod",
                                                   payload: ["accountId": id,
                                                             "method": ["name": "ListAddresses"]
                                                            ]) { result in
            if let addresses = WalletResponse<[Address]>.decode(result)?.payload {
                onResult?(.success(addresses))
            } else {
                onResult?(.failure(IOTAResponseError.decode(from: result)))
            }
        }
    }
    
    /// Return the account's unspent addresses
    /// - Parameter onResult: The list of addresses or error
    public func unspentAddresses(onResult: ((Result<[Address], IOTAResponseError>) -> Void)?) {
        accountManager?.walletManager?.sendCommand(id: "ListAddresses",
                                                   cmd: "CallAccountMethod",
                                                   payload: ["accountId": id,
                                                             "method": ["name": "ListUnspentAddresses"]
                                                            ]) { result in
            if let addresses = WalletResponse<[Address]>.decode(result)?.payload {
                onResult?(.success(addresses))
            } else {
                onResult?(.failure(IOTAResponseError.decode(from: result)))
            }
        }
    }
    
    /// Returns the account's spent addresses
    /// - Parameter onResult: The list of addresses or error
    public func spentAddresses(onResult: ((Result<[Address], IOTAResponseError>) -> Void)?) {
        accountManager?.walletManager?.sendCommand(id: "ListAddresses",
                                                   cmd: "CallAccountMethod",
                                                   payload: ["accountId": id,
                                                             "method": ["name": "ListSpentAddresses"]
                                                            ]) { result in
            if let addresses = WalletResponse<[Address]>.decode(result)?.payload {
                onResult?(.success(addresses))
            } else {
                onResult?(.failure(IOTAResponseError.decode(from: result)))
            }
        }
    }
    
    /// Returns the account's unused addresses
    /// - Parameter onResult: The list of addresses or error
    public func unusedAddress(onResult: ((Result<Address?, IOTAResponseError>) -> Void)?) {
        accountManager?.walletManager?.sendCommand(id: "ListAddresses",
                                                   cmd: "CallAccountMethod",
                                                   payload: ["accountId": id,
                                                             "method": ["name": "GetUnusedAddress"]
                                                            ]) { result in
            if result.decodedResponse?.isError ?? false {
                onResult?(.failure(IOTAResponseError.decode(from: result)))
                return
            }
            onResult?(.success(WalletResponse<Address>.decode(result)?.payload))
        }
    }
    
    /// Send funds to the given address.
    /// - Parameters:
    ///   - address: The bech32 string of the transfer address
    ///   - amount: The transfer amount
    ///   - options: The transfer options
    ///   - onResult: The result or error
    public func sendTransfer(address: String, amount: Int, options: TransferOptions? = nil, onResult: ((Result<Bool, IOTAResponseError>) -> Void)?) {
        var currentOptions: TransferOptions? = options
        var transfer: [String: Any] = ["address": address, "amount": amount]
        if currentOptions == nil {
            currentOptions = TransferOptions(remainderValueStrategy: .changeAddress, skipSync: false, outputKind: nil)
        }
        currentOptions!.dict.forEach({ transfer[$0.key] = $0.value })
        accountManager?.walletManager?.sendCommand(id: "SendTransfer",
                                                   cmd: "SendTransfer",
                                                   payload: ["accountId": id,
                                                             "transfer": transfer
                                                            ]) { result in
            let isError = result.decodedResponse?.isError ?? false
            onResult?(isError ? .failure(IOTAResponseError.decode(from: result)) : .success(true))
        }
    }
}
