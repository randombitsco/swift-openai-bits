// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "swift-openai-gpt3",
  platforms: [
    .macOS(.v12),
    .iOS(.v15),
    .tvOS(.v15),
    .watchOS(.v8),
  ],
  products: [
      // Products define the executables and libraries a package produces, and make them visible to other packages.
      .library(
        name: "OpenAIGPT3",
        targets: ["OpenAIGPT3"]),
  ],
  dependencies: [
      // Dependencies declare other packages that this package depends on.
    .package(url: "https://github.com/pointfreeco/swift-custom-dump", from: "0.5.0"),
  ],
  targets: [
      // Targets are the basic building blocks of a package. A target can define a module or a test suite.
      // Targets can depend on other targets in this package, and on products in packages this package depends on.
      .target(
        name: "OpenAIGPT3",
        dependencies: []),
      .testTarget(
        name: "OpenAIGPT3Tests",
        dependencies: [
          "OpenAIGPT3",
          .product(name: "CustomDump", package: "swift-custom-dump")
        ]),
  ]
)
