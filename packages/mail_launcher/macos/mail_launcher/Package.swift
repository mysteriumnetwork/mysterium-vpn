// swift-tools-version: 5.9

import PackageDescription

let package = Package(
  name: "mail_launcher",
  platforms: [
    .macOS("12.0")
  ],
  products: [
    .library(name: "mail-launcher", targets: ["mail_launcher"])
  ],
  dependencies: [
    .package(name: "FlutterFramework", path: "../FlutterFramework")
  ],
  targets: [
    .target(
      name: "mail_launcher",
      dependencies: [
        .product(name: "FlutterFramework", package: "FlutterFramework")
      ]
    )
  ]
)
