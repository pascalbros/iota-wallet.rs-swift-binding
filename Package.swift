// swift-tools-version:5.5

import PackageDescription

var dependencies: [Target.Dependency] = ["IOTAWalletInternal", "_IOTAWallet"]
var targets = ["IOTAWallet", "IOTAWalletInternal"]

//#if targetEnvironment(simulator)
//dependencies = []
//targets = ["IOTAWallet"]
//#endif

let package = Package(
    name: "IOTAWallet",
    platforms: [.iOS(.v12), .macOS(.v10_10)],
    products: [
        .library(
            name: "IOTAWallet",
            type: .dynamic,
            targets: ["IOTAWallet", "IOTAWalletInternal"]),
    ],
    dependencies: [],
    targets: [
        .systemLibrary(name: "_IOTAWallet", pkgConfig: nil),
        .target(
            name: "IOTAWallet",
            dependencies: dependencies,
            linkerSettings: [LinkerSetting.linkedFramework("Security"), LinkerSetting.linkedLibrary("c++")]),
        .binaryTarget(
            name: "IOTAWalletInternal",
            url: "https://github.com/iotaledger/wallet-ios-internal/releases/download/v0.3.3/IOTAWalletInternal-v0.3.3.zip",
            checksum: "ca42e8f9ce796d20395d654dca05c78b3a630c136e745872731ac0fa5962ea1d"
        ),
        .testTarget(
            name: "IOTAWalletTests",
            dependencies: ["IOTAWallet"]),
    ]
)
