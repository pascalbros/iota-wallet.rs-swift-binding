import Foundation

class WalletUtils {
    static func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    static func randomId(to: String) -> String {
        to+"-"+randomString(length: 4)
    }
}

func log(_ items: Any..., level: LogLevel = .debug) {
    #if DEBUG
    if level.rawValue >= IOTAWallet.debugLevel.rawValue {
        debugPrint("[IOTAWallet] ", items)
    }
    #endif
}
