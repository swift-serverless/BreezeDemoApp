// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BreezeFormAPI",
    platforms: [
        .macOS(.v13),
    ],
    products: [
        .executable(name: "FormAPI", targets: ["FormAPI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-sprinter/Breeze.git", from: "0.1.0"),
        .package(path: "../SharedModel")
    ],
    targets: [
        .executableTarget(
            name: "FormAPI",
             dependencies: [
                .product(name: "BreezeLambdaAPI", package: "Breeze"),
                .product(name: "BreezeDynamoDBService", package: "Breeze"),
                "SharedModel"
            ]
        )
    ]
)
