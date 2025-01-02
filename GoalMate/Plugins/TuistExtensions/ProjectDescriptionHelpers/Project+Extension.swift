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
                        entitlements: .file(path: .entitlementPath("VIXPassM")),
                        dependencies: dependencies,
                        settings: .settings(
                            configurations: Configuration.configure(
                                isApp: product == .app,
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
                        dependencies: dependencies
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
                        base: [
                            "CODE_SIGN_STYLE": "Automatic",
                            "DEVELOPMENT_TEAM": "$(DEVELOPMENT_TEAM)"
                        ]
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
                            "CODE_SIGN_STYLE": "Manual",
                            "DEVELOPMENT_TEAM": "$(DEVELOPMENT_TEAM)"
                        ]
                    )
                )
            ]
        default: fatalError()
        }
        return .init(
            name: name,
            targets: targets,
            schemes: schemes,
            // 에셋만 필요
            resourceSynthesizers: [.assets()]
        )
    }
    
    public static func app(
        name: String,
        dependencies: [TargetDependency] = [],
        resources: ProjectDescription.ResourceFileElements? = nil
    ) -> Project {
        self.project(
            name: name,
            product: .app,
            deploymentTargets: self.deployTarget,
            dependencies: dependencies,
            resources: resources
        )
    }
    
    public static func framework(
        name: String,
        dependencies: [TargetDependency] = [],
        resources: ProjectDescription.ResourceFileElements? = nil
    ) -> Project {
        self.project(
            name: name,
            product: .framework,
            deploymentTargets: self.deployTarget,
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

