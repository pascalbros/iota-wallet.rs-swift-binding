import Foundation

extension IOTAAccount {
    public func sync(onResult: ((Result<Bool, IOTAResponseError>) -> Void)?) {
        WalletEventsManager.shared.sendCommand(id: "SyncAccount",
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
        WalletEventsManager.shared.sendCommand(id: "GenerateAddress",
                                               cmd: "CallAccountMethod",
                                               payload: ["accountId": id, "method": ["name": "GenerateAddress"]]) { [weak self] result in
            if let address = WalletResponse<IOTAAccount.Address>.decode(result)?.payload {
                self?.addresses.append(address)
                onResult?(.success(address))
            } else {
                onResult?(.failure(IOTAResponseError.decode(from: result)))
            }
        }
    }
    
    public func latestAddress(onResult: ((Result<IOTAAccount.Address, IOTAResponseError>) -> Void)?) {
        WalletEventsManager.shared.sendCommand(id: "GetLatestAddress",
                                               cmd: "CallAccountMethod",
                                               payload: ["accountId": id, "method": ["name": "GetLatestAddress"]]) { result in
            if let address = WalletResponse<IOTAAccount.Address>.decode(result)?.payload {
                onResult?(.success(address))
            } else {
                onResult?(.failure(IOTAResponseError.decode(from: result)))
            }
        }
    }
}
