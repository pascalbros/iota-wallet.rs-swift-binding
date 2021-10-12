import _IOTAWallet

public struct IOTAWallet {
    static var debugLevel: LogLevel = .debug
    
    public init() {
        testMe()
    }
    
    public func testMe() {
        iota_send_message("ok")
    }
    
}
