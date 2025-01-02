//
//  Project.swift
//  AppManifests
//
//  Created by Importants on 1/3/25.
//

import TuistExtensions
import ProjectDescription

let homeDependencies: [TargetDependency] = [
    Module.feature(.Home).project,
    Module.feature(.Common).project
]

let homeFeatureDemo = Project.app(
    name: "DemoHomeFeature",
    dependencies: homeDependencies
)
