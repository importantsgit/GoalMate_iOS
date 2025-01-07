//
//  Project+Extensions.swift
//  AppExtensions
//
//  Created by Importants on 12/4/24.
//

import ProjectDescription

extension Project {
    public static func project(
        name: String,
        product: Product,
        deploymentTargets: DeploymentTargets = Project.deployTarget,
        schemes: [Scheme] = [],
        customTargets: [Target] = [],
        packages: [Package] = [],
        scripts: [TargetScript] = [],
        dependencies: [TargetDependency] = [],
        resources: ProjectDescription.ResourceFileElements? = nil
    ) -> Project {
        let targets: [Target]
        switch product {
        case .app, .framework:
            targets = [
                product == .app ?
                // App
                    .target(
                        name: name,
                        destinations: .iOS,
                        product: product,
                        bundleId: "$(APP_IDENTIFIER)",
                        deploymentTargets: deploymentTargets,
                        infoPlist: .file(path: Path.plistPath("Info")),
                        sources: ["Sources/**"],
                        resources: resources,
                        entitlements: .file(path: .entitlementPath("GoalMate")),
                        scripts: scripts,
                        dependencies: dependencies,
                        settings: .settings(
                            configurations: Configuration.createAppConfiguration(
                                configurations: Configuration.ConfigScheme.allCases
                            )
                        )
                    ) :
                    // Framework
                    .target(
                        name: name,
                        destinations: .iOS,
                        product: product,
                        bundleId: "com.cudo.\(name)",
                        deploymentTargets: deploymentTargets,
                        sources: ["Sources/**"],
                        resources: resources,
                        scripts: scripts,
                        dependencies: dependencies,
                        settings: .settings(
                            configurations: Configuration.makeModuleConfiguration()
                        )
                    ),
                // Test
                .target(
                    name: "\(name)Tests",
                    destinations: .iOS,
                    product: .unitTests,
                    bundleId: self.teamId + ".\(name)Tests",
                    deploymentTargets: deploymentTargets,
                    sources: ["Tests/**"],
                    dependencies: [.target(name: name)],
                    settings: .settings(
                        configurations: Configuration.makeModuleConfiguration()
                    )
                )
            ]
        case .bundle:
            targets = [
                .target(
                    name: name,
                    destinations: .iOS,
                    product: product,
                    bundleId: "com.bundle.\(name)",
                    deploymentTargets: deploymentTargets,
                    resources: resources,
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
            name: name,
            packages: packages,
            targets: targets + customTargets,
            schemes: schemes,
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
        resources: ProjectDescription.ResourceFileElements? = nil
    ) -> Project {
        self.project(
            name: name,
            product: .app,
            deploymentTargets: self.deployTarget,
            customTargets: customTargets,
            packages: packages,
            scripts: [
                .prebuildScript(utility: .swiftLint, name: "Lint")
            ],
            dependencies: dependencies,
            resources: resources
        )
    }
    
    public static func framework(
        name: String,
        customTargets: [Target] = [],
        packages: [Package] = [],
        dependencies: [TargetDependency] = [],
        resources: ProjectDescription.ResourceFileElements? = nil
    ) -> Project {
        self.project(
            name: name,
            product: .framework,
            deploymentTargets: self.deployTarget,
            customTargets: customTargets,
            packages: packages,
            scripts: [
                .prebuildScript(utility: .swiftLint, name: "Lint")
            ],
            dependencies: dependencies,
            resources: resources
        )
    }
    
    public static func bundle(
        name: String,
        resources: ProjectDescription.ResourceFileElements? = nil
    ) -> Project {
        self.project(
            name: name,
            product: .bundle,
            resources: resources
        )
    }
}

