// swift-tools-version: 6.3

import PackageDescription

let package = Package(
	name: "bar",
	platforms: [.macOS(.v26)],
	targets: [
		.executableTarget(name: "bar"),
		.testTarget(name: "barTests", dependencies: ["bar"]),
	],
	swiftLanguageModes: [.v6]
)
