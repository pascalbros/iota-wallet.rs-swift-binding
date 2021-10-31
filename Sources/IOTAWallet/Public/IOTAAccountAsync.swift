#if canImport(Concurrency)
import Foundation
import Concurrency

@available(iOS 15.0.0, macOS 12.0.0, *)
extension IOTAAccount {
    public func sync() async -> Result<Bool, IOTAResponseError> {
        await withCheckedContinuation({ sself in
            sync { sself.resume(returning: $0) }
        })
    }
    
    func generateAddress() async -> Result<IOTAAccount.Address, IOTAResponseError> {
        await withCheckedContinuation({ sself in
            generateAddress { sself.resume(returning: $0) }
        })
    }

    func latestAddress() async -> Result<IOTAAccount.Address, IOTAResponseError> {
        await withCheckedContinuation({ sself in
            latestAddress { sself.resume(returning: $0) }
        })
    }
    
    func balance() async -> Result<BalanceResponse, IOTAResponseError> {
        await withCheckedContinuation({ sself in
            balance { sself.resume(returning: $0) }
        })
    }

    func nodeInfo(url: String, jwt: String = "", username: String = "", password: String = "") async -> Result<NodeInfoResponse, IOTAResponseError> {
        await withCheckedContinuation({ sself in
            nodeInfo(url: url, jwt: jwt, username: username, password: password) { sself.resume(returning: $0) }
        })
    }

    func setAlias(_ newAlias: String) async -> Result<Bool, IOTAResponseError> {
        await withCheckedContinuation({ sself in
            setAlias(newAlias) { sself.resume(returning: $0) }
        })
    }

    func addresses() async -> Result<[Address], IOTAResponseError> {
        await withCheckedContinuation({ sself in
            addresses { sself.resume(returning: $0) }
        })
    }
    
    func unspentAddresses() async -> Result<[Address], IOTAResponseError> {
        await withCheckedContinuation({ sself in
            unspentAddresses { sself.resume(returning: $0) }
        })
    }
    
    func spentAddresses() async -> Result<[Address], IOTAResponseError> {
        await withCheckedContinuation({ sself in
            spentAddresses { sself.resume(returning: $0) }
        })
    }

    func unusedAddress() async -> Result<Address?, IOTAResponseError> {
        await withCheckedContinuation({ sself in
            unusedAddress { sself.resume(returning: $0) }
        })
    }
}
#endif
