//
//  Project.swift
//  AppManifests
//
//  Created by Importants on 1/3/25.
//

import TuistExtensions
import ProjectDescription

let utils = Project.framework(
    name: Module.Utils.name,
    packages: [
        .remote(
            url: "https://github.com/pointfreeco/swift-sharing",
            requirement: .upToNextMinor(from: "2.0.2")
        ),
        .remote(url: "https://github.com/johnpatrickmorgan/TCACoordinators",
                requirement: .exact("0.10.0")),
//        .remote(url: "https://github.com/pointfreeco/swift-composable-architecture", requirement: .exact("1.8.0")),
        
    ],
    dependencies: [
        .package(product: "TCACoordinators", type: .runtime),
        .package(product: "Sharing", type: .runtime),
//        .package(product: "ComposableArchitecture", type: .runtime),
    ]
)
