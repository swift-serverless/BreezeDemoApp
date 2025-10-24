// swift-tools-version:6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BreezeFormAPI",
    platforms: [
        .macOS(.v15),
    ],
    products: [
        .executable(name: "FormAPI", targets: ["FormAPI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-serverless/BreezeLambdaDynamoDBAPI.git", from: "1.1.0"),
        .package(url: "https://github.com/awslabs/swift-aws-lambda-runtime.git", from: "2.2.0"),
        .package(path: "../SharedModel")
    ],
    targets: [
        .executableTarget(
            name: "FormAPI",
             dependencies: [
                .product(name: "BreezeLambdaAPI", package: "BreezeLambdaDynamoDBAPI"),
                .product(name: "BreezeDynamoDBService", package: "BreezeLambdaDynamoDBAPI"),
                "SharedModel"
            ]
        )
    ]
)
