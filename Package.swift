// swift-tools-version: 6.3

import PackageDescription

let package = Package(
	name: "phbar",
	platforms: [.macOS(.v26)],
	targets: [
		.executableTarget(name: "phbar"),
		.testTarget(name: "phbarTests", dependencies: ["phbar"]),
	],
	swiftLanguageModes: [.v6]
)
