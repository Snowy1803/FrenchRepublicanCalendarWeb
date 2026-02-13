// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "FrenchRepublicanCalendarWeb",
    platforms: [.macOS(.v13)],
    products: [
        .executable(name: "FrenchRepublicanCalendarWeb", targets: ["FrenchRepublicanCalendarWeb"])
    ],
    dependencies: [
        .package(url: "https://github.com/elementary-swift/elementary", from: "0.1.0"),
        .package(url: "https://github.com/elementary-swift/elementary-ui", from: "0.1.0"),
        .package(url: "https://github.com/Snowy1803/FrenchRepublicanCalendarCore", branch: "main"),
        .package(url: "https://github.com/swiftwasm/JavaScriptKit", from: "0.19.0")
    ],
    targets: [
        .executableTarget(
            name: "FrenchRepublicanCalendarWeb",
            dependencies: [
                .product(name: "Elementary", package: "elementary"),
                .product(name: "ElementaryUI", package: "elementary-ui"),
                "FrenchRepublicanCalendarCore",
                .product(name: "JavaScriptKit", package: "JavaScriptKit")
            ]),
        .testTarget(
            name: "FrenchRepublicanCalendarWebTests",
            dependencies: ["FrenchRepublicanCalendarWeb"]),
    ]
)
