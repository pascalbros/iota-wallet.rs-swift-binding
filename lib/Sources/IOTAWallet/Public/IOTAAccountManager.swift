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
        walletManager = WalletEventsManager()
        walletManager?.start(storagePath: self.storagePath)
    }
    
    public func closeConnection() {
        walletManager?.stop()
        walletManager = nil
    }
    
    public func setStrongholdPassword(_ password: String, onResult: ((Result<Bool, IOTAResponseError>) -> Void)? = nil) {
        walletManager?.sendCommand(id: "SetStrongholdPassword",
                                               cmd: "SetStrongholdPassword",
                                               payload: password) { result in
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
    
    public func storeMnemonic(mnemonic: String, signer: SignerType, onResult: ((Result<Bool, IOTAResponseError>) -> Void)? = nil) {
        walletManager?.sendCommand(id: "StoreMnemonic",
                                               cmd: "StoreMnemonic",
                                               payload: ["mnemonic": mnemonic, "signerType": ["type": signer.rawValue]]) { result in
            let isError = result.decodedResponse?.isError ?? false
            onResult?(isError ? .failure(IOTAResponseError.decode(from: result)) : .success(true))
        }
    }
    
    public func createAccount(alias: String, url: String, localPow: Bool, onResult: ((Result<IOTAAccount, IOTAResponseError>) -> Void)? = nil) {
        walletManager?.sendCommand(id: "CreateAccount",
                                               cmd: "CreateAccount",
                                               payload: ["alias": alias, "clientOptions": ["node": ["url": url]], "localPow": localPow]) { result in
            if let account = WalletResponse<IOTAAccount>.decode(result)?.payload {
                account.accountManager = self
                onResult?(.success(account))
            } else {
                onResult?(.failure(IOTAResponseError.decode(from: result)))
            }
        }
    }
    
    public func getAccount(alias: String, onResult: ((Result<IOTAAccount, IOTAResponseError>) -> Void)? = nil) {
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
    
    public func deleteStorage(onResult: ((Result<Bool, IOTAResponseError>) -> Void)? = nil) {
        if (try? FileManager.default.contentsOfDirectory(atPath: storagePath).count) == 0 {
            onResult?(.success(true))
            return
        }
        walletManager?.sendCommand(id: "GetAccount",
                                               cmd: "DeleteStorage",
                                               payload: nil) { result in
            if let account = WalletResponse<Bool>.decode(result)?.payload {
                onResult?(.success(account))
            } else {
                onResult?(.failure(IOTAResponseError.decode(from: result)))
            }
        }
    }
}
