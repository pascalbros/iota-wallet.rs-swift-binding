import Foundation

extension IOTAAccount {
    public func sync(onResult: ((Result<Bool, IOTAResponseError>) -> Void)?) {
        WalletEventsManager.shared.sendCommand(id: "CallAccountMethod",
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
}
