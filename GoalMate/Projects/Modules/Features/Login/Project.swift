//
//  Project.swift
//  AppManifests
//
//  Created by Importants on 1/3/25.
//

import TuistExtensions
import ProjectDescription

let SignUpDependencies: [TargetDependency] = [
    Module.feature(.SignUp).project,
    Module.feature(.Common).project
]

let loginFeatureDemo = Project.app(
    name: "DemoSignUpFeature",
    dependencies: SignUpDependencies
)

