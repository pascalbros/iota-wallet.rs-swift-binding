import Foundation

extension IOTAAccount {
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
}
