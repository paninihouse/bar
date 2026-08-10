// swift-tools-version: 6.3

import PackageDescription

let package = Package(
	name: "bar",
	platforms: [.macOS(.v26)],
	dependencies: dependencies,
	targets: [
		.executableTarget(name: "bar"),
		.testTarget(name: "barTests", dependencies: ["bar"]),
	],
	swiftLanguageModes: [.v6]
)

// Set dependencies conditionally to streamline build process
var dependencies: [Package.Dependency] {
	var dependencies = [Package.Dependency]()

	if Context.environment["SWIFT_DOCC"] != nil {
		dependencies.append(.package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"))
	}

	return dependencies
}
