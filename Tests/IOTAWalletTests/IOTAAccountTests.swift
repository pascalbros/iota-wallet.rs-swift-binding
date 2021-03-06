import XCTest
@testable import IOTAWallet

final class IOTAAccountTests: XCTestCase {
    
    var currentAccountManager: IOTAAccountManager?
    
    override class func setUp() {
        try? FileManager.default.removeItem(atPath: storagePath)
    }
    
    override func tearDown() {
        Thread.sleep(forTimeInterval: 0.1)
        self.currentAccountManager?.closeConnection()
        Thread.sleep(forTimeInterval: 0.5)
        self.currentAccountManager?.deleteStorage()
        self.currentAccountManager = nil
    }
    
    func newAccountPreamble(onResult: @escaping (IOTAAccount) -> Void) {
        let accountManager = IOTAAccountManager(storagePath: storagePath)
        currentAccountManager = accountManager
        accountManager.setStrongholdPassword(password)
        accountManager.storeMnemonic(mnemonic: mnemonic, signer: .stronghold)
        accountManager.getAccount(alias: alias) { result in
            if let account = try? result.get() {
                onResult(account)
            } else {
                accountManager.createAccount(alias: alias, mnemonic: mnemonic, url: nodeUrl, localPow: true) { result in
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
            print(account.addresses)
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
            account.sync { _ in
                account.balance { balance in
                    switch balance {
                    case .success(let result): print(result)
                    case .failure(let error): XCTFail(error.payload.error)
                    }
                    expectation.fulfill()
                }
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
    
    func testSetAlias() {
        Thread.sleep(forTimeInterval: 1.0)
        let expectation = XCTestExpectation(description: "Set Alias")
        newAccountPreamble { account in
            account.setAlias(alias+"2") { response in
                switch response {
                case .success(let result): print(result)
                case .failure(let error): XCTFail(error.payload.error)
                }
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testGetAddresses() {
        Thread.sleep(forTimeInterval: 1.0)
        let expectation = XCTestExpectation(description: "Get addresses")
        newAccountPreamble { account in
            account.sync(onResult: { _ in })
            Thread.sleep(forTimeInterval: 2.0)
            account.addresses { addressResponse in
                switch addressResponse {
                case .success(let result): XCTAssertGreaterThan(result.count, 0)
                case .failure(let error): XCTFail(error.payload.error)
                }
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testGetUnspentAddresses() {
        Thread.sleep(forTimeInterval: 1.0)
        let expectation = XCTestExpectation(description: "Get unspent addresses")
        newAccountPreamble { account in
            account.sync(onResult: { _ in })
            Thread.sleep(forTimeInterval: 2.0)
            account.unspentAddresses { addressResponse in
                switch addressResponse {
                case .success(let result): XCTAssertGreaterThan(result.count, 0)
                case .failure(let error): XCTFail(error.payload.error)
                }
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testGetSpentAddresses() {
        Thread.sleep(forTimeInterval: 1.0)
        let expectation = XCTestExpectation(description: "Get spent addresses")
        newAccountPreamble { account in
            account.sync(onResult: { _ in })
            Thread.sleep(forTimeInterval: 2.0)
            account.spentAddresses { addressResponse in
                switch addressResponse {
                case .success(let result): print(result)
                case .failure(let error): XCTFail(error.payload.error)
                }
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testGetUnusedAddresses() {
        Thread.sleep(forTimeInterval: 1.0)
        let expectation = XCTestExpectation(description: "Get unused address")
        newAccountPreamble { account in
            account.unusedAddress { addressResponse in
                switch addressResponse {
                case .success(let result): print(result ?? "No address")
                case .failure(let error): XCTFail(error.payload.error)
                }
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testSendTransfer() {
        Thread.sleep(forTimeInterval: 1.0)
        let expectation = XCTestExpectation(description: "Send transfer")
        newAccountPreamble { account in
            account.sendTransfer(address: address2, amount: 1_000_000) { response in
                switch response {
                case .success(let result): print(result)
                case .failure(let error): XCTFail(error.payload.error)
                }
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testTransferResponse() {
        XCTAssertNotNil(TransferResponse.decode(mockTransferResponse))
    }
}
