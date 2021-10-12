import Foundation

//let storagePath = FileManager.default.temporaryDirectory.appendingPathComponent("IOTAWallet", isDirectory: true).path
#if os(macOS)
let storagePath = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("tmpIOTAWallet", isDirectory: true).path
#elseif os(iOS)
let storagePath = FileManager.default.temporaryDirectory.appendingPathComponent("tmpIOTAWallet", isDirectory: true).path
#endif
let nodeUrl = "https://api.lb-0.h.chrysalis-devnet.iota.cafe"
let mnemonic = "season body fog frost focus size journey glimpse size shed blanket jewel wood access kind useful visa peanut midnight extra margin sentence column diesel"
let password = "password"
let alias = "Alice"
