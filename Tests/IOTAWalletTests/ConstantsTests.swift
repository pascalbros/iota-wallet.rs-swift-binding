import Foundation

//let storagePath = FileManager.default.temporaryDirectory.appendingPathComponent("IOTAWallet", isDirectory: true).path
#if os(macOS)
let storagePath = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("tmpIOTAWallet", isDirectory: true).path
#elseif os(iOS)
let storagePath = FileManager.default.temporaryDirectory.appendingPathComponent("tmpIOTAWallet", isDirectory: true).path
#endif
let nodeUrl = "https://nodes.devnet.iota.org"
let secretManager = "acoustic trophy damage hint search taste love bicycle foster cradle brown govern endless depend situate athlete pudding blame question genius transfer van random vast"
let mnemonic = "season body fog frost focus size journey glimpse size shed blanket jewel wood access kind useful visa peanut midnight extra margin sentence column diesel"
let mnemonic2 = "clever cross decorate deliver daughter smart evoke clinic furnace quarter wave shine tattoo amazing wrong file dance half obey horror ribbon win person gossip"
let address2 = "atoi1qzqjcfypqa4hwwpr0yw3vn93m4npjaaexhncpwdsu7x4zrj9mtkuyew5hjx"
let password = "password"
let alias = "Alice"
