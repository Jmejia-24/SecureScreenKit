// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription


let package = Package(
    name: "SecureScreenKit",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "SecureScreenKit",
            targets: ["SecureScreenKit"]
        )
    ],
    targets: [
        .target(
            name: "SecureScreenKit",
            path: "Sources/SecureScreenKit"
        )
    ]
)
