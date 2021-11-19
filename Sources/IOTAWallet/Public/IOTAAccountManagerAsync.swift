#if canImport(Concurrency)
import Foundation
import Concurrency

@available(iOS 15.0.0, macOS 12.0.0, *)
public extension IOTAAccountManager {
    
    /// Sets the Stronghold password.
    /// - Parameters:
    ///   - password: The storage password
    /// - Returns: The result or error
    func setStrongholdPassword(_ password: String) async -> Result<Bool, IOTAResponseError> {
        await withCheckedContinuation({ sself in
            setStrongholdPassword(password) { sself.resume(returning: $0) }
        })
    }
    
    /// Changes the Stronghold password.
    /// - Parameters:
    ///   - currentPassword: The current password
    ///   - newPassword: The new password
    /// - Returns: The result or error
    func changeStrongholdPassword(currentPassword: String,
                                  newPassword: String) async -> Result<Bool, IOTAResponseError> {
        await withCheckedContinuation({ sself in
            changeStrongholdPassword(currentPassword: currentPassword, newPassword: newPassword) { sself.resume(returning: $0) }
        })
    }
    
    /// Gets the current Stronghold status.
    /// - Returns: The result or error
    func strongholdStatus() async -> Result<StrongholdStatus, IOTAResponseError> {
        await withCheckedContinuation({ sself in
            strongholdStatus { sself.resume(returning: $0) }
        })
    }
    
    /// Locks Stronghold if needed.
    /// - Returns: The result or error
    func lockStronghold() async -> Result<Bool, IOTAResponseError> {
        await withCheckedContinuation({ sself in
            lockStronghold { sself.resume(returning: $0) }
        })
    }
    
    /// Sets Stronghold password clear interval.
    /// - Parameters:
    ///   - interval: The interval in seconds
    /// - Returns: The result or error
    func setStrongholdPasswordClearInterval(_ interval: Int) async -> Result<Bool, IOTAResponseError> {
        await withCheckedContinuation({ sself in
            setStrongholdPasswordClearInterval(interval) { sself.resume(returning: $0) }
        })
    }
    
    /// Generates a new mnemonic.
    /// - Returns: The generated mnemonic or error
    func generateMnemonic() async -> Result<String, IOTAResponseError> {
        await withCheckedContinuation({ sself in
            generateMnemonic { sself.resume(returning: $0) }
        })
    }
    
    /// Stores a mnemonic for the given signer type.
    /// - Parameters:
    ///   - mnemonic: The provided mnemonic
    ///   - signer: The signer
    /// - Returns: The result or error
    func storeMnemonic(mnemonic: String,
                       signer: SignerType) async -> Result<Bool, IOTAResponseError> {
        await withCheckedContinuation({ sself in
            storeMnemonic(mnemonic: mnemonic, signer: signer) { sself.resume(returning: $0) }
        })
    }
    
    /// Checks is the mnemonic is valid. If a mnemonic was generated with `generateMnemonic(onResult:)`, the mnemonic here should match the generated.
    /// - Parameters:
    ///   - mnemonic: The provided mnemonic
    /// - Returns: The result or error
    func verifyMnemonic(mnemonic: String,
                        signer: SignerType) async -> Result<Bool, IOTAResponseError> {
        await withCheckedContinuation({ sself in
            verifyMnemonic(mnemonic: mnemonic) { sself.resume(returning: $0) }
        })
    }
    
    /// Creates a new account.
    /// - Parameters:
    ///   - alias: The provided alias for the account
    ///   - mnemonic: The provided mnemonic
    ///   - url: The provided node url
    ///   - localPow: The provided local PoW setting
    /// - Returns: The result
    func createAccount(alias: String,
                       mnemonic: String? = nil,
                       url: String,
                       localPow: Bool) async -> Result<IOTAAccount, IOTAResponseError> {
        await withCheckedContinuation({ sself in
            createAccount(alias: alias, mnemonic: mnemonic, url: url, localPow: localPow) { sself.resume(returning: $0) }
        })
    }
    
    /// Gets the account with the given identifier.
    /// - Parameters:
    ///   - alias: The provided account alias
    /// - Returns: The result
    func getAccount(alias: String) async -> Result<IOTAAccount, IOTAResponseError> {
        await withCheckedContinuation({ sself in
            getAccount(alias: alias) { sself.resume(returning: $0) }
        })
    }
    
    /// Removes the account with the given identifier.
    /// - Parameters:
    ///   - alias: The provided account alias
    /// - Returns: The result or error
    func removeAccount(alias: String) async -> Result<String, IOTAResponseError> {
        await withCheckedContinuation({ sself in
            removeAccount(alias: alias) { sself.resume(returning: $0) }
        })
    }

    /// Deletes the storage (database and/or Stronghold)
    /// - Returns: The result or error
    func deleteStorage() async -> Result<Bool, IOTAResponseError> {
        await withCheckedContinuation({ sself in
            deleteStorage { sself.resume(returning: $0) }
        })
    }

    /// Gets all stored accounts.
    /// - Returns: The list of accounts or error
    func getAccounts() async -> Result<[IOTAAccount], IOTAResponseError> {
        await withCheckedContinuation({ sself in
            getAccounts { sself.resume(returning: $0) }
        })
    }

    /// Backups the storage to the given destination
    /// - Parameters:
    ///   - destination: The path to the backup file
    ///   - password: The backup Stronghold password
    /// - Returns: The result or error
    func backup(destination: String,
                password: String) async -> Result<Bool, IOTAResponseError> {
        await withCheckedContinuation({ sself in
            backup(destination: destination, password: password) { sself.resume(returning: $0) }
        })
    }
    
    /// Imports a database file.
    /// - Parameters:
    ///   - source: The path to the backup file
    ///   - password: The backup Stronghold password
    /// - Returns: The result or error
    func restoreBackup(source: String,
                       password: String) async -> Result<Bool, IOTAResponseError> {
        await withCheckedContinuation({ sself in
            restoreBackup(source: source, password: password) { sself.resume(returning: $0) }
        })
    }

    /// Starts the background polling and MQTT monitoring.
    /// - Parameters:
    ///   - pollingInterval: The polling interval in seconds
    ///   - automaticOutputConsolidation: If outputs should get consolidated automatically
    /// - Returns: The result or error
    func startBackgroundSync(pollingInterval: Int,
                             automaticOutputConsolidation: Bool) async -> Result<Bool, IOTAResponseError> {
        await withCheckedContinuation({ sself in
            startBackgroundSync(pollingInterval: pollingInterval, automaticOutputConsolidation: automaticOutputConsolidation) { sself.resume(returning: $0) }
        })
    }

    /// Stops the background polling and MQTT monitoring.
    /// - Returns: The result or error
    func stopBackgroundSync() async -> Result<Bool, IOTAResponseError> {
        await withCheckedContinuation({ sself in
            stopBackgroundSync { sself.resume(returning: $0) }
        })
    }
}
#endif
