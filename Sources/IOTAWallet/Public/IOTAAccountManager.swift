import Foundation

/// The entry point for the IOTA Wallet library.
public class IOTAAccountManager {
    
    fileprivate var storagePath: String
    fileprivate var nodeURL: String
    fileprivate var secretManager: String
    fileprivate(set) var walletManager: WalletEventsManager?
    
    /// Creates a new instance of the `IOTAAccountManager`.
    /// - Parameters:
    ///   - storagePath: The path where the database file will be saved
    ///   - startsAutomatically: Starts automatically if it is set to `true`. Default `true`
    public init(storagePath: String? = nil, secretManager: String, nodeURL: String, startsAutomatically: Bool = true) {
        self.storagePath = storagePath ?? URL.libraryDirectory.path
        self.secretManager = secretManager
        self.nodeURL = nodeURL
        if startsAutomatically {
            start()
        }
    }
    
    deinit {
        if walletManager != nil {
            closeConnection()
        }
    }
    
    /// Starts the manager, does nothing if it is already started.
    public func start() {
        if walletManager?.isRunning ?? false { return }
        walletManager = WalletEventsManager(storagePath: storagePath, secretManager: secretManager, nodeUrl: nodeURL)
    }
    
    /// Close the connection, stops the polling and release the inner instance
    public func closeConnection() {
        walletManager?.stop()
        walletManager = nil
    }
    
    /// Sets the Stronghold password.
    /// - Parameters:
    ///   - password: The storage password
    ///   - onResult: The result or error
    public func setStrongholdPassword(_ password: String,
                                      onResult: ((Result<Bool, IOTAResponseError>) -> Void)? = nil) {
        walletManager?.sendCommand(id: "SetStrongholdPassword",
                                   cmd: "SetStrongholdPassword",
                                   payload: password) { result in
            let isError = result.decodedResponse?.isError ?? false
            onResult?(isError ? .failure(IOTAResponseError.decode(from: result)) : .success(true))
        }
    }
    
    /// Changes the Stronghold password.
    /// - Parameters:
    ///   - newPassword: The new password
    ///   - onResult: The result or error
    public func changeStrongholdPassword(_ newPassword: String,
                                         onResult: ((Result<Bool, IOTAResponseError>) -> Void)? = nil) {
        walletManager?.sendCommand(id: "ChangeStrongholdPassword",
                                   cmd: "ChangeStrongholdPassword",
                                   payload: [
                                    "password": newPassword]) { result in
            let isError = result.decodedResponse?.isError ?? false
            onResult?(isError ? .failure(IOTAResponseError.decode(from: result)) : .success(true))
        }
    }
    
    /// Gets the current Stronghold status.
    /// - Parameter onResult: The result or error
    public func strongholdStatus(onResult: ((Result<StrongholdStatus, IOTAResponseError>) -> Void)? = nil) {
        walletManager?.sendCommand(id: "IsStrongholdPasswordAvailable",
                                   cmd: "IsStrongholdPasswordAvailable",
                                   payload: nil) { result in
            guard let onResult = onResult else { return }
            if let response = WalletResponse<StrongholdStatus>.decode(result)?.payload {
                onResult(.success(response))
            } else {
                onResult(.failure(IOTAResponseError.decode(from: result)))
            }
        }
    }
    
    /// Locks Stronghold if needed.
    /// - Parameter onResult: The result or error
    public func lockStronghold(onResult: ((Result<Bool, IOTAResponseError>) -> Void)? = nil) {
        walletManager?.sendCommand(id: "LockStronghold",
                                   cmd: "LockStronghold",
                                   payload: nil) { result in
            let isError = result.decodedResponse?.isError ?? false
            onResult?(isError ? .failure(IOTAResponseError.decode(from: result)) : .success(true))
        }
    }
    
