// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CollectionView",
    dependencies: [
        .package(url: "https://github.com/nicklockwood/SwiftFormat",
                 from: "0.41.2"),
        .package(url: "https://github.com/Realm/SwiftLint",
                 from: "0.39.0"),
        .package(url: "https://github.com/shibapm/Komondor.git",
                 from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "CollectionView",
            dependencies: [],
            path: "PackageRequirement/",
            sources: ["Requirement.swift"]
        ),
    ]
)

#if canImport(PackageConfig)
    import PackageConfig

    let config = PackageConfiguration([
        "komondor": [
            "pre-commit": [
                "swift run swiftformat .",
                "swift run swiftlint autocorrect --config '.swiftlint.auto.yml'",
                "git add .",
            ],
        ],
    ]).write()
#endif
