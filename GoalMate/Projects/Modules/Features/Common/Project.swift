//
//  Project.swift
//  Config
//
//  Created by Importants on 1/2/25.
//

import TuistExtensions
import ProjectDescription

let featureCommon = Project.framework(
    name: "Feature" + Module.feature(.Common).name,
    packages: [
//        .remote(
//            url: "https://github.com/pointfreeco/swift-composable-architecture",
//            requirement: .upToNextMinor(from: "1.16.1")
//        ),
        .remote(
            url: "https://github.com/pointfreeco/swift-sharing",
            requirement: .upToNextMinor(from: "2.0.2")
        ),
        .remote(url: "https://github.com/johnpatrickmorgan/TCACoordinators",
                requirement: .upToNextMajor(from: "0.10.0"))
    ],
    dependencies: [
        Module.Domain.project,
        .package(product: "TCACoordinators", type: .runtime),
        .package(product: "Sharing", type: .runtime),
    ],
    resources: .default
)
