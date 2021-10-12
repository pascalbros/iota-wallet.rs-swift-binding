import XCTest
@testable import IOTAWallet

final class IOTAAccountTests: XCTestCase {
    
    override class func setUp() {
        try? FileManager.default.removeItem(atPath: storagePath)
    }
    
    override class func tearDown() {
        try? FileManager.default.removeItem(atPath: storagePath)
    }
    
    override func tearDown() {
        try? FileManager.default.removeItem(atPath: storagePath)
    }
    
    func newAccountPreamble(onResult: @escaping (IOTAAccount) -> Void) {
        let accountManager = IOTAAccountManager(storagePath: storagePath)
        accountManager.setStrongholdPassword(password)
        accountManager.storeMnemonic(mnemonic: mnemonic, signer: .stronghold)
        accountManager.getAccount(alias: alias) { result in
            if let account = try? result.get() {
                onResult(account)
            } else {
                accountManager.createAccount(alias: alias, url: nodeUrl, localPow: true) { result in
                    switch result {
                    case .success(let account): onResult(account)
                    case .failure(let error): XCTFail(error.payload.error)
                    }
                }
            }
        }
    }
    
    func testSyncAccount() {
        Thread.sleep(forTimeInterval: 1.0)
        let expectation = XCTestExpectation(description: "Sync account")
        newAccountPreamble { account in
            account.sync { syncResponse in
                switch syncResponse {
                case .success(let result): print(result)
                case .failure(let error): XCTFail(error.payload.error)
                }
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testGenerateAddress() {
        Thread.sleep(forTimeInterval: 1.0)
        let expectation = XCTestExpectation(description: "Generate address")
        newAccountPreamble { account in
            account.generateAddress { addressResponse in
                switch addressResponse {
                case .success(let result): XCTAssertEqual(result.address, "atoi1qqrch87kr45t763ml0z99930tkgkhv9f8nt0xhumgzg97suqg557g9efuut")
                case .failure(let error): XCTFail(error.payload.error)
                }
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testGetLatestAddress() {
        Thread.sleep(forTimeInterval: 1.0)
        let expectation = XCTestExpectation(description: "Latest address")
        newAccountPreamble { account in
            account.latestAddress { addressResponse in
                switch addressResponse {
                case .success(let result): print(result)
                case .failure(let error): XCTFail(error.payload.error)
                }
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testGetBalance() {
        Thread.sleep(forTimeInterval: 1.0)
        let expectation = XCTestExpectation(description: "Get Balance")
        newAccountPreamble { account in
            account.balance { balance in
                switch balance {
                case .success(let result): print(result)
                case .failure(let error): XCTFail(error.payload.error)
                }
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testNodeInfo() {
        Thread.sleep(forTimeInterval: 1.0)
        let expectation = XCTestExpectation(description: "Node info")
        newAccountPreamble { account in
            account.nodeInfo(url: nodeUrl) { balance in
                switch balance {
                case .success(let result): print(result)
                case .failure(let error): XCTFail(error.payload.error)
                }
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 3.0)
    }
    
//    func testGenerateAddresses() {
//        Thread.sleep(forTimeInterval: 1.0)
//        let expectation = XCTestExpectation(description: "Generate addresses")
//        newAccountPreamble { account in
//            account.generateAddresses(amount: 3) { addressResponse in
//                switch addressResponse {
//                case .success(let result): print(result)
//                case .failure(let error): XCTFail(error.payload.error)
//                }
//                expectation.fulfill()
//            }
//        }
//        wait(for: [expectation], timeout: 5.0)
//    }
}
