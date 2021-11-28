import XCTest
@testable import IOTAWallet

let json =
"""
{
      "id":"3d7a762f84d758655699d74b7cedc091913c25b712145771d7ad9cb5d0b3a78c",
      "version":1,
      "parents":[
         "1ba3f5024d90c503ed40614c0033816a7512bd7fcaf98da8a7e64d17d9749bb4",
         "338ba684756c4e06c5ed65ac3a71b9d9eb397a89e99ceba484ea0c2cb7316e88",
         "5bf0c4182c6fee87e8ab17f37a36fd4024a11d6d86355a0f2f47374a6747d90d",
         "9b33a6c746e9b24d089570889bc0a3cb967ea7762c477fbffc3e357df8ea9b2b"
      ],
      "payloadLength":233,
      "payload":{
         "type":"Transaction",
         "data":{
            "essence":{
               "type":"Regular",
               "data":{
                  "inputs":[
                     {
                        "type":"Utxo",
                        "data":{
                           "input":"82ac3649b8223fd1b0f87458e6d73b8b4ef292798d9386dbc8a0a444f84c3ea00100",
                           "metadata":{
                              "transactionId":"82ac3649b8223fd1b0f87458e6d73b8b4ef292798d9386dbc8a0a444f84c3ea0",
                              "messageId":"743cf9029cdb55322885c0c4c926188d12e19fb09f42257d6650a56e4bda530d",
                              "index":1,
                              "amount":9000000,
                              "isSpent":false,
                              "address":"atoi1qzyrjc5h39nzxlxxgvha45yfrkvvmw00hph08sr0tjfzdjp4mmn45mx8278",
                              "kind":"SignatureLockedSingle"
                           }
                        }
                     }
                  ],
                  "outputs":[
                     {
                        "type":"SignatureLockedSingle",
                        "data":{
                           "address":"atoi1qzqjcfypqa4hwwpr0yw3vn93m4npjaaexhncpwdsu7x4zrj9mtkuyew5hjx",
                           "amount":1000000,
                           "remainder":false
                        }
                     },
                     {
                        "type":"SignatureLockedSingle",
                        "data":{
                           "address":"atoi1qz6u3zl25rmaag723lcw38wpvedkp92s3uc0nxu54dp2hlezufrd24k62uz",
                           "amount":8000000,
                           "remainder":true
                        }
                     }
                  ],
                  "payload":null,
                  "internal":false,
                  "incoming":false,
                  "value":1000000,
                  "remainderValue":8000000
               }
            },
            "unlock_blocks":[
               {
                  "type":"Signature",
                  "data":{
                     "type":"Ed25519",
                     "data":{
                        "public_key":[
                           49,
                           53,
                           68,
                           106,
                           233,
                           66,
                           90,
                           0,
                           168,
                           214,
                           168,
                           232,
                           224,
                           17,
                           230,
                           226,
                           117,
                           36,
                           95,
                           218,
                           115,
                           156,
                           255,
                           41,
                           200,
                           36,
                           246,
                           2,
                           133,
                           102,
                           50,
                           198
                        ],
                        "signature":[
                           157,
                           164,
                           71,
                           161,
                           39,
                           111,
                           9,
                           249,
                           146,
                           148,
                           68,
                           225,
                           2,
                           139,
                           29,
                           12,
                           185,
                           17,
                           44,
                           76,
                           22,
                           52,
                           5,
                           129,
                           10,
                           153,
                           18,
                           78,
                           221,
                           156,
                           243,
                           7,
                           99,
                           27,
                           180,
                           109,
                           56,
                           119,
                           115,
                           142,
                           223,
                           71,
                           205,
                           199,
                           151,
                           206,
                           40,
                           172,
                           215,
                           13,
                           113,
                           71,
                           230,
                           10,
                           171,
                           156,
                           101,
                           1,
                           167,
                           96,
                           4,
                           83,
                           218,
                           3
                        ]
                     }
                  }
               }
            ]
         }
      },
      "timestamp":"2021-11-25T23:27:22.352950Z",
      "nonce":13835058055282298819,
      "broadcasted":true,
      "reattachmentMessageId":null
   }
"""

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
}
