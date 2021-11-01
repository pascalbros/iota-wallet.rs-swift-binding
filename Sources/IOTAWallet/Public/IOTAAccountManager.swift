import Foundation

public class IOTAAccountManager {
    
    fileprivate var storagePath: String
    fileprivate(set) var walletManager: WalletEventsManager?
    
    public init(storagePath: String? = nil) {
        self.storagePath = storagePath ?? URL.libraryDirectory.path
        start()
    }
    
    deinit {
        if walletManager != nil {
            closeConnection()
        }
    }
    
    public func start() {
        if walletManager?.isRunning ?? false { return }
        walletManager = WalletEventsManager()
        walletManager?.start(storagePath: self.storagePath)
    }
    
    public func closeConnection() {
        walletManager?.stop()
        walletManager = nil
    }
    
    public func setStrongholdPassword(_ password: String,
                                      onResult: ((Result<Bool, IOTAResponseError>) -> Void)? = nil) {
        walletManager?.sendCommand(id: "SetStrongholdPassword",
                                   cmd: "SetStrongholdPassword",
                                   payload: password) { result in
            let isError = result.decodedResponse?.isError ?? false
            onResult?(isError ? .failure(IOTAResponseError.decode(from: result)) : .success(true))
        }
    }
    
    public func changeStrongholdPassword(currentPassword: String,
                                         newPassword: String,
                                         onResult: ((Result<Bool, IOTAResponseError>) -> Void)? = nil) {
        walletManager?.sendCommand(id: "ChangeStrongholdPassword",
                                   cmd: "ChangeStrongholdPassword",
                                   payload: [
                                    "currentPassword": currentPassword,
                                    "newPassword": newPassword]) { result in
            let isError = result.decodedResponse?.isError ?? false
            onResult?(isError ? .failure(IOTAResponseError.decode(from: result)) : .success(true))
        }
    }
    
    public func strongholdStatus(onResult: ((Result<StrongholdStatus, IOTAResponseError>) -> Void)? = nil) {
        walletManager?.sendCommand(id: "GetStrongholdStatus",
                                   cmd: "GetStrongholdStatus",
                                   payload: nil) { result in
            guard let onResult = onResult else { return }
            if let response = WalletResponse<StrongholdStatus>.decode(result)?.payload {
                onResult(.success(response))
            } else {
                onResult(.failure(IOTAResponseError.decode(from: result)))
            }
        }
    }
    
    public func lockStronghold(onResult: ((Result<Bool, IOTAResponseError>) -> Void)? = nil) {
        walletManager?.sendCommand(id: "LockStronghold",
                                   cmd: "LockStronghold",
                                   payload: nil) { result in
            let isError = result.decodedResponse?.isError ?? false
            onResult?(isError ? .failure(IOTAResponseError.decode(from: result)) : .success(true))
        }
    }
    
    public func setStrongholdPasswordClearInterval(_ interval: Int,
                                                   onResult: ((Result<Bool, IOTAResponseError>) -> Void)? = nil) {
        walletManager?.sendCommand(id: "SetStrongholdPasswordClearInterval",
                                   cmd: "SetStrongholdPasswordClearInterval",
                                   payload: [
                                    "secs": interval,
                                    "nanos": 0
                                   ]) { result in
            let isError = result.decodedResponse?.isError ?? false
            onResult?(isError ? .failure(IOTAResponseError.decode(from: result)) : .success(true))
        }
    }
    
    public func generateMnemonic(onResult: @escaping (Result<String, IOTAResponseError>) -> Void) {
        walletManager?.sendCommand(id: "GenerateMnemonic",
                                   cmd: "GenerateMnemonic",
                                   payload: nil) { result in
            if let response = WalletResponse<String>.decode(result)?.payload {
                onResult(.success(response))
            } else {
                onResult(.failure(IOTAResponseError.decode(from: result)))
            }
        }
    }
    
    public func storeMnemonic(mnemonic: String,
                              signer: SignerType,
                              onResult: ((Result<Bool, IOTAResponseError>) -> Void)? = nil) {
        walletManager?.sendCommand(id: "StoreMnemonic",
                                   cmd: "StoreMnemonic",
                                   payload: ["mnemonic": mnemonic, "signerType": ["type": signer.rawValue]]) { result in
            let isError = result.decodedResponse?.isError ?? false
            onResult?(isError ? .failure(IOTAResponseError.decode(from: result)) : .success(true))
        }
    }
    
    public func verifyMnemonic(mnemonic: String,
                               onResult: ((Result<Bool, IOTAResponseError>) -> Void)? = nil) {
        walletManager?.sendCommand(id: "VerifyMnemonic",
                                   cmd: "VerifyMnemonic",
                                   payload: mnemonic) { result in
            let isError = result.decodedResponse?.isError ?? false
            onResult?(isError ? .failure(IOTAResponseError.decode(from: result)) : .success(true))
        }
    }
    
