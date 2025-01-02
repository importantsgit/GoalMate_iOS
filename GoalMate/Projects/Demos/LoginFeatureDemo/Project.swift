//
//  Project.swift
//  AppManifests
//
//  Created by Importants on 1/3/25.
//

import TuistExtensions
import ProjectDescription

let loginDependencies: [TargetDependency] = [
    Module.feature(.Login).project,
    Module.feature(.Common).project
]

let loginFeatureDemo = Project.app(
    name: "DemoLoginFeature",
    dependencies: loginDependencies
)

