// swift-tools-version:5.5

import PackageDescription

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
            dependencies: ["IOTAWalletInternal", "_IOTAWallet"],
            linkerSettings: [LinkerSetting.linkedFramework("Security"), LinkerSetting.linkedLibrary("c++")]),
        .binaryTarget(
            name: "IOTAWalletInternal",
            url: "https://github.com/iotaledger/wallet-ios-internal/releases/download/v0.1.1/IOTAWalletInternal-v0.1.1.zip",
            checksum: "cf0b135e06a54df38258e6947bd65089055f5546ee6aca528e060d068f1c7cee"
        ),
        .testTarget(
            name: "IOTAWalletTests",
            dependencies: ["IOTAWallet"]),
    ]
)