    public func createAccount(alias: String,
                              mnemonic: String? = nil,
                              url: String,
                              localPow: Bool,
                              onResult: ((Result<IOTAAccount, IOTAResponseError>) -> Void)? = nil) {
        walletManager?.sendCommand(id: "CreateAccount",
                                   cmd: "CreateAccount",
                                   payload: ["alias": alias, "mnemonic": mnemonic as Any, "clientOptions": ["node": ["url": url]], "localPow": localPow]) { result in
            if let account = WalletResponse<IOTAAccount>.decode(result)?.payload {
                account.accountManager = self
                onResult?(.success(account))
            } else {
                onResult?(.failure(IOTAResponseError.decode(from: result)))
            }
        }
    }
    
    public func getAccount(alias: String,
                           onResult: ((Result<IOTAAccount, IOTAResponseError>) -> Void)? = nil) {
        walletManager?.sendCommand(id: "GetAccount",
                                   cmd: "GetAccount",
                                   payload: alias) { result in
            if let account = WalletResponse<IOTAAccount>.decode(result)?.payload {
                account.accountManager = self
                onResult?(.success(account))
            } else {
                onResult?(.failure(IOTAResponseError.decode(from: result)))
            }
        }
    }
    
    public func removeAccount(alias: String,
                              onResult: ((Result<String, IOTAResponseError>) -> Void)? = nil) {
        walletManager?.sendCommand(id: "RemoveAccount",
                                   cmd: "RemoveAccount",
                                   payload: alias) { result in
            if let response = WalletResponse<String>.decode(result)?.payload {
                onResult?(.success(response))
            } else {
                onResult?(.failure(IOTAResponseError.decode(from: result)))
            }
        }
    }
    
    public func deleteStorage(onResult: ((Result<Bool, IOTAResponseError>) -> Void)? = nil) {
        if (try? FileManager.default.contentsOfDirectory(atPath: storagePath).count) == 0 {
            onResult?(.success(true))
            return
        }
        walletManager?.sendCommand(id: "DeleteStorage",
                                   cmd: "DeleteStorage",
                                   payload: nil) { result in
            if let response = WalletResponse<Bool>.decode(result)?.payload {
                onResult?(.success(response))
            } else {
                onResult?(.failure(IOTAResponseError.decode(from: result)))
            }
        }
    }
    
    public func getAccounts(onResult: ((Result<[IOTAAccount], IOTAResponseError>) -> Void)? = nil) {
        walletManager?.sendCommand(id: "GetAccounts",
                                   cmd: "GetAccounts",
                                   payload: nil) { result in
            if let accounts = WalletResponse<[IOTAAccount]>.decode(result)?.payload {
                accounts.forEach({ $0.accountManager = self })
                onResult?(.success(accounts))
            } else {
                onResult?(.failure(IOTAResponseError.decode(from: result)))
            }
        }
    }
    
    public func backup(destination: String,
                       password: String,
                       onResult: ((Result<Bool, IOTAResponseError>) -> Void)? = nil) {
        guard destination.hasSuffix(".stronghold") else {
            onResult?(.failure(IOTAResponseError(type: "InvalidName", payload: IOTAResponseError.Details(type: "InvalidName", error: "Invalid destination name, expected a .stronghold file output"))))
            return
        }
        walletManager?.sendCommand(id: "Backup",
                                   cmd: "Backup",
                                   payload: ["destination": destination, "password": password]) { result in
            let isError = result.decodedResponse?.isError ?? false
            onResult?(isError ? .failure(IOTAResponseError.decode(from: result)) : .success(true))
        }
    }
    
    public func restoreBackup(source: String,
                              password: String,
                              onResult: ((Result<Bool, IOTAResponseError>) -> Void)? = nil) {
        guard source.hasSuffix(".stronghold") else {
            onResult?(.failure(IOTAResponseError(type: "InvalidName", payload: IOTAResponseError.Details(type: "InvalidName", error: "Invalid destination name, expected a .stronghold file output"))))
            return
        }
        walletManager?.sendCommand(id: "RestoreBackup",
                                   cmd: "RestoreBackup",
                                   payload: ["backupPath": source, "password": password]) { result in
            let isError = result.decodedResponse?.isError ?? false
            onResult?(isError ? .failure(IOTAResponseError.decode(from: result)) : .success(true))
        }
    }
    
    public func startBackgroundSync(pollingInterval: Int,
                                    automaticOutputConsolidation: Bool,
                                    onResult: ((Result<Bool, IOTAResponseError>) -> Void)? = nil) {
        walletManager?.sendCommand(id: "StartBackgroundSync",
                                   cmd: "StartBackgroundSync",
                                   payload: [
                                    "pollingInterval": WalletDuration(secs: pollingInterval, nanos: 0).dict,
                                    "automaticOutputConsolidation": automaticOutputConsolidation
                                   ]) { result in
            let isError = result.decodedResponse?.isError ?? false
            onResult?(isError ? .failure(IOTAResponseError.decode(from: result)) : .success(true))
        }
    }
    
    public func stopBackgroundSync(onResult: ((Result<Bool, IOTAResponseError>) -> Void)? = nil) {
        walletManager?.sendCommand(id: "StopBackgroundSync",
                                   cmd: "StopBackgroundSync",
                                   payload: nil) { result in
            let isError = result.decodedResponse?.isError ?? false
            onResult?(isError ? .failure(IOTAResponseError.decode(from: result)) : .success(true))
        }
    }
}
