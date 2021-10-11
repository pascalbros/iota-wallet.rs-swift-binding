import Foundation

public class IOTAAccountManager {
    
    fileprivate var storagePath: String
    
    public init(storagePath: String? = nil) {
        self.storagePath = storagePath ?? URL.libraryDirectory.path
        WalletEventsManager.shared.start(storagePath: self.storagePath)
    }
    
    public func closeConnection() {
        WalletEventsManager.shared.stop()
    }
    
    public func setStrongholdPassword(_ password: String, onResult: ((Result<Bool, IOTAResponseError>) -> Void)? = nil) {
        WalletEventsManager.shared.sendCommand(id: "SetStrongholdPassword",
                                               cmd: "SetStrongholdPassword",
                                               payload: password) { result in
            let isError = result.decodedResponse?.isError ?? false
            onResult?(isError ? .failure(IOTAResponseError.decode(from: result)) : .success(true))
        }
    }
    
    func generateMnemonic(onResult: @escaping (Result<String, IOTAResponseError>) -> Void) {
        WalletEventsManager.shared.sendCommand(id: "GenerateMnemonic",
                                               cmd: "GenerateMnemonic",
                                               payload: nil) { result in
            if let response = WalletResponse<String>.decode(result)?.payload {
                onResult(.success(response))
            } else {
                onResult(.failure(IOTAResponseError.decode(from: result)))
            }
        }
    }
    
    func storeMnemonic(mnemonic: String, signer: SignerType, onResult: ((Result<Bool, IOTAResponseError>) -> Void)? = nil) {
        WalletEventsManager.shared.sendCommand(id: "StoreMnemonic",
                                               cmd: "StoreMnemonic",
                                               payload: ["mnemonic": mnemonic, "signerType": ["type": signer.rawValue]]) { result in
            let isError = result.decodedResponse?.isError ?? false
            onResult?(isError ? .failure(IOTAResponseError.decode(from: result)) : .success(true))
        }
    }
    
    func createAccount(alias: String, url: String, localPow: Bool, onResult: ((Result<IOTAAccount, IOTAResponseError>) -> Void)? = nil) {
        WalletEventsManager.shared.sendCommand(id: "CreateAccount",
                                               cmd: "CreateAccount",
                                               payload: ["alias": alias, "clientOptions": ["node": ["url": url]], "localPow": localPow]) { result in
            if let account = WalletResponse<IOTAAccount>.decode(result)?.payload {
                onResult?(.success(account))
            } else {
                onResult?(.failure(IOTAResponseError.decode(from: result)))
            }
        }
    }
    
    func getAccount(alias: String, onResult: ((Result<IOTAAccount, IOTAResponseError>) -> Void)? = nil) {
        WalletEventsManager.shared.sendCommand(id: "GetAccount",
                                               cmd: "GetAccount",
                                               payload: alias) { result in
            if let account = WalletResponse<IOTAAccount>.decode(result)?.payload {
                onResult?(.success(account))
            } else {
                onResult?(.failure(IOTAResponseError.decode(from: result)))
            }
        }
    }
}
