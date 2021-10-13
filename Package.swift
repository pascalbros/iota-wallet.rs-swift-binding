// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "IOTAWallet",
    platforms: [.iOS(.v12), .macOS(.v10_10)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "IOTAWallet",
            type: .dynamic,
            targets: ["IOTAWallet", "IOTAWalletInternal"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .systemLibrary(name: "_IOTAWallet", pkgConfig: nil),
        .target(
            name: "IOTAWallet",
            dependencies: ["IOTAWalletInternal", "_IOTAWallet"],
            linkerSettings: [LinkerSetting.linkedFramework("Security"), LinkerSetting.linkedLibrary("c++")]),
        .binaryTarget(
            name: "IOTAWalletInternal",
            url: "https://www.dropbox.com/s/k5ny8ishldjg39b/IOTAWalletInternal.zip?dl=1",
            checksum: "72f5194bbc17fe4a7cbc0cadcdca4d9b7a3caa76ef3fbc1dd1598e66fd35cbd0"
        ),
        .testTarget(
            name: "IOTAWalletTests",
            dependencies: ["IOTAWallet"]),
    ]
)
