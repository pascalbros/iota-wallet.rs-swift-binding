import XCTest
@testable import IOTAWallet

//let storagePath = FileManager.default.temporaryDirectory.appendingPathComponent("IOTAWallet", isDirectory: true).path
let storagePath = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("tmpIOTAWallet", isDirectory: true).path
let nodeUrl = "https://api.lb-0.h.chrysalis-devnet.iota.cafe"
let mnemonic = "season body fog frost focus size journey glimpse size shed blanket jewel wood access kind useful visa peanut midnight extra margin sentence column diesel"
let password = "password"
let alias = "Alice"

final class IOTAWalletTests: XCTestCase {
    
    override class func setUp() {
        try? FileManager.default.removeItem(atPath: storagePath)
    }
    
    override class func tearDown() {
        try? FileManager.default.removeItem(atPath: storagePath)
    }
    
    override func tearDown() {
        WalletEventsManager.shared.stop()
        Thread.sleep(forTimeInterval: 3)
    }
    
    func testStrongholdPassword() {
        let expectation = XCTestExpectation(description: "Set stronghold password")
        let accountManager = IOTAAccountManager(storagePath: storagePath)
        accountManager.setStrongholdPassword(password) { result in
            switch result {
            case .success(let response): print(response); break
            case .failure(let error): XCTFail(error.localizedDescription)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testAccountCreation() {
        let expectation = XCTestExpectation(description: "Create new account")
        let accountManager = IOTAAccountManager(storagePath: storagePath)
        accountManager.setStrongholdPassword(password)
        accountManager.storeMnemonic(mnemonic: mnemonic, signer: .stronghold)
        accountManager.createAccount(alias: alias, url: nodeUrl, localPow: true) { result in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                XCTFail(error.payload.error)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testGetAccount() {
        let expectation = XCTestExpectation(description: "Get account")
        let accountManager = IOTAAccountManager(storagePath: storagePath)
        accountManager.setStrongholdPassword(password)
        accountManager.storeMnemonic(mnemonic: mnemonic, signer: .stronghold)
        accountManager.createAccount(alias: alias, url: nodeUrl, localPow: true)
        Thread.sleep(forTimeInterval: 1)
        accountManager.getAccount(alias: alias) { result in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                XCTFail(error.payload.error)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testMultipleGetAccount() {
        let expectation = XCTestExpectation(description: "Get account")
        let accountManager = IOTAAccountManager(storagePath: storagePath)
        accountManager.setStrongholdPassword(password)
        accountManager.storeMnemonic(mnemonic: mnemonic, signer: .stronghold)
        accountManager.createAccount(alias: alias, url: nodeUrl, localPow: true)
        for _ in 0..<100 {
            accountManager.getAccount(alias: alias)
            Thread.sleep(forTimeInterval: 0.1)
        }
    }
}
