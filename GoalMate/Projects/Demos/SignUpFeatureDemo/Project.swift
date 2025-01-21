//
//  Project.swift
//  Config
//
//  Created by Importants on 1/2/25.
//

import TuistExtensions
import ProjectDescription

let signUpDependencies: [TargetDependency] = [
    Module.feature(.SignUp).project,
    Module.Utils.project
]

let signUpFeatureDemo = Project.app(
    name: "DemoSignUpFeature",
    dependencies: signUpDependencies
)
