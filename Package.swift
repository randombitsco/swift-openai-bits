// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "swift-openai-bits",
  platforms: [
    .macOS(.v12),
    .iOS(.v15),
    .tvOS(.v15),
    .watchOS(.v8),
  ],
  products: [
    // Products define the executables and libraries a package produces, and make them visible to other packages.
    .library(
      name: "OpenAIBits",
      targets: ["OpenAIBits"]),
    .library(
      name: "OpenAIBitsTestHelpers",
      targets: ["OpenAIBitsTestHelpers"]),
  ],
  dependencies: [
    // Dependencies dehclare other packages that this package depends on.
    .package(url: "https://github.com/davbeck/MultipartForm", from: "0.1.0"),
    .package(url: "https://github.com/pointfreeco/swift-custom-dump", from: "0.8.0"),
    .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.1.0"),
    .package(url: "https://github.com/apple/swift-format.git", branch: "release/5.7"),
  ],
  targets: [
    // Targets are the basic building blocks of a package. A target can define a module or a test suite.
    // Targets can depend on other targets in this package, and on products in packages this package depends on.
    .target(
      name: "OpenAIBits",
      dependencies: ["MultipartForm"],
      resources: [.copy("models")]),
    .target(
      name: "OpenAIBitsTestHelpers",
      dependencies: [
        "OpenAIBits",
        .product(name: "CustomDump", package: "swift-custom-dump"),
      ]),
    .testTarget(
      name: "OpenAIBitsTests",
      dependencies: [
        "OpenAIBits",
        .product(name: "CustomDump", package: "swift-custom-dump"),
      ]),
  ]
)
