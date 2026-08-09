// swift-tools-version: 6.3

import PackageDescription

let package = Package(
	name: "bar",
	platforms: [.macOS(.v26)],
	dependencies: [
		.package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0")
	],
	targets: [
		.executableTarget(name: "bar"),
		.testTarget(name: "barTests", dependencies: ["bar"]),
	],
	swiftLanguageModes: [.v6]
)