    /// Sets Stronghold password clear interval.
    /// - Parameters:
    ///   - interval: The interval in seconds
    ///   - onResult: The result or error
    public func setStrongholdPasswordClearInterval(_ interval: Int,
                                                   onResult: ((Result<Bool, IOTAResponseError>) -> Void)? = nil) {
        walletManager?.sendCommand(id: "SetStrongholdPasswordClearInterval",
                                   cmd: "SetStrongholdPasswordClearInterval",
                                   payload: interval * 1000) { result in
           guard let decodedResult = result.decodedResponse else {
               onResult?(.failure(IOTAResponseError(type: "Generic", payload: .init(type: "Generic", error: result))))
               return
           }
            let isError = decodedResult.isError
            onResult?(isError ? .failure(IOTAResponseError.decode(from: result)) : .success(true))
        }
    }
    
    /// Generates a new mnemonic.
    /// - Parameter onResult: The generated mnemonic or error
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
    
    /// Stores a mnemonic for the given signer type.
    /// - Parameters:
    ///   - mnemonic: The provided mnemonic
    ///   - onResult: The result or error
    public func storeMnemonic(mnemonic: String,
                              onResult: ((Result<Bool, IOTAResponseError>) -> Void)? = nil) {
        walletManager?.sendCommand(id: "StoreMnemonic",
                                   cmd: "StoreMnemonic",
                                   payload: mnemonic) { result in
            let isError = result.decodedResponse?.isError ?? false
            onResult?(isError ? .failure(IOTAResponseError.decode(from: result)) : .success(true))
        }
    }
    
    /// Checks is the mnemonic is valid. If a mnemonic was generated with `generateMnemonic(onResult:)`, the mnemonic here should match the generated.
    /// - Parameters:
    ///   - mnemonic: The provided mnemonic
    ///   - onResult: The result
    public func verifyMnemonic(mnemonic: String,
                               onResult: ((Result<Bool, IOTAResponseError>) -> Void)? = nil) {
        walletManager?.sendCommand(id: "VerifyMnemonic",
                                   cmd: "VerifyMnemonic",
                                   payload: mnemonic) { result in
            let isError = result.decodedResponse?.isError ?? false
            onResult?(isError ? .failure(IOTAResponseError.decode(from: result)) : .success(true))
        }
    }
    
    /// Creates a new account.
    /// - Parameters:
    ///   - alias: The provided alias for the account
    ///   - mnemonic: The provided mnemonic
    ///   - url: The provided node url
    ///   - localPow: The provided local PoW setting
    ///   - onResult: The result
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
    
    /// Gets the account with the given identifier.
    /// - Parameters:
    ///   - alias: The provided account alias
    ///   - onResult: The result
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
    
    /// Removes the account with the given identifier.
    /// - Parameters:
    ///   - alias: The provided account alias
    ///   - onResult: The result or error
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
    
    /// Deletes the storage (database and/or Stronghold)
    /// - Parameter onResult: The result or error
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
    
    /// Gets all stored accounts.
    /// - Parameter onResult: The list of accounts or error
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
    
    /// Backups the storage to the given destination
    /// - Parameters:
    ///   - destination: The path to the backup file
    ///   - password: The backup Stronghold password
    ///   - onResult: The result or error
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
    
    /// Imports a database file.
    /// - Parameters:
    ///   - source: The path to the backup file
    ///   - password: The backup Stronghold password
    ///   - onResult: The result or error
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
    
    /// Starts the background polling and MQTT monitoring.
    /// - Parameters:
    ///   - pollingInterval: The polling interval in seconds
    ///   - automaticOutputConsolidation: If outputs should get consolidated automatically
    ///   - onResult: The result or error
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
    
    /// Stops the background polling and MQTT monitoring.
    /// - Parameter onResult: The result or error
    public func stopBackgroundSync(onResult: ((Result<Bool, IOTAResponseError>) -> Void)? = nil) {
        walletManager?.sendCommand(id: "StopBackgroundSync",
                                   cmd: "StopBackgroundSync",
                                   payload: nil) { result in
            let isError = result.decodedResponse?.isError ?? false
            onResult?(isError ? .failure(IOTAResponseError.decode(from: result)) : .success(true))
        }
    }
}
