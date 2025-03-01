//
//  Project+Extensions.swift
//  AppExtensions
//
//  Created by Importants on 12/4/24.
//

import ProjectDescription

extension Project {
    public static func project(
        config: Config
    ) -> Project {
        let targets: [Target]
        switch config.product {
        case .app, .framework:
            targets = [
                config.product == .app ?
                // App
                    .target(
                        name: config.name,
                        destinations: [.iPhone, .macWithiPadDesign],
                        product: config.product,
                        bundleId: "$(APP_IDENTIFIER)",
                        deploymentTargets: config.deploymentTargets,
                        infoPlist: .file(path: Path.plistPath("Info")),
                        sources: config.sources,
                        resources: config.resources,
                        entitlements: .file(path: .entitlementPath("GoalMate")),
                        scripts: config.scripts,
                        dependencies: config.dependencies,
                        settings: .settings(
                            configurations: Configuration.createAppConfiguration(
                                configurations: Configuration.ConfigScheme.allCases
                            )
                        )
                    ) :
                    // Framework
                    .target(
                        name: config.name,
                        destinations: .iOS,
                        product: config.product,
                        bundleId: "com.cudo.\(config.name)",
                        deploymentTargets: config.deploymentTargets,
                        sources: ["Sources/**"],
                        resources: config.resources,
                        scripts: config.scripts,
                        dependencies: config.dependencies,
                        settings: .settings(
                            configurations: Configuration.makeModuleConfiguration()
                        )
                    ),
                // Test
                .target(
                    name: "\(config.name)Tests",
                    destinations: .iOS,
                    product: .unitTests,
                    bundleId: self.teamId + ".\(config.name)Tests",
                    deploymentTargets: config.deploymentTargets,
                    sources: config.testSources,
                    dependencies: [.target(name: config.name)],
                    settings: .settings(
                        configurations: Configuration.makeModuleConfiguration()
                    )
                )
            ]
        case .bundle:
            targets = [
                .target(
                    name: config.name,
                    destinations: .iOS,
                    product: config.product,
                    bundleId: "com.bundle.\(config.name)",
                    deploymentTargets: config.deploymentTargets,
                    resources: config.resources,
                    settings: .settings(
                        base: [
                            "GENERATE_ASSET_SYMBOLS": "YES"
                        ],
                        configurations: Configuration.makeModuleConfiguration()
                    )
                )
            ]
        default: fatalError()
        }
        return .init(
            name: config.name,
            packages: config.packages,
            targets: targets + config.customTargets,
            schemes: config.schemes,
            resourceSynthesizers: [
                .custom(name: "Assets", parser: .assets, extensions: ["xcassets"]),
                .custom(name: "Fonts", parser: .fonts, extensions: ["otf"]),
            ]
        )
    }
    
    public static func app(
        name: String,
        customTargets: [Target] = [],
        packages: [Package] = [],
        dependencies: [TargetDependency] = [],
        resources: ProjectDescription.ResourceFileElements? = nil,
        sources: SourceFilesList? = [],
        testSources: SourceFilesList? = []
    ) -> Project {
        self.project(
            config: ProjectConfig.init(
                name: name,
                customTargets: customTargets,
                packages: packages,
                scripts: [
                    .prebuildScript(utility: .swiftLint, name: "Lint")
                ],
                dependencies: dependencies,
                resources: resources,
                sources: sources,
                testSources: testSources
            )
        )
    }
    
    public static func framework(
        name: String,
        customTargets: [Target] = [],
        packages: [Package] = [],
        dependencies: [TargetDependency] = [],
        resources: ProjectDescription.ResourceFileElements? = nil,
        sources: SourceFilesList? = []
    ) -> Project {
        self.project(
            config: FrameworkConfig.init(
                name: name,
                customTargets: customTargets,
                packages: packages,
                scripts: [
                    .prebuildScript(utility: .swiftLint, name: "Lint")
                ],
                dependencies: dependencies,
                resources: resources,
                sources: sources
            )
        )
    }
    
    public static func bundle(
        name: String,
        resources: ProjectDescription.ResourceFileElements? = nil
    ) -> Project {
        self.project(
            config: BundleConfig.init(
                name: name,
                resources: resources
            )
        )
    }
}
