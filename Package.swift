// swift-tools-version:5.5

import PackageDescription

var dependencies: [Target.Dependency] = ["IOTAWalletInternal", "_IOTAWallet"]
#if targetEnvironment(simulator)
dependencies = []
#endif

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
            url: "https://github.com/iotaledger/wallet-ios-internal/releases/download/v0.2.0/IOTAWalletInternal-v0.2.0.zip",
            checksum: "bd63862dfaf773d3f4ac9c2ced5fad51d74c3cd97d5e0d2aff1d5c25306a98d1"
        ),
        .testTarget(
            name: "IOTAWalletTests",
            dependencies: ["IOTAWallet"]),
    ]
)
