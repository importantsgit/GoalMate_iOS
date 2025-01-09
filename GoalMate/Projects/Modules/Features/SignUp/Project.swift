//
//  Project.swift
//  AppManifests
//
//  Created by Importants on 1/3/25.
//

import TuistExtensions
import ProjectDescription

let featureSignUp = Project.framework(
    name: "Feature" + Module.feature(.SignUp).name,
    dependencies: [
        Module.feature(.Common).project
    ]
)
