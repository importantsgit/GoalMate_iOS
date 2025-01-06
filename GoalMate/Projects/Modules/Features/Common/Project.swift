//
//  Project.swift
//  Config
//
//  Created by Importants on 1/2/25.
//

import TuistExtensions
import ProjectDescription

let featureCommon = Project.framework(
    name: Module.feature(.Common).name,
    packages: [
        .remote(
            url: "https://github.com/pointfreeco/swift-composable-architecture",
            requirement: .upToNextMinor(from: "1.16.1")
        )
    ],
    dependencies: [
        Module.Domain.project,
        Module.Utils.project,
        .package(product: "ComposableArchitecture", type: .runtime)
    ]
)
