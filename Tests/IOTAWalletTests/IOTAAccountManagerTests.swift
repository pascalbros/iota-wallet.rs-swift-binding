import XCTest
@testable import IOTAWallet

final class IOTAAccountManagerTests: XCTestCase {
    
    var currentAccountManager: IOTAAccountManager?
    
    override class func setUp() {
        try? FileManager.default.removeItem(atPath: storagePath)
    }

//    override class func tearDown() {
//        try? FileManager.default.removeItem(atPath: storagePath)
//    }

    override func tearDown() {
        Thread.sleep(forTimeInterval: 0.1)
        self.currentAccountManager?.closeConnection()
        Thread.sleep(forTimeInterval: 0.5)
        self.currentAccountManager?.deleteStorage()
        self.currentAccountManager = nil
    }
    
    func testStrongholdPassword() {
        Thread.sleep(forTimeInterval: 1.0)
        let expectation = XCTestExpectation(description: "Set stronghold password")
        let accountManager = IOTAAccountManager(storagePath: storagePath)
        currentAccountManager = accountManager
        accountManager.setStrongholdPassword(password) { result in
            switch result {
            case .success(let response): print(response)
            case .failure(let error): XCTFail(error.localizedDescription)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testChangeStrongholdPassword() {
        let expectation = XCTestExpectation(description: "Change stronghold password")
        let accountManager = IOTAAccountManager(storagePath: storagePath)
        currentAccountManager = accountManager
        accountManager.setStrongholdPassword(password)
        accountManager.changeStrongholdPassword(currentPassword: password, newPassword: password+"2") { result in
            switch result {
            case .success(_): expectation.fulfill()
            case .failure(let error): XCTFail(error.localizedDescription)
            }
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testChangeWrongStrongholdPassword() {
        let expectation = XCTestExpectation(description: "Change wrong stronghold password")
        let accountManager = IOTAAccountManager(storagePath: storagePath)
        currentAccountManager = accountManager
        accountManager.setStrongholdPassword(password)
        accountManager.changeStrongholdPassword(currentPassword: password+"2", newPassword: password) { result in
            switch result {
            case .success(_): XCTFail("The new password should raise an error, accepted instead")
            case .failure(_): expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testGetStrongholdStatus() {
        let expectation = XCTestExpectation(description: "Get stronghold status")
        let accountManager = IOTAAccountManager(storagePath: storagePath)
        currentAccountManager = accountManager
        accountManager.setStrongholdPassword(password)
        Thread.sleep(forTimeInterval: 2.0)
        accountManager.strongholdStatus() { result in
            switch result {
            case .success(let response): print(response)
            case .failure(let error): XCTFail(error.localizedDescription)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testLockStronghold() {
        let expectation = XCTestExpectation(description: "Lock stronghold")
        let accountManager = IOTAAccountManager(storagePath: storagePath)
        accountManager.setStrongholdPassword(password)
        currentAccountManager = accountManager
        accountManager.lockStronghold() { result in
            switch result {
            case .success(let response): print(response)
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
        currentAccountManager = accountManager
        accountManager.generateMnemonic { result in
            switch result {
            case .success(let response): print(response)
            case .failure(let error): XCTFail(error.localizedDescription)
            }
            expectation.fulfill()
        }
        currentAccountManager = accountManager
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testWrongStrongholdPassword() {
        Thread.sleep(forTimeInterval: 1.0)
        let expectation = XCTestExpectation(description: "Create new account")
        let accountManager = IOTAAccountManager(storagePath: storagePath)
        currentAccountManager = accountManager
        accountManager.setStrongholdPassword(password)
        accountManager.storeMnemonic(mnemonic: mnemonic, signer: .stronghold)
        accountManager.createAccount(alias: alias, url: nodeUrl, localPow: true)
        accountManager.setStrongholdPassword(password+"1") { result in
            switch result {
            case .failure: expectation.fulfill()
            case .success: XCTFail("Error: authenticated with a wrong password")
            }
        }
        currentAccountManager = accountManager
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testAccountCreation() {
        Thread.sleep(forTimeInterval: 1.0)
        let expectation = XCTestExpectation(description: "Create new account")
        let accountManager = IOTAAccountManager(storagePath: storagePath)
        currentAccountManager = accountManager
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
        currentAccountManager = accountManager
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
        currentAccountManager = accountManager
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testRemoveAccount() {
        Thread.sleep(forTimeInterval: 1.0)
        let expectation = XCTestExpectation(description: "Delete storage")
        let accountManager = IOTAAccountManager(storagePath: storagePath)
        currentAccountManager = accountManager
        accountManager.setStrongholdPassword(password)
        accountManager.storeMnemonic(mnemonic: mnemonic, signer: .stronghold)
        accountManager.createAccount(alias: alias, url: nodeUrl, localPow: true)
        accountManager.removeAccount(alias: alias) { result in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                XCTFail(error.payload.error)
            }
            expectation.fulfill()
        }
        currentAccountManager = accountManager
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testDeleteStorage() {
        Thread.sleep(forTimeInterval: 1.0)
        let accountManager = IOTAAccountManager(storagePath: storagePath)
        currentAccountManager = accountManager
        accountManager.setStrongholdPassword(password)
        accountManager.storeMnemonic(mnemonic: mnemonic, signer: .stronghold)
        accountManager.deleteStorage()
        currentAccountManager = accountManager
    }
    
    func testVerifyMnemonic() {
        let expectation = XCTestExpectation(description: "Test verify mnemonic")
        let accountManager = IOTAAccountManager(storagePath: storagePath)
        currentAccountManager = accountManager
        accountManager.verifyMnemonic(mnemonic: mnemonic) { result in
            switch result {
            case .success(_): expectation.fulfill()
            case .failure(let error): XCTFail(error.localizedDescription)
            }
        }
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testVerifyWrongMnemonic() {
        let expectation = XCTestExpectation(description: "Test verify wrong mnemonic")
        let accountManager = IOTAAccountManager(storagePath: storagePath)
        currentAccountManager = accountManager
        accountManager.verifyMnemonic(mnemonic: mnemonic + " diesel") { result in
            switch result {
            case .success(_): XCTFail("The mnemonic should raise an error, accepted instead")
            case .failure(_): expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testSetStrongholdClearPasswordInterval() {
        let expectation = XCTestExpectation(description: "Set stronghold password interval")
        let accountManager = IOTAAccountManager(storagePath: storagePath)
        currentAccountManager = accountManager
        accountManager.setStrongholdPassword(password)
        accountManager.setStrongholdPasswordClearInterval(10) { result in
            switch result {
            case .success(let response): print(response)
            case .failure(let error): XCTFail(error.localizedDescription)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 100.0)
    }
    
    func testGetAccounts() {
        let expectation = XCTestExpectation(description: "Get account")
        let accountManager = IOTAAccountManager(storagePath: storagePath)
        currentAccountManager = accountManager
        accountManager.setStrongholdPassword(password)
        accountManager.storeMnemonic(mnemonic: mnemonic, signer: .stronghold)
        accountManager.createAccount(alias: alias, mnemonic: mnemonic, url: nodeUrl, localPow: true)
        accountManager.getAccounts() { result in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                XCTFail(error.payload.error)
            }
            expectation.fulfill()
        }
        currentAccountManager = accountManager
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testBackup() {
        let expectation = XCTestExpectation(description: "Backup")
        let accountManager = IOTAAccountManager(storagePath: storagePath)
        currentAccountManager = accountManager
        accountManager.setStrongholdPassword(password)
        accountManager.storeMnemonic(mnemonic: mnemonic, signer: .stronghold)
        accountManager.createAccount(alias: alias, mnemonic: mnemonic, url: nodeUrl, localPow: true)
        accountManager.backup(destination: storagePath+"/backup.stronghold", password: password) { result in
            switch result {
            case .success(let response): print(response)
            case .failure(let error): XCTFail(error.payload.error)
            }
            expectation.fulfill()
        }
        currentAccountManager = accountManager
        wait(for: [expectation], timeout: 3.0)
    }
}
