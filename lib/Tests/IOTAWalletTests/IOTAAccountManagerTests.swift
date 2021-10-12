import XCTest
@testable import IOTAWallet

final class IOTAAccountManagerTests: XCTestCase {
    
    override class func setUp() {
        try? FileManager.default.removeItem(atPath: storagePath)
    }
    
    override class func tearDown() {
        try? FileManager.default.removeItem(atPath: storagePath)
    }
    
    override func tearDown() {
        try? FileManager.default.removeItem(atPath: storagePath)
    }
    
    func testStrongholdPassword() {
        Thread.sleep(forTimeInterval: 1.0)
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
    
    func testGenerateMnemonic() {
        Thread.sleep(forTimeInterval: 1.0)
        let expectation = XCTestExpectation(description: "Generate mnemonic")
        let accountManager = IOTAAccountManager(storagePath: storagePath)
        accountManager.generateMnemonic { result in
            switch result {
            case .success(let response): print(response); break
            case .failure(let error): XCTFail(error.localizedDescription)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testWrongStrongholdPassword() {
        Thread.sleep(forTimeInterval: 1.0)
        let expectation = XCTestExpectation(description: "Create new account")
        let accountManager = IOTAAccountManager(storagePath: storagePath)
        accountManager.setStrongholdPassword(password)
        accountManager.storeMnemonic(mnemonic: mnemonic, signer: .stronghold)
        accountManager.createAccount(alias: alias, url: nodeUrl, localPow: true)
        accountManager.setStrongholdPassword(password+"1") { result in
            switch result {
            case .failure: expectation.fulfill()
            case .success: XCTFail("Error: authenticated with a wrong password")
            }
        }
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testAccountCreation() {
        Thread.sleep(forTimeInterval: 1.0)
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
        Thread.sleep(forTimeInterval: 1.0)
        let expectation = XCTestExpectation(description: "Get account")
        let accountManager = IOTAAccountManager(storagePath: storagePath)
        accountManager.setStrongholdPassword(password)
        accountManager.storeMnemonic(mnemonic: mnemonic, signer: .stronghold)
        accountManager.createAccount(alias: alias, url: nodeUrl, localPow: true)
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
}