//
//  Project.swift
//  AppManifests
//
//  Created by Importants on 1/20/25.
//

import TuistExtensions
import ProjectDescription

let featureMyGoal = Project.framework(
    name: "Feature" + Module.feature(.MyGoal).name,
    dependencies: [
        Module.feature(.Common).project,
        Module.Utils.project
    ]
)
