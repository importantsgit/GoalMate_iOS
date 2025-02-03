//
//  Project.swift
//  AppManifests
//
//  Created by Importants on 1/3/25.
//

import TuistExtensions
import ProjectDescription

let profileDependencies: [TargetDependency] = [
    Module.feature(.Profile).project,
    Module.feature(.Common).project
]

let myGoalFeatureDemo = Project.app(
    name: "DemoProfileFeature",
    dependencies: profileDependencies
)
