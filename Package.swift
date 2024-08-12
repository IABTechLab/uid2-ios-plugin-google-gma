// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UID2GMAPlugin",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "UID2GMAPlugin",
            targets: ["UID2GMAPlugin"])
    ],
    dependencies: [
        .package(url: "https://github.com/IABTechLab/uid2-ios-sdk.git", "1.7.0" ..< "2.0.0"),
        .package(url: "https://github.com/googleads/swift-package-manager-google-mobile-ads.git", "10.7.0" ..< "12.0.0")
    ],
    targets: [
        .target(
            name: "UID2GMAPlugin",
            dependencies: [
                .product(name: "UID2", package: "uid2-ios-sdk"),
                .product(name: "GoogleMobileAds", package: "swift-package-manager-google-mobile-ads")
            ],
            resources: [
                .copy("PrivacyInfo.xcprivacy")
            ]),
        .testTarget(
            name: "UID2GMAPluginTests",
            dependencies: ["UID2GMAPlugin"]
        )
    ]
)
