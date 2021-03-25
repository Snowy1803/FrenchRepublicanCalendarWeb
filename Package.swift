// swift-tools-version:5.3
import PackageDescription
let package = Package(
    name: "FrenchRepublicanCalendarWeb",
    platforms: [.macOS(.v11)],
    products: [
        .executable(name: "FrenchRepublicanCalendarWeb", targets: ["FrenchRepublicanCalendarWeb"])
    ],
    dependencies: [
        .package(name: "Tokamak", url: "https://github.com/TokamakUI/Tokamak", from: "0.6.1"),
        .package(name: "FrenchRepublicanCalendarCore", url: "https://github.com/Snowy1803/FrenchRepublicanCalendarCore", .branch("main"))
    ],
    targets: [
        .target(
            name: "FrenchRepublicanCalendarWeb",
            dependencies: [
                .product(name: "TokamakShim", package: "Tokamak"),
                "FrenchRepublicanCalendarCore"
            ]),
        .testTarget(
            name: "FrenchRepublicanCalendarWebTests",
            dependencies: ["FrenchRepublicanCalendarWeb"]),
    ]
)
