import Foundation

#if os(iOS)
@available(iOS 15.0.0, *)
public extension IOTAAccountManager {
    
    func setStrongholdPassword(_ password: String) async -> Result<Bool, IOTAResponseError> {
        return await withCheckedContinuation({ sself in
            setStrongholdPassword(password) { sself.resume(returning: $0) }
        })
    }
    
    func storeMnemonic(mnemonic: String, signer: SignerType) async -> Result<Bool, IOTAResponseError> {
        return await withCheckedContinuation({ sself in
            storeMnemonic(mnemonic: mnemonic, signer: signer) { sself.resume(returning: $0) }
        })
    }
    
    func generateMnemonic() async -> Result<String, IOTAResponseError> {
        return await withCheckedContinuation({ sself in
            generateMnemonic() { sself.resume(returning: $0) }
        })
    }
    
    func createAccount(alias: String, url: String, localPow: Bool) async -> Result<IOTAAccount, IOTAResponseError> {
        return await withCheckedContinuation({ sself in
            createAccount(alias: alias, url: url, localPow: localPow) { sself.resume(returning: $0) }
        })
    }
    
    func getAccount(alias: String) async -> Result<IOTAAccount, IOTAResponseError> {
        return await withCheckedContinuation({ sself in
            getAccount(alias: alias) { sself.resume(returning: $0) }
        })
    }
}
#endif
