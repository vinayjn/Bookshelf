// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Bookshelf",
    platforms: [.macOS(.v10_15)],
    products: [
        .library(
            name: "Bookshelf",
            targets: ["Bookshelf"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/tid-kijyun/Kanna.git", from: "5.2.4"),
        .package(url: "https://github.com/scinfu/SwiftSoup.git", from: "2.5.3"),
        .package(url: "https://github.com/stencilproject/Stencil.git", from: "0.14.0"),
    ],
    targets: [
        .target(
            name: "Bookshelf",
            dependencies: [
                "Kanna",
                "Stencil",
                "SwiftSoup",
            ]
        ),
        .testTarget(
            name: "BookshelfTests",
            dependencies: ["Bookshelf"]
        ),
    ]
)
