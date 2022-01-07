# IOTA wallet.rs Swift Binding

Swift binding for the official wallet.rs Rust library for IOTA Ledger.

The Swift binding links and communicates with the official Rust implementation [IOTA Wallet Library](https://github.com/iotaledger/wallet.rs)

## Installation

Building the binding requires Xcode 11 or later or a Swift 5.5 toolchain or later with Swift Package Manger.

## Known Issues

- Right now there's no support for `arm64-ios-simulator`, in order to run it, run Xcode with `Rosetta` and you should be able to get `SwiftUI` previews as well as run on simulator.

## Swift Package Manager

Run `swift build` in the root directory of this project.

## Tests

Run `swift test` in the root directory of this project