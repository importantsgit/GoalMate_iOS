//
//  Project.swift
//  Config
//
//  Created by Importants on 1/2/25.
//

import TuistExtensions
import ProjectDescription

let featureSignUp = Project.framework(
    name: "Feature" + Module.feature(.SignUp).name,
    dependencies: [
        Module.feature(.Common).project,
    ]
)
