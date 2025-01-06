// swift-tools-version: 5.9
@preconcurrency import PackageDescription

#if TUIST
@preconcurrency import ProjectDescription

// staticframwork: 정적 링크
// framework: 동적 링크
    let packageSettings = PackageSettings(
        productTypes: [:]
    )
#endif

let package = Package(
    name: "GoalMate",
    dependencies: []
)
