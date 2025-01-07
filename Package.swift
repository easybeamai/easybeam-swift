// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "easybeam-swift",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "easybeam-swift",
            targets: ["easybeam-swift"]),
    ],
    targets: [
        .target(
            name: "easybeam-swift"),
        .testTarget(
            name: "easybeam-swiftTests",
            dependencies: ["easybeam-swift"]),
    ]
)
