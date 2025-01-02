//
//  Project.swift
//  AppManifests
//
//  Created by Importants on 1/3/25.
//

import TuistExtensions
import ProjectDescription

let introDependencies: [TargetDependency] = [
    Module.feature(.Intro).project,
    Module.feature(.Common).project
]

let introFeatureDemo = Project.app(
    name: "DemoIntroFeature",
    dependencies: introDependencies
)
