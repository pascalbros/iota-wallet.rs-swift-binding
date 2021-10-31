import Foundation

#if os(iOS)
@available(iOS 15.0.0, *)
public extension IOTAAccountManager {
    
    func setStrongholdPassword(_ password: String) async -> Result<Bool, IOTAResponseError> {
        await withCheckedContinuation({ sself in
            setStrongholdPassword(password) { sself.resume(returning: $0) }
        })
    }
    
    func changeStrongholdPassword(currentPassword: String, newPassword: String) async -> Result<Bool, IOTAResponseError> {
        await withCheckedContinuation({ sself in
            changeStrongholdPassword(currentPassword: currentPassword, newPassword: newPassword) { sself.resume(returning: $0) }
        })
    }
    
    func strongholdStatus() async -> Result<StrongholdStatus, IOTAResponseError> {
        await withCheckedContinuation({ sself in
            strongholdStatus { sself.resume(returning: $0) }
        })
    }
    
    func lockStronghold() async -> Result<Bool, IOTAResponseError> {
        await withCheckedContinuation({ sself in
            lockStronghold { sself.resume(returning: $0) }
        })
    }
    
    func setStrongholdPasswordClearInterval(_ interval: Int) async -> Result<Bool, IOTAResponseError> {
        await withCheckedContinuation({ sself in
            setStrongholdPasswordClearInterval(interval) { sself.resume(returning: $0) }
        })
    }
    
    func generateMnemonic() async -> Result<String, IOTAResponseError> {
        await withCheckedContinuation({ sself in
            generateMnemonic() { sself.resume(returning: $0) }
        })
    }
    
    func storeMnemonic(mnemonic: String, signer: SignerType) async -> Result<Bool, IOTAResponseError> {
        await withCheckedContinuation({ sself in
            storeMnemonic(mnemonic: mnemonic, signer: signer) { sself.resume(returning: $0) }
        })
    }
    
    func verifyMnemonic(mnemonic: String, signer: SignerType) async -> Result<Bool, IOTAResponseError> {
        await withCheckedContinuation({ sself in
            verifyMnemonic(mnemonic: mnemonic) { sself.resume(returning: $0) }
        })
    }
    
    func createAccount(alias: String, mnemonic: String? = nil, url: String, localPow: Bool) async -> Result<IOTAAccount, IOTAResponseError> {
        await withCheckedContinuation({ sself in
            createAccount(alias: alias, mnemonic: mnemonic, url: url, localPow: localPow) { sself.resume(returning: $0) }
        })
    }
    
    func getAccount(alias: String) async -> Result<IOTAAccount, IOTAResponseError> {
        await withCheckedContinuation({ sself in
            getAccount(alias: alias) { sself.resume(returning: $0) }
        })
    }
    
    func removeAccount(alias: String) async -> Result<String, IOTAResponseError> {
        await withCheckedContinuation({ sself in
            removeAccount(alias: alias) { sself.resume(returning: $0) }
        })
    }

    func deleteStorage() async -> Result<Bool, IOTAResponseError> {
        await withCheckedContinuation({ sself in
            deleteStorage() { sself.resume(returning: $0) }
        })
    }

    func getAccounts() async -> Result<[IOTAAccount], IOTAResponseError> {
        await withCheckedContinuation({ sself in
            getAccounts() { sself.resume(returning: $0) }
        })
    }

    func backup(destination: String, password: String) async -> Result<Bool, IOTAResponseError> {
        await withCheckedContinuation({ sself in
            backup(destination: destination, password: password) { sself.resume(returning: $0) }
        })
    }
    
    func restoreBackup(source: String, password: String) async -> Result<Bool, IOTAResponseError> {
        await withCheckedContinuation({ sself in
            restoreBackup(source: source, password: password) { sself.resume(returning: $0) }
        })
    }

    func startBackgroundSync(pollingInterval: Int, automaticOutputConsolidation: Bool) async -> Result<Bool, IOTAResponseError> {
        await withCheckedContinuation({ sself in
            startBackgroundSync(pollingInterval: pollingInterval, automaticOutputConsolidation: automaticOutputConsolidation) { sself.resume(returning: $0) }
        })
    }

    public func stopBackgroundSync() async -> Result<Bool, IOTAResponseError> {
        await withCheckedContinuation({ sself in
            stopBackgroundSync() { sself.resume(returning: $0) }
        })
    }
}
#endif
